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
- (SEShape *)shapeWithIndex:(NSUInteger)idx;

- (void)addShape:(SEShape *)shape;
- (void)removeShape:(SEShape *)shape;
- (void)returnShape:(SEShape *)shape;

- (void)updateShape:(SEShape *)shape withParams:(NSDictionary *)params;
- (void)updateShape:(SEShape *)shape withState:(BOOL)selected;
- (void)updateShape:(SEShape *)shape withPosition:(CGPoint)position;
- (void)updateShape:(SEShape *)shape withSize:(CGSize)size;
- (void)updateShape:(SEShape *)shape withSize:(CGSize)size andPosition:(CGPoint)position;

@end
