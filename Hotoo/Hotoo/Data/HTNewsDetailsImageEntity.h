//
//  HTNewsDetailsImageEntity.h
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTNewsDetailsImageEntity : NSObject

@property (nonatomic, copy) NSString *src;
/** 图片尺寸 */
@property (nonatomic, copy) NSString *pixel;
/** 图片所处的位置 */
@property (nonatomic, copy) NSString *ref;

+ (instancetype)detailImgWithDict:(NSDictionary *)dict;

@end

