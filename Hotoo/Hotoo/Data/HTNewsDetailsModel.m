//
//  HTNewsDetailsModel.m
//  Hotoo
//
//  Created by Hantao Yang on 2/28/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsDetailsModel.h"
#import "RACDisposable.h"
#import "RACSubscriber.h"
#import "RACSignal.h"
#import "DataManager.h"
#import "HTSimilarNewsEntity.h"
#import "HTNewsDetailsImageEntity.h"

@implementation HTNewsDetailsModel

- (instancetype)initWithEntity:(id<HTDetailEntityDelegate>)entity
{
    if (self = [super init]) {
        _entity = entity;
        [self setupRACCommands];
    }
    return self;
}

- (void)setupRACCommands{
    __weak typeof(self) welf1 = self;
    _fetchNewsDetailCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            __weak typeof(welf1) sself1 = self;
            [sself1 requestForNewsDetailSuccess:^(BOOL success, NSDictionary *result) {
                
                self.detailEntity = [HTNewsDetailsEntity detailsEntityWithDict:result[self.entity.docid]];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
    
//    _fetchHotFeedbackCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
//        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//
//            // 嵌套replyModel使用
//            [[self.replyViewModel.fetchHotReplyCommand execute:nil]subscribeNext:^(id x) {
//                self.replyModels = x;
//            } error:^(NSError *error) {
//                [subscriber sendError:error];
//            } completed:^{
//                [subscriber sendCompleted];
//            }];
//
//            return nil;
//        }];
//    }];
}

- (void)requestForNewsDetailSuccess:(void(^)(BOOL success, NSDictionary * dict))block{
    [[DataManager sharedInstance] fetchNewsSDetailsWithDocId:self.entity.docid block:^(BOOL success, NSDictionary *dict) {
        block(success, dict);
    }];
}

// HTML

- (NSString *)getHtmlString
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"HTNewsDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:@"<body style=\"background:#f6f6f6\">"];
    [html appendString:[self getBodyString]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    
    return html;
}

- (NSString *)getBodyString
{
    NSMutableString *body = [NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>",self.detailEntity.title];
    [body appendFormat:@"<div class=\"time\">%@</div>",self.detailEntity.ptime];
    [body appendFormat:@"<div class=\"paragraph\">"];
    if (self.detailEntity.body != nil) {
        [body appendString:self.detailEntity.body];
    }
    [body appendFormat:@"</div>"];
    for (HTNewsDetailsImageEntity *detailImgModel in self.detailEntity.img) {
        NSMutableString *imgHtml = [NSMutableString string];
        // 设置img的div
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [detailImgModel.pixel componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject] floatValue];
        CGFloat height = [[pixel lastObject] floatValue];

        CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width * 2.11;
        height = (maxWidth / width) * height;
        width = maxWidth;
        
        [imgHtml appendFormat:@"<img width=\"%f\" height=\"%f\" src=\"%@\">",width,height,detailImgModel.src];
        [imgHtml appendString:@"</div>"];
        [body replaceOccurrencesOfString:detailImgModel.ref withString:imgHtml options:NSCaseInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}
@end
