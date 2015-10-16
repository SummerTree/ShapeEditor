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
#import "SEShapeView.h"

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
    SEShape *shape = [[SEShape alloc] initWithType:shapeType];
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
    SECommandRemove *command = [[SECommandRemove alloc] initWithWorkArea:self.workArea andShape:selectedShape];
    [self.commandInvoker addCommandAndExecute:command];
}

- (void)modifyShape:(SEShape *)shape toShape:(SEShape *)shape
{
    
}

#pragma mark - SEWorkAreaDelegate

- (void)updateAllShapeViews
{
    
}

- (void)showShapeViewWithIndex:(NSUInteger)idx
{
    __block UIView *shapeView = nil;
    NSArray *mViews = [self.workAreaView subviews];
    
    [mViews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SEShapeView *view = (SEShapeView *)obj;
        if (view.layer.zPosition == idx) {
            shapeView = view;
            *stop = YES;
        }
    }];
    
    if (shapeView) {
        //update shape view and redraw
    } else {
        //add shape view
    }
}

- (void)hideShapeViewWithIndex:(NSUInteger)idx
{
    
}

@end
