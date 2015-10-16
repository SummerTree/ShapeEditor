//
//  SECommandModify.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommand.h"

@interface SECommandModify : SECommand {
    SEShape *_newShape;
}

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape
                    andNewShape:(SEShape *)newShape;

@end
