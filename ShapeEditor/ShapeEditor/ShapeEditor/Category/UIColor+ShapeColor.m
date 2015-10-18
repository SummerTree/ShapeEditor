//
//  UIColor+ShapeColor.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 17.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "UIColor+ShapeColor.h"

@implementation UIColor (ShapeColor)

+ (UIColor *)shapeFillColor
{
    return [UIColor colorWithRed:0 green:122.0/255.0 blue:1.0 alpha:1];
}

+ (UIColor *)shapeStrokeColor
{
    return [UIColor colorWithRed:0 green:77.0/255.0 blue:161.0/255.0 alpha:1];
}

@end
