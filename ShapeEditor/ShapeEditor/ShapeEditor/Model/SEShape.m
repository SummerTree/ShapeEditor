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
        _frame = CGRectMake(0, 0, kShapeSizeWidth, kShapeSizeHeight);
        _index = 0;
    }
    return self;
}

- (SEShape *)initWithType:(SEShapeType)shapeType position:(CGPoint)shapePosition
{
    if (self = [self initWithType:shapeType])
    {
        _frame.origin = shapePosition;
    }
    return self;
}

- (SEShape *)initWithType:(SEShapeType)shapeType frame:(CGRect)shapeFrame
{
    if (self = [self initWithType:shapeType])
    {
        _frame = shapeFrame;
    }
    return self;
}

#pragma mark - params

- (SEShapeParams)params
{
    SEShapeParams params;
    params.frame = self.frame;
    
    return params;
}

- (void)setParams:(SEShapeParams)params
{
    self.frame = params.frame;
}

+ (BOOL)params:(SEShapeParams)params1 equalToParams:(SEShapeParams)params2
{
    if (CGRectEqualToRect(params1.frame, params2.frame)) {
        return YES;
    }
    
    return NO;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.type = [decoder decodeIntegerForKey:@"type"];
        self.frame = [decoder decodeCGRectForKey:@"frame"];
        self.index = [decoder decodeIntegerForKey:@"index"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeCGRect:self.frame forKey:@"frame"];
    [encoder encodeInteger:self.index forKey:@"index"];
}

- (BOOL)isEqual:(id)object
{
    SEShape *shape = (SEShape *)object;
    
    if (shape.index == self.index &&
        CGRectEqualToRect(shape.frame, self.frame) &&
        shape.type == self.type) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash {
    NSString *data = [NSString stringWithFormat:@"%lu %@ %lu",
                      (unsigned long)self.type,
                      NSStringFromCGRect(self.frame),
                      (unsigned long)self.index];
    
    return [data hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    SEShape *shape = [[SEShape allocWithZone:zone] initWithType:self.type frame:self.frame];
    shape.index = self.index;
    
    return shape;
}



@end
