//
//  SECommandModify.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommandModify.h"

@implementation SECommandModify

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
                    andNewShape:(SEShape *)newShape;
{
    if (self = [self init]) {
        _workArea = workArea;
        _shape = shape;
        _newShape = newShape;
    }
    
    return self;
}

- (void)execute
{
    [_workArea replaceShape:_shape withShape:_newShape];
}

- (void)rollback
{
    [_workArea replaceShape:_newShape withShape:_shape];
}

@end
