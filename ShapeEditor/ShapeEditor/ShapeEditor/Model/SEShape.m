//
//  SEShape.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEShape.h"

@implementation SEShape

- (SEShape *)initWithType:(SEShapeType)shapeType
{
    if (self = [super init])
    {
        _type = shapeType;
        _size = CGSizeMake(kShapeSizeWidth, kShapeSizeHeight);
        _position = CGPointMake(0, 0);
        _index = 0;
        _selected = NO;
    }
    return self;
}

- (SEShape *)initWithType:(SEShapeType)shapeType position:(CGPoint)shapePosition
{
    if (self = [self initWithType:shapeType])
    {
        _position = shapePosition;
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

#pragma mark - params

- (NSDictionary *)paramsDict
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            [NSValue valueWithCGPoint:self.position], kSEShapeParamPosition,
            [NSValue valueWithCGSize:self.size], kSEShapeParamSize,
            nil];
}


@end
