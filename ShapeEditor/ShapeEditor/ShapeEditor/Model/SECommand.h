//
//  SECommand.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SEWorkArea.h"

@protocol SECommandProtocol <NSObject>

- (void)execute;
- (void)rollback;

@end

@interface SECommand : NSObject <SECommandProtocol>
{
    SEWorkArea *_workArea;
}

@property (nonatomic, strong) SEShape *shape;

@end
