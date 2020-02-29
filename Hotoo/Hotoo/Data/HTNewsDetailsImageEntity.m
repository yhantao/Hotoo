//
//  HTNewsDetailsImageEntity.m
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsDetailsImageEntity.h"

@implementation HTNewsDetailsImageEntity

+ (instancetype)detailImgWithDict:(NSDictionary *)dict{
    HTNewsDetailsImageEntity *imgModel = [[HTNewsDetailsImageEntity alloc] init];
    imgModel.ref = dict[@"ref"];
    imgModel.pixel = dict[@"pixel"];
    imgModel.src = dict[@"src"];
    
    return imgModel;
}
@end
