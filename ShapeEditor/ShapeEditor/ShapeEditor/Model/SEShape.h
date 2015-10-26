//
//  SEShape.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

static const float kShapeSizeWidth = 100.0f;
static const float kShapeSizeHeight = 100.0f;

typedef struct {
    CGRect frame;
} SEShapeParams;

typedef enum : NSUInteger {
    SEShapeTypeTriangle,
    SEShapeTypeCircle,
    SEShapeTypeRectangle,
} SEShapeType;

@interface SEShape : NSObject 

@property (nonatomic, assign) SEShapeType type;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, assign) NSUInteger index;

- (SEShape *)initWithType:(SEShapeType)shapeType;
- (SEShape *)initWithType:(SEShapeType)shapeType position:(CGPoint)shapePosition;
- (SEShape *)initWithType:(SEShapeType)shapeType frame:(CGRect)shapeFrame;

- (SEShapeParams)params;
- (void)setParams:(SEShapeParams)params;
+ (BOOL)params:(SEShapeParams)params1 equalToParams:(SEShapeParams)params2;

@end
