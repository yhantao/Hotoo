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
        self.img.frame = CGRectMake(10, 10, 80, 60);
        self.img.image = [UIImage imageNamed:@"placeholder-img"];
        self.img.contentMode = UIViewContentModeScaleAspectFill;
        self.img.clipsToBounds = YES;
        
        // title
        UILabel *title = [[UILabel alloc] init];
        title.numberOfLines = 2;
        title.textColor = [UIColor blackColor];
        title.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];
        title.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:title];
        self.title = title;
        self.title.frame = CGRectMake(100, 10, [UIScreen mainScreen].bounds.size.width - 110, 35);
        
        // src
        UILabel *src = [[UILabel alloc] init];
        src.textColor = [UIColor blackColor];
        src.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        src.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:src];
        self.src = src;
        self.src.frame = CGRectMake(100, 50, 100, 20);
        
        // replyCount
        UILabel *replyCount = [[UILabel alloc] init];
        replyCount.textColor = [UIColor blackColor];
        replyCount.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        replyCount.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:replyCount];
        self.replyCount = replyCount;
        self.replyCount.frame = CGRectMake(self.frame.size.width - 60, 50, 50, 20);
        
        // ptime
        UILabel *ptime = [[UILabel alloc] init];
        ptime.textColor = [UIColor blackColor];
        ptime.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        ptime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:ptime];
        self.ptime = ptime;
        self.ptime.frame = CGRectMake(self.frame.size.width - 20, 50, 50, 20);

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutCellWithModel:(HTNewsEntity *)model{
    // title
    self.title.text = model.title;
    
    // src
    self.src.text = model.source;
    [self.src sizeToFit];
    self.src.translatesAutoresizingMaskIntoConstraints = NO;
    [self.src.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.src.leadingAnchor constraintEqualToAnchor:self.img.trailingAnchor constant:10].active = YES;
    
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
    
    // img
    [self.img sd_setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"placeholder-img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        NSLog(@"");
    }];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.img.image = [UIImage imageNamed:@"placeholder-img"];
}
@end
