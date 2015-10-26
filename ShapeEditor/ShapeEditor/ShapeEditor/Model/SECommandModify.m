//
//  SECommandModify.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SECommandModify.h"

@implementation SECommandModify
@synthesize shape = _shape;

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
                   andNewParams:(SEShapeParams)newParams;
{
    if (self = [super init]) {
        _workArea = workArea;
        _shape = shape;
        _newParams = newParams;
        _oldParams = [shape params];
    }
    
    return self;
}

- (void)execute
{
    [_workArea updateShape:_shape withParams:_newParams];
}

- (void)rollback
{
    [_workArea updateShape:_shape withParams:_oldParams];
}

@end
