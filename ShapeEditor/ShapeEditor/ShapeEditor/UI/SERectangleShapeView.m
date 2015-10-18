//
//  SERectangleShapeView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 17.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SERectangleShapeView.h"

@implementation SERectangleShapeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect shapeRect = CGRectInset(rect, kShapeViewRectInsetDx, kShapeViewRectInsetDy);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColor(context, CGColorGetComponents([UIColor shapeFillColor].CGColor));
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor shapeStrokeColor].CGColor));
    
    CGContextBeginPath(context);
    CGContextAddRect(context, shapeRect);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);
    
    [super drawRect:rect];
}


@end
