//
//  SECommandAdd.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommandAdd.h"

@implementation SECommandAdd

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape;
{
    if (self = [self init]) {
        _workArea = workArea;
        _shape = shape;
    }
    
    return self;
}

- (void)execute
{
    [_workArea addShape:_shape];
}

- (void)rollback
{
    [_workArea removeShape:_shape];
}

@end