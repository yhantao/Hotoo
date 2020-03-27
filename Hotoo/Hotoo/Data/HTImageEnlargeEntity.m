//
//  HTImageEnlargeEntity.m
//  Hotoo
//
//  Created by Hantao Yang on 3/13/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTImageEnlargeEntity.h"

@implementation HTImageEnlargeEntity

+ (instancetype)newsModelWithDict:(NSDictionary *)dict{
    HTImageEnlargeEntity *model = [[HTImageEnlargeEntity alloc] init];
    [model setValue:dict[@"imgurl"] forKey:@"imgurl"];
    [model setValue:dict[@"note"] forKey:@"note"];
    return model;
}

@end
