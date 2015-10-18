//
//  SEShapesStorage.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 18.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SEShapesStorage : NSObject

+ (void)storeShapes:(NSArray *)shapes;
+ (void)reStoreShapes:(void(^)(NSArray *shapes))result;

@end
