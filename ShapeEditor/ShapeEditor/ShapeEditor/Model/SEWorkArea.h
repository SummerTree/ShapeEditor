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

- (void)shapesRestoreComplete;

- (void)didShapeAdded:(SEShape *)shape;
- (void)didShapeRemoved:(SEShape *)shape;
- (void)willShapeChange:(SEShape *)shape;
- (void)didShapeChanged:(SEShape *)shape;

@end


@interface SEWorkArea : NSObject

@property (nonatomic, weak) id<SEWorkAreaDelegate> delegate;
@property (nonatomic, strong) SEShape *selectedShape;

#ifdef UNIT_TESTS
@property (nonatomic, strong) NSMutableArray *shapes;
@property (nonatomic, assign) NSUInteger maxIndexNum;
#endif

+ (SEWorkArea *)sharedInstance;

- (void)restoreShapes;

- (void)enumerateShapesUsingBlock:(BOOL (^)(SEShape *shape))block;
- (SEShape *)shapeWithIndex:(NSUInteger)idx;
- (SEShape *)topShape;

- (void)addShape:(SEShape *)shape;
- (void)removeShape:(SEShape *)shape;
- (void)returnShape:(SEShape *)shape;

- (void)updateShape:(SEShape *)shape withParams:(SEShapeParams)params;

@end
