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
#import "HTImageZoomingManager.h"
#import "HTColorUtil.h"

@interface HTImagesNewsCell()

@property (nonatomic, strong) HTImageZoomingManager *manager;

@end

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
        title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        title.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:title];
        self.title = title;
        self.title.frame = CGRectMake(10, 105, [UIScreen mainScreen].bounds.size.width - 20, 30);
        
        // src
        UILabel *src = [[UILabel alloc] init];
        src.textColor = [UIColor lightGrayColor];
        src.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        src.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:src];
        self.src = src;
        self.src.frame = CGRectMake(10, 140, 100, 20);
        
        // replyCount
        UILabel *replyCount = [[UILabel alloc] init];
        replyCount.textColor = [UIColor blackColor];
        replyCount.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        replyCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:replyCount];
        self.replyCount = replyCount;
        self.replyCount.frame = CGRectMake(100, 140, 50, 20);
        
        // ptime
        UILabel *ptime = [[UILabel alloc] init];
        ptime.textColor = [UIColor blackColor];
        ptime.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        ptime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:ptime];
        self.ptime = ptime;
        self.ptime.frame = CGRectMake(200, 140, 50, 20);
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutCellWithModel:(HTNewsEntity *)model{
    
    // manager photo set id
    if(model.photosetID && model.photosetID.length > 0){
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"_"];
        NSRange range = [model.docid rangeOfCharacterFromSet:cset];
        if (range.location != NSNotFound) {
            // gesture
            self.manager = [[HTImageZoomingManager alloc] initWithPhotoSetID:model.photosetID];
            self.img1.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget: self.manager action:@selector(viewTapped:)];
            [self.img1 addGestureRecognizer:gesture1];
            
            self.img2.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget: self.manager action:@selector(viewTapped:)];
            [self.img2 addGestureRecognizer:gesture2];
            
            self.img3.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture3 = [[UITapGestureRecognizer alloc] initWithTarget: self.manager action:@selector(viewTapped:)];
            [self.img3 addGestureRecognizer:gesture3];
        }
    }
    
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
    self.src.text = (!model.source || model.source.length == 0) ? @"Hotoo新闻" : model.source;
    [self.src sizeToFit];
    self.src.translatesAutoresizingMaskIntoConstraints = NO;
    [self.src.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.src.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
    
    // priority
    if([model.replyCount intValue] >= 1000 && [model.votecount intValue] >= 1000){
        UILabel *priority = [[UILabel alloc] init];
        priority.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        priority.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:priority];
        self.priorityLabel = priority;
        self.priorityLabel.frame = CGRectMake(100, 140, 100, 15);
        [self.priorityLabel setText:@" 爆 "];
        [self.priorityLabel setTextColor:[UIColor whiteColor]];
        self.priorityLabel.backgroundColor = [UIColor orangeColor];
        self.priorityLabel.clipsToBounds = YES;
        self.priorityLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        self.priorityLabel.layer.cornerRadius = 3.0f;
        self.priorityLabel.layer.borderWidth = 0.5f;
        [self.priorityLabel setHidden:NO];
        self.priorityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.priorityLabel.leadingAnchor constraintEqualToAnchor:self.src.trailingAnchor constant:5].active = YES;
        [self.priorityLabel.centerYAnchor constraintEqualToAnchor:self.src.centerYAnchor].active = YES;
    }
    else if ([model.replyCount intValue] >= 10 && [model.votecount intValue] >= 10){
        UILabel *priority = [[UILabel alloc] init];
        priority.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        priority.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:priority];
        self.priorityLabel = priority;
        self.priorityLabel.frame = CGRectMake(100, 140, 100, 15);
        [self.priorityLabel setText:@" 热 "];
        [self.priorityLabel setTextColor:[UIColor redColor]];
        self.priorityLabel.backgroundColor = [UIColor whiteColor];
        self.priorityLabel.layer.borderColor = [UIColor redColor].CGColor;
        self.priorityLabel.layer.cornerRadius = 3.0f;
        self.priorityLabel.layer.borderWidth = 0.5f;
        [self.priorityLabel setHidden:NO];
        self.priorityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.priorityLabel.leadingAnchor constraintEqualToAnchor:self.src.trailingAnchor constant:5].active = YES;
        [self.priorityLabel.centerYAnchor constraintEqualToAnchor:self.src.centerYAnchor].active = YES;
    }
    
    // quality
    if ([model.quality intValue] >= 80){
        UILabel *qualityLabel = [[UILabel alloc] init];
        qualityLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        qualityLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:qualityLabel];
        self.qualityLabel = qualityLabel;
        self.qualityLabel.frame = CGRectMake(150, 140, 100, 15);
        [self.qualityLabel setText:@" 精选 "];
        [self.qualityLabel setTextColor:[UIColor blue_ht]];
        self.qualityLabel.backgroundColor = [UIColor whiteColor];
        self.qualityLabel.layer.borderColor = [UIColor blue_ht].CGColor;
        self.qualityLabel.layer.cornerRadius = 3.0f;
        self.qualityLabel.layer.borderWidth = 0.5f;
        [self.qualityLabel setHidden:NO];
        self.qualityLabel.translatesAutoresizingMaskIntoConstraints = NO;
        if(!self.priorityLabel){
            [self.qualityLabel.leadingAnchor constraintEqualToAnchor:self.src.trailingAnchor constant:5].active = YES;
        }else{
            [self.qualityLabel.leadingAnchor constraintEqualToAnchor:self.priorityLabel.trailingAnchor constant:2].active = YES;
        }
        [self.qualityLabel.centerYAnchor constraintEqualToAnchor:self.src.centerYAnchor].active = YES;
    }
    
    // reply count
    NSString *replyCountText;
    if([model.replyCount intValue] > 10000){
        replyCountText = [NSString stringWithFormat:@"%.1f 万跟帖", [model.replyCount intValue] / 10000.0];
    }else{
        replyCountText = [NSString stringWithFormat:@"%@ 跟帖", model.replyCount];;
    }
    self.replyCount.text = replyCountText;
    self.replyCount.frame = CGRectMake(self.qualityLabel.frame.origin.x + self.qualityLabel.frame.size.width + 10, 50, 100, 20);
    [self.replyCount sizeToFit];
    self.replyCount.translatesAutoresizingMaskIntoConstraints = NO;
    [self.replyCount.centerYAnchor constraintEqualToAnchor:self.src.centerYAnchor].active = YES;
    if(self.qualityLabel){
        [self.replyCount.leadingAnchor constraintEqualToAnchor:self.qualityLabel.trailingAnchor constant:10].active = YES;
    }
    else if(self.priorityLabel){
        [self.replyCount.leadingAnchor constraintEqualToAnchor:self.priorityLabel.trailingAnchor constant:10].active = YES;
    }
    else{
        [self.replyCount.leadingAnchor constraintEqualToAnchor:self.src.trailingAnchor constant:10].active = YES;
    }
    
    // ptime
    self.ptime.text = model.ptime;
    self.ptime.frame = CGRectMake(self.replyCount.frame.origin.x + self.replyCount.frame.size.width + 10, 50, 100, 20);
    [self.ptime sizeToFit];
    self.ptime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ptime.trailingAnchor constraintEqualToAnchor:self.title.trailingAnchor].active = YES;
    [self.ptime.centerYAnchor constraintEqualToAnchor:self.src.centerYAnchor].active = YES;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.img1.image = [UIImage imageNamed:@"placeholder-img"];
    self.img2.image = [UIImage imageNamed:@"placeholder-img"];
    self.img3.image = [UIImage imageNamed:@"placeholder-img"];
    [self.qualityLabel removeFromSuperview];
    self.qualityLabel = nil;
    [self.priorityLabel removeFromSuperview];
    self.priorityLabel = nil;
    if (self.img1.gestureRecognizers.count > 0){
        UITapGestureRecognizer *gesture1 = self.img1.gestureRecognizers[0];
        [self.img1 removeGestureRecognizer:gesture1];
    }
    if (self.img2.gestureRecognizers.count > 0){
        UITapGestureRecognizer *gesture2 = self.img2.gestureRecognizers[0];
        [self.img2 removeGestureRecognizer:gesture2];
    }
    if (self.img3.gestureRecognizers.count > 0){
        UITapGestureRecognizer *gesture3 = self.img3.gestureRecognizers[0];
        [self.img3 removeGestureRecognizer:gesture3];
    }
}

@end
