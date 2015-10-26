//
//  ViewController.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "EditorViewController.h"
#import "SEWorkAreaLayerView.h"
#import "SECommandInvoker.h"
#import "SEWorkArea.h"
#import "SECommandAdd.h"
#import "SECommandRemove.h"
#import "SECommandModify.h"
#import "SETriangleShapeView.h"
#import "SECircleShapeView.h"
#import "SERectangleShapeView.h"
#import "MBProgressHUD.h"

@interface EditorViewController ()

@property (nonatomic, strong) SECommandInvoker *commandInvoker;

@property (nonatomic, strong) SEWorkArea *workArea;
@property (weak, nonatomic) IBOutlet UIView *workAreaView;
@property (weak, nonatomic) IBOutlet UIView *shapesLayerView;
@property (weak, nonatomic) IBOutlet UIView *selectionLayerView;
@property (nonatomic, weak) SEShapeSelectionView *shapeSelectionView;

@property (weak, nonatomic) IBOutlet UIButton *undoButton;
@property (weak, nonatomic) IBOutlet UIButton *redoButton;
@property (weak, nonatomic) IBOutlet UIButton *trashButton;

@end

@implementation EditorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.commandInvoker = [SECommandInvoker sharedInstance];
    self.workArea = [SEWorkArea sharedInstance];
    self.workArea.delegate = self;
        
    SEShapeSelectionView *view = [[SEShapeSelectionView alloc] initWithFrame:CGRectZero];
    [self.selectionLayerView addSubview:view];
    self.shapeSelectionView = view;
    
    self.shapesLayerView.tag = SEWorkAreaLayerViewTagShapes;
    self.selectionLayerView.tag = SEWorkAreaLayerViewTagSelection;
    
    [self initGestures];
}

- (void)viewWillAppear:(BOOL)animated
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.workArea restoreShapes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - misc

- (void)initGestures
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(workAreaTap:)];
    [self.workAreaView addGestureRecognizer:tap];
}

- (void)initButtonsState
{
    self.undoButton.enabled = [self.commandInvoker hasUndoCommands];
    self.redoButton.enabled = [self.commandInvoker hasRedoCommands];
    self.trashButton.enabled = [self.workArea selectedShape] != nil;
}

#pragma mark - Gestures

- (void)workAreaTap:(UITapGestureRecognizer *)gesture
{
    [self clearShapeSelection];
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

#pragma mark - shape selection

- (void)selectShape:(SEShape *)shape
{
    SEShapeView *shapeView = [self findShapeViewWithIndex:shape.index];
    [self.shapeSelectionView selectShapeView:shapeView];
    if (shapeView) {
        self.workArea.selectedShape = shape;
    } else {
        self.workArea.selectedShape = nil;
    }
    
    [self initButtonsState];
}

- (void)clearShapeSelection
{
    if (self.workArea.selectedShape) {
        self.workArea.selectedShape = nil;
        [self.shapeSelectionView hideSelection];
        
        [self initButtonsState];
    }
}

- (void)switchSelectionShape:(SEShape *)shape
{
    if (self.workArea.selectedShape == shape) {
        [self clearShapeSelection];
    } else {
        [self selectShape:shape];
    }
    
    [self initButtonsState];
}

#pragma mark - workarea control

- (SEShapeView *)findShapeViewWithIndex:(NSUInteger)index
{
    SEShapeView *shapeView = nil;
    
    for (SEShapeView *view in self.shapesLayerView.subviews) {
        if (view.shape.index == index) {
            shapeView = view;
            break;
        }
    }
    
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

- (void)shapesRestoreComplete
{
    [self.workArea enumerateShapesUsingBlock:^BOOL(SEShape *shape) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SEShapeView *newShapeView = [self shapeViewForShape:shape];
            newShapeView.delegate = self;
            [self.shapesLayerView addSubview:newShapeView];
        });
        
        return false;
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self initButtonsState];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    
    NSLog(@"shapes restored");
}

- (void)didShapeAdded:(SEShape *)shape
{
    //add shape view
    SEShapeView *newShapeView = [self shapeViewForShape:shape];
    newShapeView.delegate = self;
    newShapeView.alpha = 0;
    
    NSUInteger idx = [self.shapesLayerView.subviews indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return ((SEShapeView *)obj).shape.index > newShapeView.shape.index;
    }];
    
    if (idx == NSNotFound) {
        [self.shapesLayerView addSubview:newShapeView];
    } else {
        [self.shapesLayerView insertSubview:newShapeView atIndex:idx];
    }
    
    [self selectShape:shape];
    
    [UIView animateWithDuration:0.3 animations:^{
        newShapeView.alpha = 1;
    }];
    
    [self initButtonsState];
}

- (void)willShapeChange:(SEShape *)shape
{
    if (self.workArea.selectedShape != shape) {
        [self selectShape:shape];
    }
}

- (void)didShapeChanged:(SEShape *)shape
{
    SEShapeView *shapeView = [self findShapeViewWithIndex:shape.index];
    
    if (shapeView) {
        //update shape view and redraw
        [shapeView updateViewWithShape:shape];
    }
    
    [self initButtonsState];
}

- (void)didShapeRemoved:(SEShape *)shape
{
    SEShapeView *shapeView = [self findShapeViewWithIndex:shape.index];
    
    [UIView animateWithDuration:0.3 animations:^{
        shapeView.alpha = 0;
    } completion:^(BOOL finished) {
        [shapeView removeFromSuperview];
    }];
    
    //find previuos command shape and select it
    SECommand *command = [self.commandInvoker previousCommand];
    
    if (command && command.shape != shape) {
        [self selectShape:command.shape];
    } else {
        [self selectShape:[self.workArea topShape]];
    }
}

#pragma mark - SEShapeViewDelegate

- (void)onShapeTapped:(SEShape *)shape
{
    [self switchSelectionShape:shape];
}

- (void)onShapeMoving:(SEShape *)shape newFrame:(CGRect)newFrame
{
    if (self.workArea.selectedShape != shape) {
        [self selectShape:shape];
    }
}

- (void)didShapeMoved:(SEShape *)shape newFrame:(CGRect)newFrame
{
    SEShapeParams params;
    params.frame = newFrame;
    
    SECommandModify *command = [[SECommandModify alloc] initWithWorkArea:self.workArea andShape:shape andNewParams:params];
    [self.commandInvoker addCommandAndExecute:command];
}

@end
