//
//  SECommand.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEWorkArea.h"

@interface SECommand : NSObject {
    SEWorkArea *_workArea;
}

@property (nonatomic, strong) SEShape *shape;

- (void)execute;
- (void)rollback;

@end
