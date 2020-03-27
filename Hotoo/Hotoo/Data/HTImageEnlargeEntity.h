//
//  HTImageEnlargeEntity.h
//  Hotoo
//
//  Created by Hantao Yang on 3/13/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTImageEnlargeEntity : NSObject

@property (nonatomic, strong) NSString *imgurl;
@property (nonatomic, strong) NSString *note;

+ (instancetype)newsModelWithDict:(NSDictionary *)dict;
@end

