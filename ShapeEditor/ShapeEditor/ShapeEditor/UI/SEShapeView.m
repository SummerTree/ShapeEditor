//
//  SEShapeView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 16.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEShapeView.h"

@interface SEShapeView()

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end

@implementation SEShapeView

- (instancetype)initWithShape:(SEShape *)shape
{
    CGRect frame = CGRectMake(shape.position.x, shape.position.y, shape.size.width, shape.size.height);
    
    if (self = [super initWithFrame:frame]) {
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

- (void)updateViewWithShape:(SEShape *)shape
{
    self.frame = CGRectMake(shape.position.x, shape.position.y, shape.size.width, shape.size.height);
    [self setNeedsDisplay];
}

#pragma mark - misc

- (void)saveShapeNewPosition
{
    if ([self.delegate respondsToSelector:@selector(shapeMoved:position:)]) {
        [self.delegate shapeMoved:self.shape position:self.frame.origin];
    }
    
    [self setNeedsDisplay];
}

- (void)saveShapeNewState:(BOOL)state
{
    if ([self.delegate respondsToSelector:@selector(shapeTapped:selected:)]) {
        [self.delegate shapeTapped:self.shape selected:state];
    }
    
    [self setNeedsDisplay];
}


#pragma mark - process gestures

- (CGRect)shapeRectWithTranslation:(CGPoint)tPoint
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = self.shape.position.x + tPoint.x;
    newFrame.origin.y = self.shape.position.y + tPoint.y;
    
    return newFrame;
}

- (void)tapGesture:(UITapGestureRecognizer *)gestureRecognizer
{
    [self saveShapeNewState:!self.shape.selected];
    
    NSLog(@"tapped %lu", (unsigned long)self.shape.index);
}

- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint tPoint = [gestureRecognizer translationInView:self];
    self.frame = [self shapeRectWithTranslation:tPoint];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            [self saveShapeNewPosition];
            
            NSLog(@"pan ended");
            break;
        default:
            break;
    }
}

#pragma mark - draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.shape.selected) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect selRect = CGRectInset(rect, kShapeViewRectInsetDx / 2.0, kShapeViewRectInsetDy / 2.0);
        CGContextSetLineWidth(context, 1.0);
        CGFloat dashes[] = {1,1};
        CGContextSetLineDash(context, 0, dashes, 2);
        
        CGContextBeginPath(context);
        CGContextAddRect(context, selRect);
        CGContextClosePath(context);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

@end
