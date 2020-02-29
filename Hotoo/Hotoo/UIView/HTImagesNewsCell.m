//
//  HTImagesNewsCell.m
//  Hotoo
//
//  Created by Hantao Yang on 2/24/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTImagesNewsCell.h"
#import "HTNewsEntity.h"
#import "SDWebImage.h"

@implementation HTImagesNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        // img1
        UIImageView *imgView1 = [[UIImageView alloc] init];
        imgView1.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imgView1];
        self.img1 = imgView1;
        self.img1.frame = CGRectMake(10, 10, ([UIScreen mainScreen].bounds.size.width - 40) / 3.0, 90);
        self.img1.image = [UIImage imageNamed:@"placeholder-img"];
        self.img1.contentMode = UIViewContentModeScaleAspectFill;
        self.img1.clipsToBounds = YES;
        
        // img1
        UIImageView *imgView2 = [[UIImageView alloc] init];
        imgView2.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imgView2];
        self.img2 = imgView2;
        self.img2.frame = CGRectMake(20 + ([UIScreen mainScreen].bounds.size.width - 40) / 3.0, 10, ([UIScreen mainScreen].bounds.size.width - 40) / 3.0, 90);
        self.img2.image = [UIImage imageNamed:@"placeholder-img"];
        self.img2.contentMode = UIViewContentModeScaleAspectFill;
        self.img2.clipsToBounds = YES;
        
        // img3
        UIImageView *imgView3 = [[UIImageView alloc] init];
        imgView3.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imgView3];
        self.img3 = imgView3;
        self.img3.frame = CGRectMake(30 + ([UIScreen mainScreen].bounds.size.width - 40) / 3.0 * 2, 10, ([UIScreen mainScreen].bounds.size.width - 40) / 3.0, 90);
        self.img3.image = [UIImage imageNamed:@"placeholder-img"];
        self.img3.contentMode = UIViewContentModeScaleAspectFill;
        self.img3.clipsToBounds = YES;
        
        // title
        UILabel *title = [[UILabel alloc] init];
        title.numberOfLines = 1;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        title.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:title];
        self.title = title;
        self.title.frame = CGRectMake(10, 105, [UIScreen mainScreen].bounds.size.width - 20, 30);
        
        // src
        UILabel *src = [[UILabel alloc] init];
        src.textColor = [UIColor blackColor];
        src.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        src.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:src];
        self.src = src;
        self.src.frame = CGRectMake(10, 140, 100, 20);
        
        // replyCount
        UILabel *replyCount = [[UILabel alloc] init];
        replyCount.textColor = [UIColor blackColor];
        replyCount.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        replyCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:replyCount];
        self.replyCount = replyCount;
        self.replyCount.frame = CGRectMake(100, 140, 50, 20);
        
        // ptime
        UILabel *ptime = [[UILabel alloc] init];
        ptime.textColor = [UIColor blackColor];
        ptime.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        ptime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:ptime];
        self.ptime = ptime;
        self.ptime.frame = CGRectMake(200, 140, 50, 20);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutCellWithModel:(HTNewsEntity *)model{
    // title
    self.title.text = model.title;
    
    // 1st image
    [self.img1 sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder-img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"");
    }];
    // 2nd image
    [self.img2 sd_setImageWithURL:[NSURL URLWithString:model.imgextra[0]] placeholderImage:[UIImage imageNamed:@"placeholder-img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"");
    }];
    // 3rd image
    [self.img3 sd_setImageWithURL:[NSURL URLWithString:model.imgextra[1]] placeholderImage:[UIImage imageNamed:@"placeholder-img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"");
    }];
    
    // src
    self.src.text = model.source;
    [self.src sizeToFit];
    self.src.translatesAutoresizingMaskIntoConstraints = NO;
    [self.src.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.src.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
    
    // reply count
    self.replyCount.text = [NSString stringWithFormat:@"  %@ 跟帖  ", model.replyCount];
    self.replyCount.frame = CGRectMake(self.src.frame.origin.x + self.src.frame.size.width + 10, 50, 100, 20);
    [self.replyCount sizeToFit];
    self.replyCount.layer.cornerRadius = 5.0f;
    self.replyCount.layer.borderColor = [UIColor grayColor].CGColor;
    self.replyCount.layer.borderWidth = 0.2f;
    self.replyCount.translatesAutoresizingMaskIntoConstraints = NO;
    [self.replyCount.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.replyCount.leadingAnchor constraintEqualToAnchor:self.src.trailingAnchor constant:10].active = YES;
    
    // ptime
    self.ptime.text = model.ptime;
    self.ptime.frame = CGRectMake(self.replyCount.frame.origin.x + self.replyCount.frame.size.width + 10, 50, 100, 20);
    [self.ptime sizeToFit];
    self.ptime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ptime.trailingAnchor constraintEqualToAnchor:self.title.trailingAnchor].active = YES;
    [self.ptime.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.img1.image = [UIImage imageNamed:@"placeholder-img"];
    self.img2.image = [UIImage imageNamed:@"placeholder-img"];
    self.img3.image = [UIImage imageNamed:@"placeholder-img"];
}

@end
