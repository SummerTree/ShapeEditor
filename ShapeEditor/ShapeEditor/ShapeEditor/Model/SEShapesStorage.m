//
//  SEShapesStorage.m
//  ShapeEditor
//
//  Created by Alexander Lobanov on 18.10.15.
//  Copyright (c) 2015 iSpring. All rights reserved.
//

#import "SEShapesStorage.h"

static NSString *const kSEShapesStorageName = @"shapes";

@implementation SEShapesStorage

+ (void)storeShapes:(NSArray *)shapes
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:shapes];
    [defaults setObject:data forKey:kSEShapesStorageName];
    [defaults synchronize];
    
    NSLog(@"shapes stored");
}

+ (void)reStoreShapes:(void(^)(NSArray *shapes))result
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kSEShapesStorageName];
        NSArray *shapes = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        if(result) result(shapes);
    });
}

@end
