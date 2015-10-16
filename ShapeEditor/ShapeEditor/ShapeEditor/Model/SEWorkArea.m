//
//  SEWorkArea.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEWorkArea.h"

@interface SEWorkArea()

@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, assign) NSUInteger maxZOrderNum;

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
        self.maxZOrderNum = 0;
    }
    
    return self;
}

#pragma mark - misc

- (SEShape *)selectedShape
{
    __block SEShape *selectedShape = nil;
    [self.shapes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SEShape *shape = (SEShape *)obj;
        if (shape.selected) {
            selectedShape = shape;
            *stop = true;
        }
    }];
    
    return selectedShape;
}

- (NSUInteger)currentIndexOfShape:(SEShape *)shape
{
    return [self.shapes indexOfObject:shape];
}

- (NSUInteger)nextZOrderNum
{
    return ++_maxZOrderNum;
}

- (void)showShapeWithIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(showShapeViewWithIndex:)]) {
        [self.delegate showShapeViewWithIndex:index];
    }
}

- (void)hideShapeWithIndex:(NSUInteger)index
{
    if ([self.delegate respondsToSelector:@selector(hideShapeViewWithIndex:)]) {
        [self.delegate hideShapeViewWithIndex:index];
    }
}

#pragma mark - Actions

- (void)addShape:(SEShape *)shape
{
    shape.zOrder = [self nextZOrderNum];
    [self.shapes addObject:shape];
    [self showShapeWithIndex:[self.shapes count] - 1];
}

- (void)addShape:(SEShape *)shape atIndex:(NSUInteger)atIndex
{
    shape.zOrder = [self nextZOrderNum];
    [self.shapes insertObject:shape atIndex:atIndex];
    [self showShapeWithIndex:atIndex];
}

- (void)removeShape:(SEShape *)shape
{
    NSUInteger idx = [self.shapes indexOfObject:shape];
    if (idx != NSNotFound) {
        [self.shapes removeObjectAtIndex:idx];
        [self hideShapeWithIndex:idx];
    }
}

- (void)replaceShape:(SEShape *)shape withShape:(SEShape *)newShape
{
    NSUInteger idx = [self currentIndexOfShape:shape];
    if (idx != NSNotFound) {
        [self.shapes replaceObjectAtIndex:idx withObject:newShape];
        [self showShapeWithIndex:idx];
    }
}

- (void)changeShape:(SEShape *)shape withState:(BOOL)selected
{
    shape.selected = selected;
    
    [self.shapes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SEShape *shapeObj = (SEShape *)obj;
        if (shape != shapeObj) {
            shapeObj.selected = false;
        }
    }];
    
    if ([self.delegate respondsToSelector:@selector(updateAllShapeViews)]) {
        [self.delegate updateAllShapeViews];
    }
}


@end
