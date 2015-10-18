//
//  SETriangleShapeView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 17.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SETriangleShapeView.h"

@implementation SETriangleShapeView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGRect shapeRect = CGRectInset(rect, kSEShapeViewRectInsetDx, kSEShapeViewRectInsetDy);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    UIColor *fillColor = (self.shape.selected)? [UIColor shapeSelectedFillColor]: [UIColor shapeFillColor];
    CGContextSetFillColor(context, CGColorGetComponents(fillColor.CGColor));
    CGContextSetStrokeColor(context, CGColorGetComponents([UIColor shapeStrokeColor].CGColor));
    
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, shapeRect.origin.x + shapeRect.size.width/2, shapeRect.origin.y);
    CGContextAddLineToPoint(context, shapeRect.origin.x + shapeRect.size.width, shapeRect.origin.y + shapeRect.size.height);
    CGContextAddLineToPoint(context, shapeRect.origin.x, shapeRect.origin.y + shapeRect.size.height);
    CGContextClosePath(context);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextFillPath(context);
    
    [super drawRect:rect];
}

@end
