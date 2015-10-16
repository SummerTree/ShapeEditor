//
//  SEShape.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEShape.h"

@implementation SEShape

- (SEShape *)initWithType:(SEShapeType)shapeType
{
    if (self = [super init])
    {
        _type = shapeType;
        _size = CGSizeMake(100, 100);
        _position = CGPointMake(0, 0);
        _zOrder = 0;
        _selected = false;
    }
    return self;
}

- (SEShape *)initWithType:(SEShapeType)shapeType size:(CGSize)shapeSize position:(CGPoint)shapePosition
{
    if (self = [self initWithType:shapeType])
    {
        _size = shapeSize;
        _position = shapePosition;
    }
    return self;
}

@end
