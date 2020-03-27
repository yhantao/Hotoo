//
//  HTNewsCell.h
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNewsEntity.h"

@interface HTNewsCell : UITableViewCell

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UIImageView *img;
@property (nonatomic, weak) UILabel *src;
@property (nonatomic, weak) UILabel *replyCount;
@property (nonatomic, weak) UILabel *ptime;
@property (nonatomic, weak) UILabel *votecountLabel;
@property (nonatomic, weak) UILabel *priorityLabel;
@property (nonatomic, weak) UILabel *qualityLabel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)layoutCellWithModel:(HTNewsEntity *)model;
@end

