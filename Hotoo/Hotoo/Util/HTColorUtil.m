//
//  HTColorUtil.m
//  Hotoo
//
//  Created by Hantao Yang on 2/25/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTColorUtil.h"

@implementation HTColorUtil

@end

@implementation UIColor(HT)

+ (UIColor *)yellow_ht{
    return [UIColor colorWithRed:255.0/255 green:227.0/255 blue:109.0/255 alpha:1];
}
+ (UIColor *)orange_ht{
    return [UIColor colorWithRed:222.0/255 green:133.0/255 blue:80.0/255 alpha:1];
}
+ (UIColor *)brown_ht{
    return [UIColor colorWithRed:157.0/255 green:82.0/255 blue:44.0/255 alpha:1];
}
+ (UIColor *)blue_ht{
    return [UIColor colorWithRed:78.0/255 green:131.0/255 blue:206.0/255 alpha:1];
}

@end
