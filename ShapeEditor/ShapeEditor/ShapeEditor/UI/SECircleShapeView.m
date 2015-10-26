//
//  SECircleShapeView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 17.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SECircleShapeView.h"

@implementation SECircleShapeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect shapeRect = CGRectInset(rect, kSEShapeViewRectInsetDx, kSEShapeViewRectInsetDy);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    UIColor *fillColor = (self.selected)? [UIColor shapeSelectedFillColor]: [UIColor shapeFillColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor.CGColor));
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor shapeStrokeColor].CGColor));
    
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, shapeRect);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);    
    
    [super drawRect:rect];
}

- (BOOL)pointInsideFigure:(CGPoint)point
{
    CGRect rect = CGRectMake(0, 0, self.shape.frame.size.width, self.shape.frame.size.height);
    CGRect figureRect = CGRectInset(rect, kSEShapeViewRectInsetDx, kSEShapeViewRectInsetDy);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:figureRect];
    
    return [path containsPoint:point];
}


@end
