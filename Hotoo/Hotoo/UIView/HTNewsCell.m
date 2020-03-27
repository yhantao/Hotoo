//
//  HTNewsCell.m
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsCell.h"
#import "HTNewsEntity.h"
#import "SDWebImage.h"
#import "HTImageZoomingManager.h"
#import "HTColorUtil.h"
@interface HTNewsCell()

@property (nonatomic, strong) HTImageZoomingManager *manager;

@end

@implementation HTNewsCell

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
        // img
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:imgView];
        self.img = imgView;
        self.img.frame = CGRectMake(10, 10, 120, 90);
        self.img.image = [UIImage imageNamed:@"placeholder-img"];
        self.img.contentMode = UIViewContentModeScaleAspectFill;
        self.img.clipsToBounds = YES;
        
        // title
        UILabel *title = [[UILabel alloc] init];
        title.numberOfLines = 2;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
        [self.contentView addSubview:title];
        self.title = title;
        self.title.frame = CGRectMake(140, 10, [UIScreen mainScreen].bounds.size.width - 150, 50);
        [self.title sizeToFit];
        self.title.translatesAutoresizingMaskIntoConstraints = NO;
        [self.title.leadingAnchor constraintEqualToAnchor:self.img.trailingAnchor constant:10].active = YES;
        [self.title.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width - 150].active = YES;
        [self.title.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:10].active = YES;
        
        
        // src
        UILabel *src = [[UILabel alloc] init];
        src.textColor = [UIColor lightGrayColor];
        src.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        src.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:src];
        self.src = src;
        self.src.frame = CGRectMake(120, 60, 100, 25);
        
        // replyCount
        UILabel *replyCount = [[UILabel alloc] init];
        replyCount.textColor = [UIColor blackColor];
        replyCount.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        replyCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:replyCount];
        self.replyCount = replyCount;
        self.replyCount.frame = CGRectMake(self.frame.size.width - 80, 60, 50, 25);
    
        
        // replyCount
        UILabel *votecount = [[UILabel alloc] init];
        votecount.textColor = [UIColor blackColor];
        votecount.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        votecount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:votecount];
        self.votecountLabel = votecount;
        self.votecountLabel.frame = CGRectMake(self.frame.size.width - 80, 85, 50, 25);
        
        // ptime
        UILabel *ptime = [[UILabel alloc] init];
        ptime.textColor = [UIColor blackColor];
        ptime.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:12];
        ptime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:ptime];
        self.ptime = ptime;
        self.ptime.frame = CGRectMake(self.frame.size.width - 30, 60, 50, 25);

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
            self.img.userInteractionEnabled = YES;
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget: self.manager action:@selector(viewTapped:)];
            [self.img addGestureRecognizer:gesture];
        }
    }
    
    // title
    self.title.text = model.title;
    
    // src
    self.src.text = (!model.source || model.source.length == 0) ? @"Hotoo新闻" : model.source;
    [self.src sizeToFit];
    self.src.translatesAutoresizingMaskIntoConstraints = NO;
    [self.src.topAnchor constraintEqualToAnchor:self.title.bottomAnchor constant:5].active = YES;
    [self.src.leadingAnchor constraintEqualToAnchor:self.img.trailingAnchor constant:10].active = YES;
    
    // priority
    if([model.replyCount intValue] >= 1000 && [model.votecount intValue] >= 1000){
        UILabel *priority = [[UILabel alloc] init];
        priority.font = [UIFont fontWithName:@"PingFangSC-Light" size:11];
        priority.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:priority];
        self.priorityLabel = priority;
        self.priorityLabel.frame = CGRectMake(120, 85, 100, 15);
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
        self.priorityLabel.frame = CGRectMake(120, 85, 100, 15);
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
        self.qualityLabel.frame = CGRectMake(150, 85, 100, 15);
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
    self.replyCount.frame = CGRectMake(self.src.frame.origin.x + self.src.frame.size.width + 10, 50, 100, 20);
    [self.replyCount sizeToFit];
    self.replyCount.translatesAutoresizingMaskIntoConstraints = NO;
    [self.replyCount.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.replyCount.leadingAnchor constraintEqualToAnchor:self.img.trailingAnchor constant:10].active = YES;
    
    // votecount
    NSString *voteCountText;
    if([model.votecount intValue] > 10000){
        voteCountText = [NSString stringWithFormat:@"%.1f 万点赞", [model.votecount intValue] / 10000.0];
    }else{
        voteCountText = [NSString stringWithFormat:@"%d 点赞", [model.votecount intValue]];
    }
    self.votecountLabel.text = voteCountText;
    self.votecountLabel.frame = CGRectMake(120, 50, 100, 20);
    [self.votecountLabel sizeToFit];
    self.votecountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.votecountLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.votecountLabel.leadingAnchor constraintEqualToAnchor:self.replyCount.trailingAnchor constant:10].active = YES;
    
    
    // ptime
    self.ptime.text = model.ptime;
    self.ptime.frame = CGRectMake(self.replyCount.frame.origin.x + self.replyCount.frame.size.width + 10, 50, 100, 20);
    [self.ptime sizeToFit];
    self.ptime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ptime.trailingAnchor constraintEqualToAnchor:self.title.trailingAnchor].active = YES;
    [self.ptime.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    
    // img
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder-img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"");
    }];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.img.image = [UIImage imageNamed:@"placeholder-img"];
    [self.qualityLabel removeFromSuperview];
    self.qualityLabel = nil;
    [self.priorityLabel removeFromSuperview];
    self.priorityLabel = nil;
    if (self.img.gestureRecognizers.count > 0){
        UITapGestureRecognizer *gesture = self.img.gestureRecognizers[0];
        [self.img removeGestureRecognizer:gesture];
    }
    
}
@end
