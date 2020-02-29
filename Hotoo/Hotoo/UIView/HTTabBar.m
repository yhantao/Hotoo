//
//  HTTabBar.m
//  Hotoo
//
//  Created by Hantao Yang on 2/25/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTTabBar.h"

@implementation HTTabBar

//- (void)layoutSubviews{
//    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
//    for (UIView *view in self.subviews){
//        if ([view isKindOfClass:NSClassFromStrong(@"UITabBarButton")]){
//            [tabBarButtonArray addObject:view];
//        }
//    }
//    // calculation
//    CGFloat barWidth = self.bounds.size.width;
//    CGFloat barHeight = self.bounds.size.height;
//    CGFloat barItemWidth = (barWidth) / tabBarButtonArray.count;
//
//    //layout bar buttons
//    [tabBarButtonArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
//
//        CGRect frame = view.frame;
//        if (idx >= tabBarButtonArray.count / 2) {
//            // 重新设置 x 坐标，如果排在中间按钮的右边需要加上中间按钮的宽度
//            frame.origin.x = idx * barItemWidth + centerBtnWidth;
//        } else {
//            frame.origin.x = idx * barItemWidth;
//        }
//        // 重新设置宽度
//        frame.size.width = barItemWidth;
//        view.frame = frame;
//    }];
//}

@end
