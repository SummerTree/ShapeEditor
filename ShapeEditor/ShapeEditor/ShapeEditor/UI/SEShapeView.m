//
//  SEShapeView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEShapeView.h"
#import "UIColor+ShapeColor.h"
#import "UIView+Extended.h"

@interface SEShapeView()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation SEShapeView

- (instancetype)initWithShape:(SEShape *)shape
{
    if (self = [super initWithFrame:shape.frame]) {
        self.shape = shape;
        
        self.layer.zPosition = shape.index;
        self.opaque = NO;
        
        [self initGestures];
    }
    
    return self;
}

- (void)initGestures
{
    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self addGestureRecognizer:self.tapGesture];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    self.panGesture.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:self.panGesture];
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}

#pragma mark - misc

- (void)updateViewWithShape:(SEShape *)shape
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = shape.frame;
        
        if ([self.delegateForSel respondsToSelector:@selector(onUpdateViewWithShape:)]) {
            [self.delegateForSel onUpdateViewWithShape:shape];
        }
    } completion:^(BOOL finished) {
        [self setNeedsDisplay];
    }];
}

- (void)saveShapeNewFrame
{
    if ([self.delegate respondsToSelector:@selector(didShapeMoved:newFrame:)]) {
        [self.delegate didShapeMoved:self.shape newFrame:self.frame];
    }
}

#pragma mark - process gestures

- (CGRect)shapeRectWithTranslation:(CGPoint)tPoint
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = self.shape.frame.origin.x + tPoint.x;
    newFrame.origin.y = self.shape.frame.origin.y + tPoint.y;
    
    return newFrame;
}

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(onShapeTapped:)]) {
        [self.delegate onShapeTapped:self.shape];
    }
    
    NSLog(@"tapped %lu", (unsigned long)self.shape.index);
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint tPoint = [gestureRecognizer translationInView:self];
    NSLog(@"%@", NSStringFromCGPoint(tPoint));
    self.frame = [self shapeRectWithTranslation:tPoint];
    
    if ([self.delegate respondsToSelector:@selector(onShapeMoving:newFrame:)]) {
        [self.delegate onShapeMoving:self.shape newFrame:self.frame];
    }
    
    if ([self.delegateForSel respondsToSelector:@selector(onShapeMoving:newFrame:)]) {
        [self.delegateForSel onShapeMoving:self.shape newFrame:self.frame];
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            [self saveShapeNewFrame];
            
            NSLog(@"move pan ended");
            break;
        default:
            break;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSEnumerator *reverseE = [self.subviews reverseObjectEnumerator];
    UIView *iSubView;
    
    while ((iSubView = [reverseE nextObject])) {
        UIView *viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
        if(viewWasHit) {
            return viewWasHit;
        }
    }
    
    if ([self pointInsideFigure:point]) {
        return self;
    }
    
    return nil;
}

#pragma mark - SEShapeSelectionViewDelegate

- (void)didSelectionResized:(CGRect)newFrame
{
    [self saveShapeNewFrame];
}

- (void)onSelectionResizing:(CGRect)newFrame
{
    self.frame = newFrame;
    [self setNeedsDisplay];
}


#pragma mark - draw

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
}
*/

#pragma mark - abstract methods

- (BOOL)pointInsideFigure:(CGPoint)point
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return false;
}

@end
