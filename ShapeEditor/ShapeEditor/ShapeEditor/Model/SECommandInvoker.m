//
//  SECommandInvoker.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECommandInvoker.h"

@interface SECommandInvoker () {
    NSUInteger _currentCommandIndex;
    HStack *_commandStack;
}

@end

@implementation SECommandInvoker

+ (SECommandInvoker *)sharedInstance
{
    static SECommandInvoker *sharedInstance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        sharedInstance = [[SECommandInvoker alloc] init];
    });
    return sharedInstance;
}

- (SECommandInvoker *)init
{
    if (self == [super init]) {
        _commandStack = [[HStack alloc] init];
        _currentCommandIndex = 0;
    }
    
    return self;
}

#pragma mark - misc

- (void)clearCommandsBeforeInsert
{
    if ([self hasRedoCommands])
        [_commandStack clearAfterIndex:_currentCommandIndex - 1];
}

#pragma mark - main

- (BOOL)hasRedoCommands
{
    return [_commandStack itemsCount] > _currentCommandIndex;
}

- (BOOL)hasUndoCommands
{
    return _currentCommandIndex > 0;
}

- (void)addCommandAndExecute:(SECommand *)command
{
    [self clearCommandsBeforeInsert];
    [command execute];
    [_commandStack push:command];
    _currentCommandIndex++;
}

- (void)redoCommand
{
    if ([self hasRedoCommands]) {
        _currentCommandIndex++;
        [[self currentCommand] execute];
    }
}

- (void)undoCommand
{
    if ([self hasUndoCommands]) {        
        [[self currentCommand] rollback];
        _currentCommandIndex--;
    }
}

- (id)currentCommand
{
    return [_commandStack itemAtIndex:_currentCommandIndex - 1];
}


- (id)previousCommand
{
    return (_currentCommandIndex > 1)? [_commandStack itemAtIndex:_currentCommandIndex - 2]: nil;
}

@end
