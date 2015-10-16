//
//  HStack.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HStack : NSObject{
    NSMutableArray* _m_array;
    NSUInteger _count;
}

- (void)push:(id)anObject;
- (id)pop;

- (NSUInteger)itemsCount;
- (id)itemAtIndex:(NSUInteger)index;

- (void)clear;
- (void)clearFromIndex:(NSUInteger)index;
- (void)clearAfterIndex:(NSUInteger)index;

@end
