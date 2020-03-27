//
//  HTSimilarNewsCell.m
//  Hotoo
//
//  Created by Hantao Yang on 3/2/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTSimilarNewsCell.h"

@implementation HTSimilarNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier isNotLast:(BOOL)notLast{
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
        title.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        title.textAlignment = NSTextAlignmentJustified;
        [self.contentView addSubview:title];
        self.title = title;
        self.title.frame = CGRectMake(100, 10, [UIScreen mainScreen].bounds.size.width - 110, 40);
        
        
        // ptime
        UILabel *ptime = [[UILabel alloc] init];
        ptime.textColor = [UIColor blackColor];
        ptime.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:11];
        ptime.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:ptime];
        self.ptime = ptime;
        self.ptime.frame = CGRectMake(100, 50, 50, 20);

        // separator
        if (notLast){
            UIView *separator = [[UIView alloc] init];
            separator.backgroundColor = [UIColor lightGrayColor];
            [self.contentView addSubview:separator];
            separator.translatesAutoresizingMaskIntoConstraints = NO;
            [separator.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
            [separator.widthAnchor constraintEqualToConstant:[UIScreen mainScreen].bounds.size.width - 20].active = YES;
            [separator.topAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-0.4].active = YES;
            [separator.heightAnchor constraintEqualToConstant:0.4].active = YES;
            
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutCellWithModel:(HTSimilarNewsEntity *)model{
    // title
    self.title.text = model.title;
    
    // src
    self.ptime.text = model.ptime;
    [self.ptime sizeToFit];
    self.ptime.translatesAutoresizingMaskIntoConstraints = NO;
    [self.ptime.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-10].active = YES;
    [self.ptime.leadingAnchor constraintEqualToAnchor:self.img.trailingAnchor constant:10].active = YES;
    
    
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
