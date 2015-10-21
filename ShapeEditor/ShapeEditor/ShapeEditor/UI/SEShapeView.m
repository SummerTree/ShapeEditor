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

typedef enum : NSUInteger {
    SEShapeViewResizeAreaTagLeftTop = 100,
    SEShapeViewResizeAreaTagRightTop = 101,
    SEShapeViewResizeAreaTagRightBottom = 102,
    SEShapeViewResizeAreaTagLeftBottom = 103,
} SEShapeViewResizeAreaTag;

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
        [self initResizeAreas];
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

#pragma mark - resize area

- (void)initResizeAreas
{
    UIView *area1 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *area2 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *area3 = [[UIView alloc] initWithFrame:CGRectZero];
    UIView *area4 = [[UIView alloc] initWithFrame:CGRectZero];
    
    area1.tag = SEShapeViewResizeAreaTagLeftTop;
    area2.tag = SEShapeViewResizeAreaTagRightTop;
    area3.tag = SEShapeViewResizeAreaTagRightBottom;
    area4.tag = SEShapeViewResizeAreaTagLeftBottom;
    
    area1.layer.borderWidth = 1;
    area1.layer.borderColor = [[UIColor shapeResizeAreaStrokeColor] CGColor];
    area2.layer.borderWidth = 1;
    area2.layer.borderColor = [[UIColor shapeResizeAreaStrokeColor] CGColor];
    area3.layer.borderWidth = 1;
    area3.layer.borderColor = [[UIColor shapeResizeAreaStrokeColor] CGColor];
    area4.layer.borderWidth = 1;
    area4.layer.borderColor = [[UIColor shapeResizeAreaStrokeColor] CGColor];
    
    [self addSubview:area1];
    [self addSubview:area2];
    [self addSubview:area3];
    [self addSubview:area4];
    
    UIPanGestureRecognizer *panResize1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResizeGesure:)];
    panResize1.maximumNumberOfTouches = 1;
    UIPanGestureRecognizer *panResize2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResizeGesure:)];
    panResize1.maximumNumberOfTouches = 1;
    UIPanGestureRecognizer *panResize3 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResizeGesure:)];
    panResize1.maximumNumberOfTouches = 1;
    UIPanGestureRecognizer *panResize4 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panResizeGesure:)];
    panResize1.maximumNumberOfTouches = 1;
    
    [area1 addGestureRecognizer:panResize1];
    [area2 addGestureRecognizer:panResize2];
    [area3 addGestureRecognizer:panResize3];
    [area4 addGestureRecognizer:panResize4];
    
    [self updateResizeAreasFrames: YES];
    [self updateResizeAreaVisibility];
}

- (void)resizeAreaFrameFromPoint:(CGPoint)centerPoint corner:(SEShapeViewResizeAreaTag)tag
{
    UIView *view = [self viewWithTag:tag];
    
    int signX = (tag == SEShapeViewResizeAreaTagLeftTop || tag == SEShapeViewResizeAreaTagLeftBottom)? 1: -1;
    int signY = (tag == SEShapeViewResizeAreaTagLeftTop || tag == SEShapeViewResizeAreaTagRightTop)? 1: -1;

    float halfWidth = (kSEShapeViewResizeAreaWidth - kSEShapeViewRectInsetDx * signX) / 2.0;
    float halfHeight = (kSEShapeViewResizeAreaHeight - kSEShapeViewRectInsetDy * signY) / 2.0;

    view.frame = CGRectMake(centerPoint.x - halfWidth, centerPoint.y - halfHeight, kSEShapeViewResizeAreaWidth, kSEShapeViewResizeAreaHeight);
}

- (void)updateViewWithShape:(SEShape *)shape
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(shape.position.x, shape.position.y, shape.size.width, shape.size.height);
    }];
}

- (void)updateResizeAreaVisibility
{
    [self viewWithTag:SEShapeViewResizeAreaTagLeftTop].hidden = !self.shape.selected;
    [self viewWithTag:SEShapeViewResizeAreaTagRightTop].hidden = !self.shape.selected;
    [self viewWithTag:SEShapeViewResizeAreaTagRightBottom].hidden = !self.shape.selected;
    [self viewWithTag:SEShapeViewResizeAreaTagLeftBottom].hidden = !self.shape.selected;
}

- (void)updateResizeAreasFrames:(BOOL)firstTime;
{
    CGPoint leftTopPoint, rightTopPoint, rightBottomPoint, leftBottomPoint;
    
    if (firstTime) {
        leftTopPoint = CGPointMake(0, 0);
        rightTopPoint = CGPointMake(self.shape.size.width, 0);
        rightBottomPoint = CGPointMake(self.shape.size.width, self.shape.size.height);
        leftBottomPoint = CGPointMake(0, self.shape.size.height);
    } else {
        leftTopPoint = CGPointMake(0, 0);
        rightTopPoint = CGPointMake(self.frame.size.width, 0);
        rightBottomPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
        leftBottomPoint = CGPointMake(0, self.frame.size.height);
    }
    
    [self resizeAreaFrameFromPoint:leftTopPoint corner:SEShapeViewResizeAreaTagLeftTop];
    [self resizeAreaFrameFromPoint:rightTopPoint corner:SEShapeViewResizeAreaTagRightTop];
    [self resizeAreaFrameFromPoint:rightBottomPoint corner:SEShapeViewResizeAreaTagRightBottom];
    [self resizeAreaFrameFromPoint:leftBottomPoint corner:SEShapeViewResizeAreaTagLeftBottom];
}

