//
//  NewsViewController.h
//  Hotoo
//
//  Created by Hantao Yang on 2/22/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBarLabel.h"


@interface NewsViewController : UIViewController <HTBarLabelDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIStackView *stv;
@property (nonatomic, weak) UIScrollView *scv;

@end

