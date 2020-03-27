//
//  HTHotWordCell.m
//  Hotoo
//
//  Created by Hantao Yang on 3/15/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTHotWordCell.h"

@implementation HTHotWordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        // add number label
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 30, 20)];
        [self.contentView addSubview:numberLabel];
        self.numberLabel = numberLabel;
        [self.numberLabel setTextColor:[UIColor colorWithRed:(157.0 + index * 5)/255 green:(82.0 + index * 5)/255 blue:(44.0 + index * 5)/255 alpha:1]];
        [self.numberLabel setFont:[UIFont fontWithName:@"PingFangSC-Medium" size:18]];
        [self.numberLabel sizeToFit];
        self.numberLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.numberLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:15].active = YES;
        [self.numberLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-15].active = YES;
        [self.numberLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:30].active = YES;
        
        // add detail label
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, [UIScreen mainScreen].bounds.size.width - 60, 20)];
        [self.contentView addSubview:detailLabel];
        self.detailLabel = detailLabel;
        [self.detailLabel setTextColor:[UIColor blackColor]];
        [self.detailLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
        [self.detailLabel sizeToFit];
        self.detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.detailLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:15].active = YES;
        [self.detailLabel.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-15].active = YES;
        [self.detailLabel.leadingAnchor constraintEqualToAnchor:self.numberLabel.leadingAnchor constant:40].active = YES;
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
    [self.detailLabel addGestureRecognizer:gesture];
    [self.detailLabel setUserInteractionEnabled:YES];
    return self;
}

- (void)setNumber:(NSInteger)index{
    self.numberLabel.text = [NSString stringWithFormat:@"%@.",[@(index) description]];
    [self.numberLabel setTextColor:[UIColor colorWithRed:(157.0 + index * 5)/255 green:(82.0 + index * 5)/255 blue:(44.0 + index * 5)/255 alpha:1]];
}

- (void)setDetail:(NSString *)detail{
    self.detailLabel.text = detail;
}

- (void)prepareForReuse{
    [super prepareForReuse];
}

- (void)cellTapped:(UITapGestureRecognizer *)sender{
    [self.delegate clicked:[self.numberLabel.text intValue] - 1];
}



@end
