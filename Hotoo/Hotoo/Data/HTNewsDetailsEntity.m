//
//  HTNewsDetailsEntity.m
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsDetailsEntity.h"
#import "HTNewsDetailsImageEntity.h"

@implementation HTNewsDetailsEntity

+(instancetype)detailsEntityWithDict:(NSDictionary *)dict{
    
    HTNewsDetailsEntity *detail = [[HTNewsDetailsEntity alloc] init];

    detail.title = dict[@"title"];
    detail.ptime = dict[@"ptime"];
    detail.body = dict[@"body"];
    detail.replyBoard = dict[@"replyBoard"];
    detail.replyCount = [dict[@"replyCount"] integerValue];
    
    NSArray *imgArray = dict[@"img"];
    NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:imgArray.count];
    
    for (NSDictionary *dict in imgArray) {
        HTNewsDetailsImageEntity *imgModel = [HTNewsDetailsImageEntity detailImgWithDict:dict];
        [tmpArray addObject:imgModel];
    }
    detail.img = tmpArray;
    
    return detail;
}

@end
