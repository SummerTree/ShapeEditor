//
//  SECommandModify.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommand.h"

typedef enum : NSUInteger {
    SECommandModifyTypeNotDefined,
    SECommandModifyTypePosition,
    SECommandModifyTypeSize,
    SECommandModifyTypeSizeAndPosition,
} SECommandModifyType;

@interface SECommandModify : SECommand {
#ifdef UNIT_TESTS
    @public
#endif
    SECommandModifyType _type;
    NSDictionary *_newParams;
    NSDictionary *_oldParams;
}

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
                    andNewParams:(NSDictionary *)newParams;

@end
