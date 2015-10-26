//
//  SECommandModify.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommand.h"

@interface SECommandModify : SECommand {
#ifdef UNIT_TESTS
    @public
#endif
    SEShapeParams _newParams;
    SEShapeParams _oldParams;
}

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
                    andNewParams:(SEShapeParams)newParams;

@end
