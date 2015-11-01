//
//  ShapeEditorTests.m
//  ShapeEditorTests
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <XCTest/XCTestCase+AsynchronousTesting.h>
#import <OCMock/OCMock.h>

#import "SECommandInvoker.h"
#import "SECommandAdd.h"
#import "SECommandRemove.h"
#import "SECommandModify.h"
#import "SEShapesStorage.h"

@interface ShapeEditorTests : XCTestCase
@property (nonatomic, strong) OCMockObject *shapeStorageMock;
@end

@implementation ShapeEditorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    self.shapeStorageMock = [OCMockObject mockForClass:[SEShapesStorage class]];
    [[self.shapeStorageMock stub] storeShapes:[OCMArg any]];
    [[self.shapeStorageMock stub] reStoreShapes:[OCMArg any]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - shape

- (void)testShapeCreate
{
    CGSize size = CGSizeMake(24, 56);
    CGPoint position = CGPointMake(3, 5);
    CGRect shapeFrame = CGRectMake(position.x, position.y, size.width, size.height);

    SEShape *shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
    XCTAssertNotNil(shape, @"nil shape instance");
    XCTAssertEqual(shape.index, 0, @"shape index must be equal zero after init");
    
    shape = [[SEShape alloc] initWithType:SEShapeTypeTriangle position:position];
    XCTAssertNotNil(shape, @"nil shape instance");
    XCTAssertTrue(shape.type == SEShapeTypeTriangle, @"shape type not right");
    XCTAssertTrue(CGPointEqualToPoint(shape.frame.origin, position), @"shape position is not equal");
    
    shape = [[SEShape alloc] initWithType:SEShapeTypeRectangle frame:shapeFrame];
    XCTAssertNotNil(shape, @"nil shape instance");
    XCTAssertTrue(shape.type == SEShapeTypeRectangle, @"shape type not right");
    XCTAssertTrue(CGRectEqualToRect(shape.frame, shapeFrame), @"shape frame is not equal");
}

#pragma mark - commands

- (void)testCommandAddRemoveCreate
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SEShape *shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
    
    SECommandAdd *commandAdd = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape];
    XCTAssertNotNil(commandAdd, @"nil command instance");
    XCTAssertEqualObjects(shape, commandAdd.shape, @"shape propery invalid");
    
    SECommandRemove *commandRemove = [[SECommandRemove alloc] initWithWorkArea:workArea andShape:shape];
    XCTAssertNotNil(commandRemove, @"nil command instance");
    XCTAssertEqualObjects(shape, commandRemove.shape, @"shape propery invalid");
}

- (void)testCommandModifyCreate
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SEShape *shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
    
    CGPoint position = CGPointMake(25, 47);
    CGSize size = CGSizeMake(250, 470);
    CGRect shapeFrame = CGRectMake(position.x, position.y, size.width, size.height);
    
    SEShapeParams newParams = {.frame =  shapeFrame};
    SEShapeParams oldParams = [shape params];
    
    SECommandModify *commandModify = [[SECommandModify alloc] initWithWorkArea:workArea andShape:shape andNewParams:newParams];
    XCTAssertNotNil(commandModify, @"nil command instance");
    XCTAssertEqualObjects(shape, commandModify.shape, @"shape propery invalid");
    
    XCTAssertTrue([SEShape params:newParams equalToParams:commandModify->_newParams], @"new params incorrect");
    XCTAssertTrue([SEShape params:oldParams equalToParams:commandModify->_oldParams], @"old params incorrect");
}


#pragma mark - command invoker

- (void)testCommandInvoker
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SECommandInvoker *commandInvoker = [SECommandInvoker sharedInstance];
    
    SEShape *shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
    SECommandAdd *command1 = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape];
    [commandInvoker addCommandAndExecute:command1];
    
    shape = [[SEShape alloc] initWithType:SEShapeTypeRectangle];
    SECommandAdd *command2 = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape];
    [commandInvoker addCommandAndExecute:command2];
    
    XCTAssertEqualObjects(command2, [commandInvoker currentCommand], @"current command failed");
    XCTAssertEqualObjects(command1, [commandInvoker previousCommand], @"previous command failed");
    
    XCTAssertFalse([commandInvoker hasRedoCommands], @"has redo check failed");
    
    [commandInvoker undoCommand];
    XCTAssertEqualObjects(command1, [commandInvoker currentCommand], @"undo failed");

    [commandInvoker undoCommand];
    XCTAssertNil([commandInvoker currentCommand], @"current command failed");
    XCTAssertFalse([commandInvoker hasUndoCommands], @"has undo check failed");
    
    [commandInvoker redoCommand];
    [commandInvoker redoCommand];
    XCTAssertEqualObjects(command2, [commandInvoker currentCommand], @"redo failed");
}

