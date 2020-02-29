//
//  HTNavigationBar.m
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNavigationBar.h"

static int maxHeight = 60;
@implementation HTNavigationBar

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize navigationBarSize = [super sizeThatFits:size];
    
    navigationBarSize.height = maxHeight;
    
    return navigationBarSize;
}

@end
