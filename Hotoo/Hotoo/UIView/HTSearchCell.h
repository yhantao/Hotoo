//
//  HTSearchCell.h
//  Hotoo
//
//  Created by Hantao Yang on 2/27/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTSearchCell : UITableViewCell

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *ptime;

- (void)layoutViews:(NSString *)str andTime:(NSString *)ptime;

@end

