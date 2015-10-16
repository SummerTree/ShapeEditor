//
//  SECommandAdd.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommand.h"
#import "SEShape.h"

@interface SECommandAdd : SECommand

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape;


@end
