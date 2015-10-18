//
//  UIView+Extended.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 17.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "UIView+Extended.h"

@implementation UIView (Extended)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGSize)size
{
    return self.frame.size;
}

- (CGPoint)center
{
    return CGPointMake(self.width / 2.0, self.height / 2.0);
}



@end
