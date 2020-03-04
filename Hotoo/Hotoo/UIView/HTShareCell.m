//
//  HTShareCell.m
//  Hotoo
//
//  Created by Hantao Yang on 3/3/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTShareCell.h"

@implementation HTShareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        // label
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 25)];
        lbl.text = @"分享到微信 / 微博领红包";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:16];
        [self.contentView addSubview:lbl];
        
        
        // stack view
        UIStackView *view = [[UIStackView alloc] init];
        [self.contentView addSubview:view];
        view.frame = CGRectMake(80, 40, [UIScreen mainScreen].bounds.size.width - 160, 30);
        view.distribution = UIStackViewDistributionFillEqually;
        view.axis = UILayoutConstraintAxisHorizontal;
        view.spacing = 20;
        
        // img1
        UIImageView *imgView1 = [[UIImageView alloc] init];
        [view addArrangedSubview:imgView1];
        imgView1.frame = CGRectMake(10, 0, 15, 15);
        imgView1.image = [UIImage imageNamed:@"qq"];
        imgView1.contentMode = UIViewContentModeScaleAspectFit;
        
        // img2
        UIImageView *imgView2 = [[UIImageView alloc] init];
        [view addArrangedSubview:imgView2];
        imgView2.frame = CGRectMake(20, 0, 15, 15);
        imgView2.image = [UIImage imageNamed:@"wechat"];
        imgView2.contentMode = UIViewContentModeScaleAspectFit;
        
        // img3
        UIImageView *imgView3 = [[UIImageView alloc] init];
        [view addArrangedSubview:imgView3];
        imgView3.frame = CGRectMake(30, 0, 15, 15);
        imgView3.image = [UIImage imageNamed:@"weibo"];
        imgView3.contentMode = UIViewContentModeScaleAspectFit;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
