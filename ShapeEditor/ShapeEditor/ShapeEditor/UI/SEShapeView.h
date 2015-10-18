//
//  SEShapeView.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEWorkArea.h"
#import "SEShape.h"
#import "UIColor+ShapeColor.h"

static const float kSEShapeViewRectMinWidth = 10.0f;
static const float kSEShapeViewRectMinHeight = 10.0f;

static const float kSEShapeViewRectInsetDx = 6.0f;
static const float kSEShapeViewRectInsetDy = 6.0f;

static const float kSEShapeViewResizeAreaWidth = 30.0f;
static const float kSEShapeViewResizeAreaHeight = 30.0f;

@protocol SEShapeViewDelegate <NSObject>

- (void)shapeTapped:(SEShape *)shape selected:(BOOL)selected;
- (void)shapeMoved:(SEShape *)shape position:(CGPoint)position;
- (void)shapeMoved:(SEShape *)shape withSize:(CGSize)size andPosition:(CGPoint)position;

@end


@interface SEShapeView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<SEShapeViewDelegate> delegate;
@property (nonatomic, strong) SEShape *shape;

- (instancetype)initWithShape:(SEShape *)shape;
- (void)updateViewWithShape:(SEShape *)shape;
- (void)refreshView;

@end
