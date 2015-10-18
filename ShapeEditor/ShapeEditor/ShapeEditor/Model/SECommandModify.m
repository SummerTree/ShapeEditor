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
                   andNewParams:(NSDictionary *)newParams;
{
    if (self = [self init]) {
        _workArea = workArea;
        _shape = shape;
        _newParams = newParams;
        _oldParams = [shape paramsDict];
        _type = [self modifiedTypeFromParams:newParams];
    }
    
    return self;
}

- (SECommandModifyType)modifiedTypeFromParams:(NSDictionary *)params
{
    BOOL hasPosition = [params objectForKey:kSEShapeParamPosition] != nil;
    BOOL hasSize = [params objectForKey:kSEShapeParamSize] != nil;
    
    if (hasPosition && hasSize) {
        return SECommandModifyTypeSizeAndPosition;
    } else if (hasSize) {
        return SECommandModifyTypeSize;
    } else if (hasPosition) {
        return SECommandModifyTypePosition;
    }
    
    return SECommandModifyTypeNotDefined;
}

- (void)execute
{
    switch (_type) {
        case SECommandModifyTypePosition:
        {
            CGPoint position = [[_newParams objectForKey:kSEShapeParamPosition] CGPointValue];
            [_workArea updateShape:_shape withPosition:position];
        }
            break;
        case SECommandModifyTypeSize:
        {
            CGSize size = [[_newParams objectForKey:kSEShapeParamSize] CGSizeValue];
            [_workArea updateShape:_shape withSize:size];
        }
            break;
        case SECommandModifyTypeSizeAndPosition:
        {
            CGPoint position = [[_newParams objectForKey:kSEShapeParamPosition] CGPointValue];
            CGSize size = [[_newParams objectForKey:kSEShapeParamSize] CGSizeValue];
            [_workArea updateShape:_shape withSize:size andPosition:position];
        }
            break;
        default:
            break;
    }
}

- (void)rollback
{
    [_workArea updateShape:_shape withParams:_oldParams];
}

@end