#pragma mark - refresh

- (void)refreshView
{
    [UIView animateWithDuration:0.3 animations:^{
        [self updateResizeAreasFrames: NO];
        [self updateResizeAreaVisibility];
    }];
     
    [self setNeedsDisplay];
}

#pragma mark - misc

- (void)saveShapeNewPosition
{
    if ([self.delegate respondsToSelector:@selector(shapeMoved:position:)]) {
        [self.delegate shapeMoved:self.shape position:self.frame.origin];
    }
}

- (void)saveShapeNewPositionAndSize
{
    if ([self.delegate respondsToSelector:@selector(shapeMoved:withSize:andPosition:)]) {
        [self.delegate shapeMoved:self.shape withSize:self.frame.size andPosition:self.frame.origin];
    }
}

- (void)saveShapeNewState:(BOOL)state
{
    if ([self.delegate respondsToSelector:@selector(shapeTapped:selected:)]) {
        [self.delegate shapeTapped:self.shape selected:state];
    }
}


#pragma mark - process gestures

- (CGRect)shapeRectWithTranslation:(CGPoint)tPoint
{
    CGRect newFrame = self.frame;
    newFrame.origin.x = self.shape.position.x + tPoint.x;
    newFrame.origin.y = self.shape.position.y + tPoint.y;
    
    return newFrame;
}

- (CGRect)shapeRectWithTranslation:(CGPoint)tPoint affectCorner:(SEShapeViewResizeAreaTag)corner
{
    CGRect newFrame = self.frame;
    
    int signX = (corner == SEShapeViewResizeAreaTagLeftTop || corner == SEShapeViewResizeAreaTagLeftBottom)? 1: -1;
    int signY = (corner == SEShapeViewResizeAreaTagLeftTop || corner == SEShapeViewResizeAreaTagRightTop)? 1: -1;
    
    float minWidth = (kSEShapeViewRectMinWidth + kSEShapeViewRectInsetDx * 2);
    float minHeight = (kSEShapeViewRectMinHeight + kSEShapeViewRectInsetDy * 2);
    
    float maxX = (self.shape.position.x + self.shape.size.width - minWidth);
    float maxY = (self.shape.position.y + self.shape.size.height - minHeight);
    
    float newX = self.shape.position.x + tPoint.x;
    float newY = self.shape.position.y + tPoint.y;
    float newWidth = self.shape.size.width - tPoint.x * signX;
    float newHeight = self.shape.size.height - tPoint.y * signY;
    
    newX = (newX > maxX)? maxX: newX;
    newY = (newY > maxY)? maxY: newY;
    newWidth = (newWidth < minWidth)? minWidth: newWidth;
    newHeight = (newHeight < minHeight)? minHeight: newHeight;
    
    switch (corner) {
        case SEShapeViewResizeAreaTagLeftTop:
            newFrame.origin.x = newX;
            newFrame.origin.y = newY;
            newFrame.size.width = newWidth;
            newFrame.size.height = newHeight;
            
            break;
        case SEShapeViewResizeAreaTagRightTop:
            newFrame.origin.y = newY;
            newFrame.size.width = newWidth;
            newFrame.size.height = newHeight;
            
            break;
        case SEShapeViewResizeAreaTagRightBottom:
            newFrame.size.width = newWidth;
            newFrame.size.height = newHeight;
            
            break;
        case SEShapeViewResizeAreaTagLeftBottom:
            newFrame.origin.x = newX;
            newFrame.size.width = newWidth;
            newFrame.size.height = newHeight;
            
            break;
            
        default:
            break;
    }
    
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
    
    if ([self.delegate respondsToSelector:@selector(shapeMoving:newPosition:)]) {
        [self.delegate shapeMoving:self.shape newPosition:self.origin];
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            [self saveShapeNewPosition];
            
            NSLog(@"move pan ended");
            break;
        default:
            break;
    }
}

- (void)panResizeGesure:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint tPoint = [gestureRecognizer translationInView:self];
    self.frame = [self shapeRectWithTranslation:tPoint affectCorner:gestureRecognizer.view.tag];
    
    [self updateResizeAreasFrames: NO];
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            [self saveShapeNewPositionAndSize];
            
            NSLog(@"resize pan ended");
            break;
        default:
            break;
    }
    
    [self setNeedsDisplay];
    
    NSLog(@"tag %ld", (long)gestureRecognizer.view.tag);
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

#pragma mark - draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    if (self.shape.selected) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGRect selRect = CGRectInset(rect, kSEShapeViewRectInsetDx / 2.0, kSEShapeViewRectInsetDy / 2.0);
        CGContextSetLineWidth(context, 1.0);
        CGFloat dashes[] = {1,1};
        CGContextSetLineDash(context, 0, dashes, 2);
        
        CGContextBeginPath(context);
        CGContextAddRect(context, selRect);
        CGContextClosePath(context);
        
        CGContextDrawPath(context, kCGPathStroke);
    }
}

#pragma mark - abstract methods

- (BOOL)pointInsideFigure:(CGPoint)point
{
    [NSException raise:@"Invoked abstract method" format:@"Invoked abstract method"];
    return false;
}

@end
