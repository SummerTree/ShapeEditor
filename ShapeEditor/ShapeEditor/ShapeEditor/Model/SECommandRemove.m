//
//  SECommandRemove.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommandRemove.h"

@interface SECommandRemove() {
    NSUInteger _atIndex;
}

@end

@implementation SECommandRemove

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
{
    if (self = [self init]) {
        _workArea = workArea;
        _shape = shape;
    }
    
    return self;
}

- (void)execute
{
    _atIndex = [_workArea currentIndexOfShape:_shape];
    [_workArea removeShape:_shape];
}

- (void)rollback
{
    [_workArea addShape:_shape atIndex:_atIndex];
}

@end
