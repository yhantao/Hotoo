//
//  HTSimilarNewsEntity.h
//  Hotoo
//
//  Created by Hantao Yang on 2/29/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTDetailEntity.h"

@interface HTSimilarNewsEntity : NSObject <HTDetailEntityDelegate>

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)NSString *source;

@property(nonatomic,copy)NSString *imgsrc;

@property(nonatomic,copy)NSString *ptime;

@property(nonatomic,strong)NSString *docid;

-(instancetype) initWithDict:(NSDictionary *)dict;

@end

