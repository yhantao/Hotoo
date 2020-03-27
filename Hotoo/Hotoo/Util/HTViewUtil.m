//
//  HTViewUtil.m
//  Hotoo
//
//  Created by Hantao Yang on 3/16/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTViewUtil.h"

@implementation HTViewUtil

@end

@implementation UIView (HT)

- (UIView *)findSubview:(NSString *)name recursive:(BOOL)recursive{
    Class class = NSClassFromString(name);
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:class]) {
            return subview;
        }
    }
    
    if (recursive) {
        for (UIView *subview in self.subviews) {
            UIView *tempView = [subview findSubview:name recursive:recursive];
            if (tempView) {
                return tempView;
            }
        }
    }
    return nil;
}

@end

