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

static const float kShapeViewRectInsetDx = 6.0f;
static const float kShapeViewRectInsetDy = 6.0f;


@protocol SEShapeViewDelegate <NSObject>

- (void)shapeTapped:(SEShape *)shape selected:(BOOL)selected;
- (void)shapeMoved:(SEShape *)shape position:(CGPoint)position;
- (void)shapeMoved:(SEShape *)shape withSize:(CGSize)size andPosition:(CGPoint)position;

@end


@interface SEShapeView : UIView

@property (nonatomic, weak) id<SEShapeViewDelegate> delegate;
@property (nonatomic, strong) SEShape *shape;

- (instancetype)initWithShape:(SEShape *)shape;
- (void)updateViewWithShape:(SEShape *)shape;

@end
