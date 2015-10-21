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

- (BOOL)pointInsideFigure:(CGPoint)point
{
    CGRect rect = CGRectMake(0, 0, self.shape.size.width, self.shape.size.height);
    CGRect figureRect = CGRectInset(rect, kSEShapeViewRectInsetDx, kSEShapeViewRectInsetDy);
    
    CGPoint points[] = {
        CGPointMake(figureRect.origin.x + figureRect.size.width / 2, figureRect.origin.y),
        CGPointMake(figureRect.origin.x + figureRect.size.width, figureRect.origin.y + figureRect.size.height),
        figureRect.origin.x, figureRect.origin.y + figureRect.size.height
    };
    
    CGMutablePathRef gPathMut = CGPathCreateMutable();
    CGPathMoveToPoint(gPathMut, nil, points[0].x, points[0].y);
    for (int i = 1; i <= 2; i++) {
        CGPathAddLineToPoint(gPathMut, nil, points[i].x, points[i].y);
    }
    CGPathCloseSubpath(gPathMut);
    
    BOOL isPointWithin = CGPathContainsPoint(gPathMut, nil, point, false);
    CGPathRelease(gPathMut);
    
    return isPointWithin;
}


@end
