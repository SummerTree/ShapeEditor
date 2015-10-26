//
//  SEWorkAreaLayerView.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 26.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    SEWorkAreaLayerViewTagBase,
    SEWorkAreaLayerViewTagShapes = 101,
    SEWorkAreaLayerViewTagSelection = 102,
} SEWorkAreaLayerViewTags;

@interface SEWorkAreaLayerView : UIView

@end
