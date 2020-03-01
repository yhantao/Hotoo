//
//  HTNewsEntity.h
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDetailEntity.h"


@interface HTNewsEntity : NSObject <NSCoding, HTDetailEntityDelegate>

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSNumber *replyCount;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *postid;
@property (nonatomic,strong) NSString *imgsrc;
@property (nonatomic,strong) NSString *source;
@property (nonatomic,strong) NSString *ptime;
@property (nonatomic,strong) NSNumber *imgType;
@property (nonatomic,strong) NSNumber *hasHead;
@property (nonatomic,strong) NSArray *imgextra;
@property (nonatomic,strong) NSString *docid;
@property (nonatomic,strong) NSString *boardid;



+ (instancetype)newsModelWithDict:(NSDictionary *)dict;

@end

