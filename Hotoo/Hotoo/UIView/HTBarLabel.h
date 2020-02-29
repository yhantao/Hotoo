//
//  HTBarLabel.h
//  Hotoo
//
//  Created by Hantao Yang on 2/10/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HTBarLabelDelegate <NSObject>

- (void)changeLabelFrom:(NSInteger)from to:(NSInteger)to;

@end


@interface HTBarLabel : UILabel

@property (nonatomic, weak) id<HTBarLabelDelegate> delegate;
@property (nonatomic, assign) CGFloat scale;


@end

