//
//  ViewController.h
//  ShapeEditor
//
//  Created by Alexander Lobanov on 15.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SEWorkArea.h"
#import "SEShapeView.h"
#import "SEShapeSelectionView.h"

@interface EditorViewController : UIViewController <SEWorkAreaDelegate, SEShapeViewDelegate>


@end

