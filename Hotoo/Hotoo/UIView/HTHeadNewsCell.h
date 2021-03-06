//
//  HTHeadNewsCell.h
//  Hotoo
//
//  Created by Hantao Yang on 2/24/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTNewsEntity.h"

@interface HTHeadNewsCell : UITableViewCell

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UIImageView *img;
@property (nonatomic, weak) UILabel *src;
@property (nonatomic, weak) UILabel *replyCount;
@property (nonatomic, weak) UILabel *ptime;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void)layoutCellWithModel:(HTNewsEntity *)model;

@end

