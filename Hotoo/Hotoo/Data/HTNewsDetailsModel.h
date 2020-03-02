//
//  HTNewsDetailsModel.h
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HTNewsDetailsEntity.h"
#import "HTNewsEntity.h"
#import "RACCommand.h"

@interface HTNewsDetailsModel : NSObject

@property(nonatomic,strong) HTNewsDetailsEntity *detailEntity;
@property(nonatomic,strong) id<HTDetailEntityDelegate> entity;
/**
 *  相似新闻
 */
@property(nonatomic,strong)NSMutableArray *sameNews;
/**
 *  搜索关键字
 */
@property(nonatomic,strong)NSArray *keywordSearch;
/**
 *  评论列表
 */
@property(nonatomic,strong) NSMutableArray *replyModels;
/**
 *  获取搜索结果数组命令
 */
@property(nonatomic, strong) RACCommand *fetchNewsDetailCommand;
/**
 *  获取热门评价数组命令
 */
@property(nonatomic, strong) RACCommand *fetchHotFeedbackCommand;
/**
 *  将拼接html的操作在业务逻辑层做
 *
 *  @return 将拼好后的html字符串返回
 */

- (instancetype)initWithEntity:(id<HTDetailEntityDelegate>)entity;
- (NSString *)getHtmlString;

@end

