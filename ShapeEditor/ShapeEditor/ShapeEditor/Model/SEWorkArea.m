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

- (SEShape *)selectedShape
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((SEShape *)evaluatedObject).selected == YES;
    }];
    
    return [[self.shapes filteredArrayUsingPredicate:predicate] firstObject];
}

- (SEShape *)shapeWithIndex:(NSUInteger)idx
{
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ((SEShape *)evaluatedObject).index == idx;
    }];
    
    return [[self.shapes filteredArrayUsingPredicate:predicate] firstObject];
}

- (NSUInteger)nextIndexNum
{
    return ++_maxIndexNum;
}

- (void)refreshAllShapes
{
    if ([self.delegate respondsToSelector:@selector(updateAllShapeViews)]) {
        [self.delegate updateAllShapeViews];
    }
}

- (void)showViewShape:(SEShape *)shape withSelect:(BOOL)needSelect
{
    if ([self.delegate respondsToSelector:@selector(showShapeViewWithIndex:)]) {
        [self.delegate showShapeViewWithIndex:shape.index];
    }
    
    if (needSelect) [self updateShape:shape withState:YES];

    [SEShapesStorage storeShapes:self.shapes];
}

- (void)hideViewShape:(SEShape *)shape
{
    if ([self.delegate respondsToSelector:@selector(hideShapeViewWithIndex:)]) {
        [self.delegate hideShapeViewWithIndex:shape.index];
    }

    [SEShapesStorage storeShapes:self.shapes];
}

#pragma mark - Actions

- (void)addShape:(SEShape *)shape
{
    shape.index = [self nextIndexNum];
    [self.shapes addObject:shape];
    [self showViewShape:shape withSelect:YES];
}

- (void)removeShape:(SEShape *)shape
{
    NSUInteger idx = [self.shapes indexOfObject:shape];
    if (idx != NSNotFound) {
        shape.selected = NO;
        [self.shapes removeObjectAtIndex:idx];
        [self hideViewShape:shape];
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
    
    [self showViewShape:shape withSelect:YES];
}

- (void)clearSelection
{
    SEShape *shape = [self selectedShape];
    if (shape) [self updateShape:shape withState:NO];
}

#pragma mark - shape update

- (void)updateShape:(SEShape *)shape withParams:(NSDictionary *)params
{
    NSValue *val = [params objectForKey:kSEShapeParamPosition];
    if (val) shape.position = [val CGPointValue];
    
    val = [params objectForKey:kSEShapeParamSize];
    if (val) shape.size = [val CGSizeValue];
    
    [self showViewShape:shape withSelect:YES];
}

- (void)updateShape:(SEShape *)shape withState:(BOOL)selected
{
    shape.selected = selected;
    
    for (SEShape *shapeObj in self.shapes) {
        if (shape.index != shapeObj.index) {
            shapeObj.selected = NO;
        }
    }
    
    [self refreshAllShapes];
}

- (void)updateShape:(SEShape *)shape withPosition:(CGPoint)position
{
    shape.position = position;
    [self showViewShape:shape withSelect:YES];
}

- (void)updateShape:(SEShape *)shape withSize:(CGSize)size
{
    shape.size = size;
    [self showViewShape:shape withSelect:YES];
}

- (void)updateShape:(SEShape *)shape withSize:(CGSize)size andPosition:(CGPoint)position
{
    shape.size = size;
    shape.position = position;
    [self showViewShape:shape withSelect:YES];
}

@end
