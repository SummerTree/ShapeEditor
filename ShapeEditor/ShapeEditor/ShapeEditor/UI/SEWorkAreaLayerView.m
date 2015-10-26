//
//  SEWorkAreaLayerView.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 26.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEWorkAreaLayerView.h"

@implementation SEWorkAreaLayerView

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
    
    if (self.tag == SEWorkAreaLayerViewTagBase) {
        if ([self pointInside:point withEvent:event]) {
            return self;
        }
    }
    
    return nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
