//
//  DataManager.m
//  Hotoo
//
//  Created by Hantao Yang on 2/22/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "DataManager.h"
#import "HTNewsEntity.h"

@interface DataManager()

@property(nonatomic, strong) dispatch_queue_t queue;
@property(nonatomic, assign) int start_1;
@property(nonatomic, assign) int start_2;
@property(nonatomic, assign) int start_3;
@property(nonatomic, assign) int start_4;
@property(nonatomic, assign) int start_5;

@end

@implementation DataManager

+ (instancetype) sharedInstance{
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}
- (instancetype) init{
    self = [super init];
    if(self){
        _queue = dispatch_queue_create("com.hantao.hotoo.queue1", DISPATCH_QUEUE_SERIAL);
        _start_1 = 0;
        _start_2 = 0;
        _start_3 = 0;
        _start_4 = 0;
        _start_5 = 0;
    }
    return self;
}
- (void)loadNewsDataWithBlock:(newsDataCallBack)block withIndex:(HTNewsType)index reset:(BOOL)isReset{
    if (isReset){
        switch (index) {
            case HTNewsTypeGeneral:
                self.start_1 = 0;
                break;
            case HTNewsTypeRefined:
                self.start_2 = 0;
                break;
            case HTNewsTypeSport:
                self.start_3 = 0;
                break;
            case HTNewsTypeEntertainment:
                self.start_4 = 0;
                break;
            default:
                self.start_5 = 0;
                break;
        }
    }
    [self loadNewsDataWithBlock:block withIndex:index];
}
- (void)loadNewsDataWithBlock:(newsDataCallBack)block withIndex:(HTNewsType)index{
    dispatch_async(self.queue, ^{
        NSString *baseUrlString = @"http://c.m.163.com/nc/article/headline/T1348647853363/";
        NSString *urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_1];
        switch (index) {
            case HTNewsTypeGeneral:
                baseUrlString = @"http://c.m.163.com/nc/article/headline/T1348647853363/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_1];
                break;
            case HTNewsTypeRefined:
                baseUrlString = @"http://c.3g.163.com/nc/article/list/T1467284926140/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_2];
                break;
            case HTNewsTypeSport:
                baseUrlString = @"http://c.3g.163.com/nc/article/list/T1348649079062/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_3];
                break;
            case HTNewsTypeEntertainment:
                baseUrlString = @"http://c.3g.163.com/nc/article/list/T1348648517839/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_4];
                break;
            default:
                baseUrlString = @"http://c.m.163.com/nc/auto/list/5bmz6aG25bGx/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_5];
                break;
        }
        NSURL *url = [[NSURL alloc] initWithString:urlString];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error){
                NSError *parseError;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&parseError];
                NSMutableArray *newsEntityList = [NSMutableArray array];
                if (!parseError){
                    if(dict && dict.count > 0){
                        NSArray *newsList;
                        switch (index) {
                            case HTNewsTypeGeneral:
                                newsList = [dict objectForKey:@"T1348647853363"];
                                self.start_1 += 21;
                                break;
                            case HTNewsTypeRefined:
                                newsList = dict[@"T1467284926140"];
                                self.start_2 += 21;
                                break;
                            case HTNewsTypeSport:
                                newsList = [dict objectForKey:@"T1348649079062"];
                                self.start_3 += 21;
                                break;
                            case HTNewsTypeEntertainment:
                                newsList = [dict objectForKey:@"T1348648517839"];
                                self.start_4 += 21;
                                break;
                            default:
                                newsList = [dict objectForKey:@"list"];
                                self.start_5 += 21;
                                break;
                        }
                        if (newsList && newsList.count > 0){
                            for (NSDictionary *newsDict in newsList){
                                HTNewsEntity *news = [HTNewsEntity newsModelWithDict:[newsDict copy]];
                                [newsEntityList addObject:news];
                            }
                        }
                    }
                }
                block(parseError == nil, newsEntityList);
            }else{
                block(error == nil, nil);
            }
        }];
        [task resume];
    });
}

- (void)loadHotWord:(hotwordsCallBack)block{
    dispatch_async(self.queue, ^{
        NSString *baseUrl = @"http://c.3g.163.com/nc/search/hotWord.html";
        NSURL *url = [[NSURL alloc] initWithString:baseUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error){
                block(NO, nil);
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if(dict && dict[@"RollhotWordList"]){
                    block(YES, dict[@"RollhotWordList"]);
                }else{
                    block(YES, nil);
                }
            }
        }];
        [task resume];
    });
}

- (void)fetchSearchWordList:(NSString *)string block:(searchWordListCallBack)block{
    dispatch_async(self.queue, ^{
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        NSString *encodedString = [data base64EncodedStringWithOptions:0];
        NSString *baseUrl = [NSString stringWithFormat:@"http://c.3g.163.com/search/comp/MA==/20/%@.html",encodedString];
        NSURL *url = [[NSURL alloc] initWithString:baseUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error){
                block(NO, nil);
            }else{
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if(dict && dict[@"doc"] && dict[@"doc"][@"result"]){
                    block(YES, dict[@"doc"][@"result"]);
                }else{
                    block(YES, nil);
                }
            }
        }];
        [task resume];
    });
}

- (void) fetchNewsSDetailsWithDocId:(NSString *)docId block:(newsDetailsCallBack)block{
    dispatch_async(self.queue, ^{
        NSString *baseUrl = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html",docId];
        NSURL *url = [[NSURL alloc] initWithString:baseUrl];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                block(YES, dict);
            }else{
                block(NO, nil);
            }
        }];
        [task resume];
    });
}

@end
