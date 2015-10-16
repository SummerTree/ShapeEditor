//
//  SEWorkArea.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEShape.h"

@protocol SEWorkAreaDelegate <NSObject>

- (void)updateAllShapeViews;
- (void)showShapeViewWithIndex:(NSUInteger)idx;
- (void)hideShapeViewWithIndex:(NSUInteger)idx;

@end


@interface SEWorkArea : NSObject

@property (nonatomic, weak) id<SEWorkAreaDelegate> delegate;

+ (SEWorkArea *)sharedInstance;

- (SEShape *)selectedShape;
- (NSUInteger)currentIndexOfShape:(SEShape *)shape;

- (void)addShape:(SEShape *)shape;
- (void)addShape:(SEShape *)shape atIndex:(NSUInteger)atIndex;
- (void)removeShape:(SEShape *)shape;
- (void)replaceShape:(SEShape *)shape withShape:(SEShape *)newShape;
- (void)changeShape:(SEShape *)shape withState:(BOOL)selected;

@end
