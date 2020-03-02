//
//  HTSimilarNewsEntity.m
//  Hotoo
//
//  Created by Hantao Yang on 2/29/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTSimilarNewsEntity.h"

@implementation HTSimilarNewsEntity

-(instancetype) initWithDict:(NSDictionary *)dict{
    self = [super init];
    if(self){
        _title = dict[@"title"];
        NSString *ptime = dict[@"ptime"];
        _ptime = [ptime substringWithRange:NSMakeRange(5, 11)];
        _imgsrc = dict[@"imgsrc"];
        _docid = dict[@"docID"];
    }
    return self;
}
@end
