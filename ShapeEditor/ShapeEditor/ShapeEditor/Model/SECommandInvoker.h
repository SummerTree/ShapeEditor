//
//  SECommandInvoker.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SECommand.h"
#import "HStack.h"

@interface SECommandInvoker : NSObject 

+ (SECommandInvoker *)sharedInstance;

- (BOOL)hasRedoCommands;
- (BOOL)hasUndoCommands;

- (void)addCommandAndExecute:(SECommand *)command;
- (void)redoCommand;
- (void)undoCommand;

- (id)currentCommand;
- (id)previousCommand;

@end
