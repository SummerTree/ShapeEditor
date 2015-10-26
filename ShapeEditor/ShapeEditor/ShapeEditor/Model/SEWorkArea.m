//
//  SEWorkArea.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEWorkArea.h"
#import "SEShapesStorage.h"

@interface SEWorkArea()

@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, assign) NSUInteger maxIndexNum;

@end

@implementation SEWorkArea

+ (SEWorkArea *)sharedInstance
{
    static SEWorkArea *sharedInstance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[SEWorkArea alloc] init];
    });
    return sharedInstance;
}

- (SEWorkArea *)init
{
    if (self = [super init]) {
        self.shapes = [NSMutableArray array];
        self.maxIndexNum = 0;
    }
    
    return self;
}

- (void)restoreShapes
{
    [SEShapesStorage reStoreShapes:^(NSArray *shapes) {
        if (shapes) {
            self.shapes = [shapes mutableCopy];
            
            [self.shapes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                ((SEShape *)obj).index = idx + 1;
            }];
            
            self.maxIndexNum = [self.shapes count];
        }
        
        if ([self.delegate respondsToSelector:@selector(shapesRestoreComplete)]) {
            [self.delegate shapesRestoreComplete];
        }
    }];
}

#pragma mark - misc

- (void)enumerateShapesUsingBlock:(BOOL (^)(SEShape *shape))block
{
    BOOL stop = NO;
    for (SEShape *shapeObj in self.shapes) {
        if (block) stop = block(shapeObj);
        if (stop) break;
    }
}

- (SEShape *)shapeWithIndex:(NSUInteger)idx
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((SEShape *)evaluatedObject).index == idx;
    }];
    
    return [[self.shapes filteredArrayUsingPredicate:predicate] firstObject];
}

- (SEShape *)topShape
{
    return [self.shapes lastObject];
}

- (NSUInteger)nextIndexNum
{
    return ++_maxIndexNum;
}

#pragma mark - Actions

- (void)addShape:(SEShape *)shape
{
    shape.index = [self nextIndexNum];
    [self.shapes addObject:shape];
    
    if ([self.delegate respondsToSelector:@selector(didShapeAdded:)]) {
        [self.delegate didShapeAdded:shape];
    }
    
    [SEShapesStorage storeShapes:self.shapes];
}

- (void)removeShape:(SEShape *)shape
{
    NSUInteger idx = [self.shapes indexOfObject:shape];
    if (idx != NSNotFound) {
        [self.shapes removeObjectAtIndex:idx];

        if ([self.delegate respondsToSelector:@selector(didShapeRemoved:)]) {
            [self.delegate didShapeRemoved:shape];
        }
        
        [SEShapesStorage storeShapes:self.shapes];
    }
}

- (void)returnShape:(SEShape *)shape
{
    int idxForInsert = -1;
    
    if ([self.shapes count]) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            return ((SEShape *)evaluatedObject).index > shape.index;
        }];
        
        SEShape *nextShape = [[self.shapes filteredArrayUsingPredicate:predicate] firstObject];
        
        if (nextShape) idxForInsert = (int)[self.shapes indexOfObject:nextShape];
    }
    
    if (idxForInsert >= 0) {
        [self.shapes insertObject:shape atIndex:idxForInsert];
    } else {
        [self.shapes addObject:shape];
    }
    
    if ([self.delegate respondsToSelector:@selector(didShapeRemoved:)]) {
        [self.delegate didShapeAdded:shape];
    }
    
    [SEShapesStorage storeShapes:self.shapes];
}

#pragma mark - shape update

- (void)updateShape:(SEShape *)shape withParams:(SEShapeParams)params
{
    if ([self.delegate respondsToSelector:@selector(willShapeChange:)]) {
        [self.delegate willShapeChange:shape];
    }
    
    [shape setParams:params];
    
    if ([self.delegate respondsToSelector:@selector(didShapeChanged:)]) {
        [self.delegate didShapeChanged:shape];
    }
    
    [SEShapesStorage storeShapes:self.shapes];
}

@end
