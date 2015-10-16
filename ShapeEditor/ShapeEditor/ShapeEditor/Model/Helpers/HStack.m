//
//  HStack.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "HStack.h"

@implementation HStack

- (id)init
{
    if( self=[super init] )
    {
        _m_array = [[NSMutableArray alloc] init];
        _count = 0;
    }
    return self;
}

#pragma mark - push/pop

- (void)push:(id)anObject
{
    [_m_array addObject:anObject];
    _count = [_m_array count];
}

- (id)pop
{
    id obj = nil;
    if(_m_array.count > 0)
    {
        obj = [_m_array lastObject];
        [_m_array removeLastObject];
        _count = [_m_array count];
    }
    return obj;
}

#pragma mark - misc

- (NSUInteger)itemsCount
{
    return [_m_array count];
}

- (id)itemAtIndex:(NSUInteger)index
{
    id obj = nil;
    
    if (index < _count)
        obj = [_m_array objectAtIndex:index];
    
    return obj;
}

#pragma mark - clear

- (void)clear
{
    [_m_array removeAllObjects];
    _count = 0;
}

- (void)clearFromIndex:(NSUInteger)index
{
    index = (index < _count)? index: (_count - 1);
    
    NSRange range = NSMakeRange(0, index);
    _m_array = [[_m_array subarrayWithRange:range] mutableCopy];
    _count = index;
}

- (void)clearAfterIndex:(NSUInteger)index
{
    [self clearFromIndex:++index];
}

@end
