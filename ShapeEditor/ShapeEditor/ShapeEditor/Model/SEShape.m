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

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self.type = [decoder decodeIntegerForKey:@"type"];
        self.position = [decoder decodeCGPointForKey:@"position"];
        self.size = [decoder decodeCGSizeForKey:@"size"];
        self.index = [decoder decodeIntegerForKey:@"index"];
        self.selected = [decoder decodeBoolForKey:@"selected"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeInteger:self.type forKey:@"type"];
    [encoder encodeCGPoint:self.position forKey:@"position"];
    [encoder encodeCGSize:self.size forKey:@"size"];
    [encoder encodeInteger:self.index forKey:@"index"];
    [encoder encodeBool:self.selected forKey:@"selected"];
}

- (BOOL)isEqual:(id)object
{
    SEShape *shape = (SEShape *)object;
    
    if (shape.index == self.index &&
        CGPointEqualToPoint(shape.position, self.position) &&
        CGSizeEqualToSize(shape.size, self.size) &&
        shape.type == self.type &&
        shape.selected == self.selected) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)hash {
    NSString *data = [NSString stringWithFormat:@"%lu %@ %@ %lu %d",
                      (unsigned long)self.type,
                      NSStringFromCGPoint(self.position),
                      NSStringFromCGSize(self.size),
                      (unsigned long)self.index,
                      self.selected];
    
    return [data hash];
}

- (id)copyWithZone:(NSZone *)zone
{
    SEShape *shape = [[SEShape allocWithZone:zone] initWithType:self.type size:self.size position:self.position];
    shape.selected = self.selected;
    shape.index = self.index;
    
    return shape;
}



@end
