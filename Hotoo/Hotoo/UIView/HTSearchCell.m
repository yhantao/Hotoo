//
//  HTSearchCell.m
//  Hotoo
//
//  Created by Hantao Yang on 2/27/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTSearchCell.h"
@interface HTSearchCell()

@property (nonatomic, weak) UILabel *label;
@property (nonatomic, weak) UILabel *timeLabel;

@end
@implementation HTSearchCell

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
    if(self){
        
        // title
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        self.label = label;
        self.label.translatesAutoresizingMaskIntoConstraints = NO;
        [self.label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
        [self.label.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = YES;
        [self.label.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20].active = YES;
        
        [self.label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        self.label.numberOfLines = 0;
        
        // ptime
        UILabel *timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.timeLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:10].active = YES;
        [self.timeLabel.topAnchor constraintEqualToAnchor:self.label.bottomAnchor constant:10].active = YES;
        [self.timeLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-20].active = YES;
        [self.timeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:12]];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutViews:(NSString *)str andTime:(NSString *)ptime{
    NSMutableString *mstring = [str mutableCopy];
    [mstring replaceOccurrencesOfString:@"<em>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstring.length)];
    [mstring replaceOccurrencesOfString:@"</em>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstring.length)];
    
    self.label.text = [mstring copy];
    self.timeLabel.text = ptime;
    
}

@end

