//
//  SEShapeSelectionView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 25.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEShapeSelectionView.h"
#import "SEShapeView.h"

typedef enum : NSUInteger {
    SEShapeViewResizeAreaTagLeftTop = 100,
    SEShapeViewResizeAreaTagRightTop = 101,
    SEShapeViewResizeAreaTagRightBottom = 102,
    SEShapeViewResizeAreaTagLeftBottom = 103,
} SEShapeViewResizeAreaTag;


@implementation SEShapeSelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.hidden = YES;
        self.opaque = NO;
        [self initResizeAreas];
    }
    
    return self;
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

- (void)updateResizeAreaVisibility
{
    self.hidden = (self.shapeView == nil);
    [self setNeedsDisplay];
}

- (void)updateResizeAreasFrames:(BOOL)firstTime;
{
    CGPoint leftTopPoint, rightTopPoint, rightBottomPoint, leftBottomPoint;
    SEShape *shape = self.shapeView.shape;
    
    leftTopPoint = CGPointMake(0, 0);
    if (firstTime) {
        rightTopPoint = CGPointMake(shape.frame.size.width, 0);
        rightBottomPoint = CGPointMake(shape.frame.size.width, shape.frame.size.height);
        leftBottomPoint = CGPointMake(0, shape.frame.size.height);
    } else {
        rightTopPoint = CGPointMake(self.frame.size.width, 0);
        rightBottomPoint = CGPointMake(self.frame.size.width, self.frame.size.height);
        leftBottomPoint = CGPointMake(0, self.frame.size.height);
    }
    
    [self resizeAreaFrameFromPoint:leftTopPoint corner:SEShapeViewResizeAreaTagLeftTop];
    [self resizeAreaFrameFromPoint:rightTopPoint corner:SEShapeViewResizeAreaTagRightTop];
    [self resizeAreaFrameFromPoint:rightBottomPoint corner:SEShapeViewResizeAreaTagRightBottom];
    [self resizeAreaFrameFromPoint:leftBottomPoint corner:SEShapeViewResizeAreaTagLeftBottom];
}

#pragma mark - process gestures

- (CGRect)shapeRectWithTranslation:(CGPoint)tPoint affectCorner:(SEShapeViewResizeAreaTag)corner
{
    SEShape *shape = self.shapeView.shape;
    CGRect newFrame = self.frame;
    
    int signX = (corner == SEShapeViewResizeAreaTagLeftTop || corner == SEShapeViewResizeAreaTagLeftBottom)? 1: -1;
    int signY = (corner == SEShapeViewResizeAreaTagLeftTop || corner == SEShapeViewResizeAreaTagRightTop)? 1: -1;
    
    float minWidth = (kSEShapeViewRectMinWidth + kSEShapeViewRectInsetDx * 2);
    float minHeight = (kSEShapeViewRectMinHeight + kSEShapeViewRectInsetDy * 2);
    
    float maxX = (shape.frame.origin.x + shape.frame.size.width - minWidth);
    float maxY = (shape.frame.origin.y + shape.frame.size.height - minHeight);
    
    float newX = shape.frame.origin.x + tPoint.x;
    float newY = shape.frame.origin.y + tPoint.y;
    float newWidth = shape.frame.size.width - tPoint.x * signX;
    float newHeight = shape.frame.size.height - tPoint.y * signY;
    
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

- (void)panResizeGesure:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint tPoint = [gestureRecognizer translationInView:self];
    self.frame = [self shapeRectWithTranslation:tPoint affectCorner:gestureRecognizer.view.tag];
    
    [self updateResizeAreasFrames: NO];
    
    if ([self.delegate respondsToSelector:@selector(onSelectionResizing:)]) {
        [self.delegate onSelectionResizing:self.frame];
    }
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateEnded:
            if ([self.delegate respondsToSelector:@selector(didSelectionResized:)]) {
                [self.delegate didSelectionResized:self.frame];
            }
            
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
    
    return nil;
}

#pragma mark - selection

- (void)selectShapeView:(SEShapeView *)shapeView
{
    if (self.shapeView) [self hideSelection];
    
    shapeView.selected = YES;
    
    self.shapeView = shapeView;
    self.delegate = (id)shapeView;
    self.frame = shapeView.frame;
    
    self.shapeView.delegateForSel = self;
    
    [self updateResizeAreasFrames: YES];
    [self updateResizeAreaVisibility];
}

- (void)hideSelection
{
    if (self.shapeView) {
        self.shapeView.selected = NO;
        self.shapeView.delegateForSel = nil;
    }
    
    self.shapeView = nil;
    self.delegate = nil;

    [self updateResizeAreaVisibility];
}

#pragma mark - SEShapeViewDelegate

- (void)onShapeMoving:(SEShape *)shape newFrame:(CGRect)newFrame
{
    self.frame = newFrame;
    [self setNeedsDisplay];
}

- (void)onUpdateViewWithShape:(SEShape *)shape
{
    self.frame = shape.frame;
    [self updateResizeAreasFrames:YES];
    [self setNeedsDisplay];
}

#pragma mark - draw

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
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

@end
