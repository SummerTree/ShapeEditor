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
#import "SEShapeSelectionView.h"

static const float kSEShapeViewRectMinWidth = 10.0f;
static const float kSEShapeViewRectMinHeight = 10.0f;

static const float kSEShapeViewRectInsetDx = 6.0f;
static const float kSEShapeViewRectInsetDy = 6.0f;

static const float kSEShapeViewResizeAreaWidth = 30.0f;
static const float kSEShapeViewResizeAreaHeight = 30.0f;

@protocol SEShapeViewDelegate <NSObject>
@optional

- (void)onUpdateViewWithShape:(SEShape *)shape;
- (void)onShapeTapped:(SEShape *)shape;
- (void)onShapeMoving:(SEShape *)shape newFrame:(CGRect)newFrame;
- (void)didShapeMoved:(SEShape *)shape newFrame:(CGRect)newFrame;

@end


@interface SEShapeView : UIView <UIGestureRecognizerDelegate, SEShapeSelectionViewDelegate>

@property (nonatomic, weak) id<SEShapeViewDelegate> delegate;
@property (nonatomic, weak) id<SEShapeViewDelegate> delegateForSel;
@property (nonatomic, strong) SEShape *shape;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithShape:(SEShape *)shape;
- (void)updateViewWithShape:(SEShape *)shape;

//abstract
- (BOOL)pointInsideFigure:(CGPoint)point;

@end
