//
//  HTBarLabel.m
//  Hotoo
//
//  Created by Hantao Yang on 2/10/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTBarLabel.h"
#import "HTColorUtil.h"

@implementation HTBarLabel


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:20];
        self.scale = 0.0;
    }
    return self;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    if (scale == 0){
        self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    }else{
        self.textColor = [UIColor brown_ht];
    }

    CGFloat minScale = 0.8;
    CGFloat trueScale = minScale + (1 - minScale) * scale;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}


@end
