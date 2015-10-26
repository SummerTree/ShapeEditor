//
//  SECommandRemove.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommandRemove.h"

@implementation SECommandRemove
@synthesize shape = _shape;

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
{
    if (self = [super init]) {
        _workArea = workArea;
        _shape = shape;
    }
    
    return self;
}

- (void)execute
{
    [_workArea removeShape:_shape];
}

- (void)rollback
{
    [_workArea returnShape:_shape];
}

@end
