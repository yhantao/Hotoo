//
//  HTSimilarNewsCell.h
//  Hotoo
//
//  Created by Hantao Yang on 3/2/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTSimilarNewsEntity.h"
#import "SDWebImage.h"

@interface HTSimilarNewsCell : UITableViewCell

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) UIImageView *img;
@property (nonatomic, weak) UILabel *src;
@property (nonatomic, weak) UILabel *replyCount;
@property (nonatomic, weak) UILabel *ptime;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isNotLast:(BOOL)notLast;

- (void)layoutCellWithModel:(HTSimilarNewsEntity *)model;

@end
