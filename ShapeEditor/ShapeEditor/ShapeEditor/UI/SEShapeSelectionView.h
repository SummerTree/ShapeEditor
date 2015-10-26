//
//  SEShapeSelectionView.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 25.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SEShapeView;
@protocol SEShapeViewDelegate;

@protocol SEShapeSelectionViewDelegate <NSObject>

- (void)didSelectionResized:(CGRect)newFrame;
- (void)onSelectionResizing:(CGRect)newFrame;

@end


@interface SEShapeSelectionView : UIView <SEShapeViewDelegate>

@property (nonatomic, weak) SEShapeView *view;
@property (nonatomic, weak) id<SEShapeSelectionViewDelegate> delegate;
@property (nonatomic, weak) SEShapeView *shapeView;

- (void)selectShapeView:(SEShapeView *)shapeView;
- (void)hideSelection;

@end
