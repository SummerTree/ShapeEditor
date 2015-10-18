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
    CGRect shapeRect = CGRectInset(rect, kShapeViewRectInsetDx, kShapeViewRectInsetDy);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColor(context, CGColorGetComponents([UIColor shapeFillColor].CGColor));
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor shapeStrokeColor].CGColor));
    
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, shapeRect);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);    
    
    [super drawRect:rect];
}


@end
