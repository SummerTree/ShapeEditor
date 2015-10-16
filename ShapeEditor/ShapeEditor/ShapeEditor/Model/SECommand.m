//
//  SECommand.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommand.h"
#import "SEWorkArea.h"

@implementation SECommand

- (void)execute
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"]; 
}

- (void)rollback
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];     
}

@end
