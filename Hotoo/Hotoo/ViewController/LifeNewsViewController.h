//
//  LifeNewsViewController.h
//  Hotoo
//
//  Created by Hantao Yang on 3/13/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTBarLabel.h"

@interface LifeNewsViewController : UIViewController<HTBarLabelDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) UIStackView *stv;
@property (nonatomic, weak) UIScrollView *scv;

@end