#pragma mark - workarea

- (void)testWorkAreaShapeWithIndex
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SECommandInvoker *commandInvoker = [SECommandInvoker sharedInstance];
    
    SEShape *shape, *shape4;
    SECommandAdd *command;
    
    for (int i = 0; i < 5; i++) {
        shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
        command = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape];
        [commandInvoker addCommandAndExecute:command];
        
        if (i == 3) shape4 = shape;
    }
    
    SEShape *shape4Got = [workArea shapeWithIndex:shape4.index];
    
    XCTAssertEqualObjects(shape4, shape4Got, @"shapeWithIndex faild");
}

- (void)testWorkAreaRemoveAndReturnShape
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SECommandInvoker *commandInvoker = [SECommandInvoker sharedInstance];
    
    SEShape *shape, *shape4;
    SECommandAdd *command;
    
    for (int i = 0; i < 5; i++) {
        shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
        command = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape];
        [commandInvoker addCommandAndExecute:command];
        
        if (i == 3) shape4 = shape;
    }
    
    NSUInteger mIdxShape4 = [workArea.shapes indexOfObject:shape4];
    
    [workArea removeShape:shape4];
    SEShape *shape4Got = [workArea shapeWithIndex:shape4.index];
    XCTAssertNil(shape4Got, @"shape remove faild");
    
    [workArea returnShape:shape4];
    shape4Got = [workArea shapeWithIndex:shape4.index];
    XCTAssertEqualObjects(shape4, shape4Got, @"shape return faild");
    
    NSUInteger mIdxShape4Got = [workArea.shapes indexOfObject:shape4Got];
    XCTAssertEqual(mIdxShape4, mIdxShape4Got, @"returned shape array position incorrect");
}

- (void)testWorkAreaUpdateShape
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SEShape *shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
    CGPoint position = CGPointMake(120, 130);
    CGSize size = CGSizeMake(50, 150);
    CGRect shapeFrame = CGRectMake(position.x, position.y, size.width, size.height);
    
    SEShapeParams params = {.frame = shapeFrame};
    [workArea updateShape:shape withParams:params];
    XCTAssertTrue([SEShape params:shape.params equalToParams:params], @"update shape with params incorrect");
}

#pragma mark - workarea responds to commands

- (void)testWorkAreaShapesCount
{
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SECommandInvoker *commandInvoker = [SECommandInvoker sharedInstance];
    NSUInteger shapesCount = [workArea.shapes count];

    SEShape *shape;
    SECommandAdd *command;
    
    for (int i = 0; i < 5; i++) {
        shape = [[SEShape alloc] initWithType:SEShapeTypeCircle];
        command = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape];
        [commandInvoker addCommandAndExecute:command];
    }
    
    XCTAssertTrue([workArea.shapes count] == shapesCount + 5, @"add shape faild");

    shape = [workArea.shapes lastObject];
    SECommandRemove *commandRemove = [[SECommandRemove alloc] initWithWorkArea:workArea andShape:shape];
    [commandInvoker addCommandAndExecute:commandRemove];
    
    XCTAssertTrue([workArea.shapes count] == shapesCount + 4, @"remove shape faild");
    
    shape = [workArea.shapes firstObject];
    commandRemove = [[SECommandRemove alloc] initWithWorkArea:workArea andShape:shape];
    [commandInvoker addCommandAndExecute:commandRemove];
    
    XCTAssertTrue([workArea.shapes count] == shapesCount + 3, @"remove shape faild");
}

#pragma mark - shape storage

- (void)testShapeStoreRestore
{
    [self.shapeStorageMock stopMocking];
    XCTestExpectation *expectation = [self expectationWithDescription:@"async storage"];
    
    SEWorkArea *workArea = [SEWorkArea sharedInstance];
    SECommandInvoker *commandInvoker = [SECommandInvoker sharedInstance];
    
    SEShape *shape1 = [[SEShape alloc] initWithType:SEShapeTypeCircle];
    SECommandAdd *command = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape1];
    [commandInvoker addCommandAndExecute:command];
    
    //update shape with current params state
    shape1 = [shape1 copy];

    SEShape *shape2 = [[SEShape alloc] initWithType:SEShapeTypeRectangle];
    command = [[SECommandAdd alloc] initWithWorkArea:workArea andShape:shape2];
    [commandInvoker addCommandAndExecute:command];
    
    __block SEShape *shapeRestored;
    [SEShapesStorage reStoreShapes:^(NSArray *shapes) {
        shapeRestored = [shapes lastObject];

        XCTAssertEqual([shapeRestored isEqual:shape1], false, @"restored shapes is not correct");
        XCTAssertEqual([shapeRestored isEqual:shape2], true, @"restored shapes is not correct");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}

/*
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}
*/

@end
