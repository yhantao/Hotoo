//
//  HTNewsDetailsEntity.h
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNewsDetailsEntity : NSObject

/** 新闻标题 */
@property (nonatomic, copy) NSString *title;
/** 新闻发布时间 */
@property (nonatomic, copy) NSString *ptime;
/** 新闻内容 */
@property (nonatomic, copy) NSString *body;
/** 新闻配图 (模型) */
@property (nonatomic, strong) NSArray *img;
/** 模块名*/
@property(nonatomic,copy)NSString *replyBoard;
/** 回复数*/
@property(nonatomic,assign)NSInteger replyCount;

+(instancetype) detailsEntityWithDict:(NSDictionary *)dict;

@end

