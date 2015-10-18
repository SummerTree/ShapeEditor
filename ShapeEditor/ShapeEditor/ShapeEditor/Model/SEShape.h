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

static NSString *const kSEShapeParamPosition = @"position";
static NSString *const kSEShapeParamSize = @"size";

typedef enum : NSUInteger {
    SEShapeTypeTriangle,
    SEShapeTypeCircle,
    SEShapeTypeRectangle,
} SEShapeType;

@interface SEShape : NSObject 

@property (nonatomic, assign) SEShapeType type;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL selected;

- (SEShape *)initWithType:(SEShapeType)shapeType;
- (SEShape *)initWithType:(SEShapeType)shapeType position:(CGPoint)shapePosition;
- (SEShape *)initWithType:(SEShapeType)shapeType size:(CGSize)shapeSize position:(CGPoint)shapePosition;

- (NSDictionary *)paramsDict;

@end
