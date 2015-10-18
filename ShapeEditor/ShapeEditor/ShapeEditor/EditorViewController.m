//
//  ViewController.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "EditorViewController.h"
#import "SECommandInvoker.h"
#import "SEWorkArea.h"
#import "SECommandAdd.h"
#import "SECommandRemove.h"
#import "SECommandModify.h"
#import "SETriangleShapeView.h"
#import "SECircleShapeView.h"
#import "SERectangleShapeView.h"

@interface EditorViewController ()

@property (nonatomic, strong) SECommandInvoker *commandInvoker;
@property (nonatomic, strong) SEWorkArea *workArea;
@property (weak, nonatomic) IBOutlet UIView *workAreaView;

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.commandInvoker = [SECommandInvoker sharedInstance];
    self.workArea = [SEWorkArea sharedInstance];
    self.workArea.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)commandAddForShapeWithType:(SEShapeType)shapeType
{
    CGPoint workAreaViewCenter = CGPointMake(self.workAreaView.center.x - kShapeSizeWidth / 2.0,
                                             self.workAreaView.center.y - kShapeSizeHeight / 2.0);
    SEShape *shape = [[SEShape alloc] initWithType:shapeType position:workAreaViewCenter];
    SECommandAdd *command = [[SECommandAdd alloc] initWithWorkArea:self.workArea andShape:shape];
    [self.commandInvoker addCommandAndExecute:command];
}

- (IBAction)triangleShapeBtnTap:(UIButton *)sender {
    [self commandAddForShapeWithType:SEShapeTypeTriangle];
}

- (IBAction)rectangleShapeBtnTap:(UIButton *)sender {
    [self commandAddForShapeWithType:SEShapeTypeRectangle];
}

- (IBAction)circleShapeBtnTap:(UIButton *)sender {
    [self commandAddForShapeWithType:SEShapeTypeCircle];
}

- (IBAction)undoShapeBtnTap:(UIButton *)sender {
    [self.commandInvoker undoCommand];
}

- (IBAction)redoShapeBtnTap:(UIButton *)sender {
    [self.commandInvoker redoCommand];
}

- (IBAction)trashShapeBtnTap:(UIButton *)sender {
    SEShape *selectedShape = [self.workArea selectedShape];
    
    if (selectedShape) {
        SECommandRemove *command = [[SECommandRemove alloc] initWithWorkArea:self.workArea andShape:selectedShape];
        [self.commandInvoker addCommandAndExecute:command];
    }
}

#pragma mark - workarea control

- (SEShapeView *)findShapeViewWithIndex:(NSUInteger)index
{
    __block SEShapeView *shapeView = nil;
    NSArray *mViews = [self.workAreaView subviews];
    
    [mViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SEShapeView *view = (SEShapeView *)obj;
        if (view.shape.index == index) {
            shapeView = view;
            *stop = YES;
        }
    }];
    
    return shapeView;
}

- (SEShapeView *)shapeViewForShape:(SEShape *)shape
{
    switch (shape.type) {
        case SEShapeTypeTriangle:
            return [[SETriangleShapeView alloc] initWithShape:shape];
            break;
        case SEShapeTypeCircle:
            return [[SECircleShapeView alloc] initWithShape:shape];
            break;
        case SEShapeTypeRectangle:
            return [[SERectangleShapeView alloc] initWithShape:shape];
            break;
            
        default:
            break;
    }
    
    return nil;
}


#pragma mark - SEWorkAreaDelegate

- (void)updateAllShapeViews
{
    [self.workAreaView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [(UIView *)obj setNeedsDisplay];
    }];
}

- (void)showShapeViewWithIndex:(NSUInteger)idx
{
    SEShape *shape = [self.workArea shapeWithIndex:idx];
    SEShapeView *shapeView = [self findShapeViewWithIndex:shape.index];
    
    if (shapeView) {
        //update shape view and redraw
        [shapeView updateViewWithShape:shape];
    } else {
        //add shape view
        SEShapeView *newShapeView = [self shapeViewForShape:shape];
        newShapeView.delegate = self;
        newShapeView.alpha = 0;
        [self.workAreaView addSubview:newShapeView];
        
        [UIView animateWithDuration:0.3 animations:^{
            newShapeView.alpha = 1;
        }];
    }
}

- (void)hideShapeViewWithIndex:(NSUInteger)idx
{
    SEShapeView *shapeView = [self findShapeViewWithIndex:idx];
    
    [UIView animateWithDuration:0.3 animations:^{
        shapeView.alpha = 0;
    } completion:^(BOOL finished) {
        [shapeView removeFromSuperview];
    }];
    
    //find previuos command shape and select it
    SECommand *command = [self.commandInvoker previousCommand];
    [self.workArea updateShape:command.shape withState:YES];
}

#pragma mark - SEShapeViewDelegate

- (void)shapeTapped:(SEShape *)shape selected:(BOOL)selected
{
    [self.workArea updateShape:shape withState:selected];
}

- (void)shapeMoved:(SEShape *)shape position:(CGPoint)position
{
    NSDictionary *params = [NSDictionary dictionaryWithObject:[NSValue valueWithCGPoint:position]
                                                       forKey:kSEShapeParamPosition];
    
    SECommandModify *command = [[SECommandModify alloc] initWithWorkArea:self.workArea andShape:shape andNewParams:params];
    [self.commandInvoker addCommandAndExecute:command];
}

- (void)shapeMoved:(SEShape *)shape withSize:(CGSize)size andPosition:(CGPoint)position
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [NSValue valueWithCGPoint:position], kSEShapeParamPosition,
                            [NSValue valueWithCGSize:size], kSEShapeParamSize,
                            nil];
    
    SECommandModify *command = [[SECommandModify alloc] initWithWorkArea:self.workArea andShape:shape andNewParams:params];
    [self.commandInvoker addCommandAndExecute:command];
}

@end
