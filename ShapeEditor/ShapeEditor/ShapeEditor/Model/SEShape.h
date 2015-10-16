//
//  SEShape.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

typedef enum : NSUInteger {
    SEShapeTypeTriangle,
    SEShapeTypeCircle,
    SEShapeTypeRectangle,
} SEShapeType;

@interface SEShape : NSObject {
    SEShapeType _type;
    CGSize _size;
    CGPoint _position;
}

@property (nonatomic, assign) NSUInteger zOrder;
@property (nonatomic, assign) BOOL selected;

- (SEShape *)initWithType:(SEShapeType)shapeType;
- (SEShape *)initWithType:(SEShapeType)shapeType size:(CGSize)shapeSize position:(CGPoint)shapePosition;

@end
