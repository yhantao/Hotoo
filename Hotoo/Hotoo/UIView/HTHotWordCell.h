//
//  HTHotWordCell.h
//  Hotoo
//
//  Created by Hantao Yang on 3/15/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTHotWordCellDelegate <NSObject>

@optional
- (void)clicked:(NSInteger)index;

@end

@interface HTHotWordCell : UITableViewCell

@property (nonatomic, weak) UILabel *numberLabel;
@property (nonatomic, weak) UILabel *detailLabel;
@property (nonatomic, weak) id<HTHotWordCellDelegate> delegate;

- (instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier index:(NSInteger)index;
- (void)setNumber:(NSInteger)number;
- (void)setDetail:(NSString *)detail;
@end

