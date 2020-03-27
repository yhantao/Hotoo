//
//  HTNewsEntity.m
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsEntity.h"

@implementation HTNewsEntity

+ (instancetype)newsModelWithDict:(NSDictionary *)dict{
    HTNewsEntity *model = [[self alloc] init];

    [model setValue:dict[@"title"] forKey:@"title"];
    [model setValue:dict[@"replyCount"] forKey:@"replyCount"];
    [model setValue:dict[@"url"] forKey:@"url"];
    [model setValue:dict[@"postid"] forKey:@"postid"];
    [model setValue:dict[@"imgsrc"] forKey:@"imgsrc"];
    [model setValue:dict[@"source"] forKey:@"source"];
    [model setValue:dict[@"ptime"] forKey:@"ptime"];
    [model setValue:dict[@"imgType"] forKey:@"imgType"];
    [model setValue:dict[@"hasHead"] forKey:@"hasHead"];
    [model setValue:dict[@"docid"] forKey:@"docid"];
    [model setValue:dict[@"boardid"] forKey:@"boardid"];
    [model setValue:dict[@"photosetID"] forKey:@"photosetID"];
    [model setValue:dict[@"votecount"] forKey:@"votecount"];
    [model setValue:dict[@"priority"] forKey:@"priority"];
    [model setValue:dict[@"quality"] forKey:@"quality"];
    
    // extra imgs
    if (dict[@"imgextra"] && [dict[@"imgextra"] isKindOfClass:[NSArray class]]){
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (NSDictionary *extraImageDict in dict[@"imgextra"]){
            [tmpArray addObject:extraImageDict[@"imgsrc"]];
        }
        model.imgextra = [tmpArray copy];
    }
    
    // reply count parse
    if (!model.replyCount){
        model.replyCount = [NSNumber numberWithInt:0];
    }
    
    // imgType parse
    if (!model.imgType){
        model.imgType = [NSNumber numberWithInt:0];
    }
    
    // ptime
    NSString *ptime = [model.ptime substringWithRange:NSMakeRange(5, 11)];
    model.ptime = ptime;
    
    
    // source
    NSString *trimmedSource = [model.source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    model.source = trimmedSource;
    
    return model;
}


- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeObject:self.replyCount forKey:@"replyCount"];
    [coder encodeObject:self.url forKey:@"url"];
    [coder encodeObject:self.postid forKey:@"postid"];
    [coder encodeObject:self.imgsrc forKey:@"imgsrc"];
    [coder encodeObject:self.source forKey:@"source"];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    if (self){
        self.title = [coder decodeObjectForKey:@"title"];
        self.replyCount = [coder decodeObjectForKey:@"replyCount"];
        self.url = [coder decodeObjectForKey:@"url"];
        self.postid = [coder decodeObjectForKey:@"postid"];
        self.imgsrc = [coder decodeObjectForKey:@"imgsrc"];
        self.source = [coder decodeObjectForKey:@"source"];
    }
    return self;
}

@end
