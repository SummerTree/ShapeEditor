//
//  SECommandRemove.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommand.h"

@interface SECommandRemove : SECommand

- (SECommand *)initWithWorkArea:(SEWorkArea *)workArea
                       andShape:(SEShape *)shape;

@end
