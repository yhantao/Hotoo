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
@property(nonatomic, assign) int start_6;
@property(nonatomic, assign) int start_7;
@property(nonatomic, assign) int start_8;
@property(nonatomic, assign) int start_9;
@property(nonatomic, assign) int start_10;

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
        _start_6 = 0;
        _start_7 = 0;
        _start_8 = 0;
        _start_9 = 0;
        _start_10 = 0;
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
            case HTNewsTypeEconomy:
                self.start_5 = 0;
                break;
            case HTNewsTypeGame:
                self.start_6 = 0;
                break;
            case HTNewsTypeTravel:
                self.start_7 = 0;
                break;
            case HTNewsTypeMovie:
                self.start_8 = 0;
                break;
            case HTNewsTypeFasion:
                self.start_9 = 0;
                break;
            case HTNewsTypeHistory:
                self.start_10 = 0;
                break;
            default:
                break;
        }
    }
    [self loadNewsDataWithBlock:block withIndex:index];
}
- (void)loadNewsDataWithBlock:(newsDataCallBack)block withIndex:(HTNewsType)index{
    dispatch_async(self.queue, ^{
        NSString *baseUrlString;
        NSString *urlString;
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
            case HTNewsTypeEconomy:
                baseUrlString = @"http://c.m.163.com/nc/article/list/T1348648756099/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_5];
                break;
            case HTNewsTypeGame:
                baseUrlString = @"http://c.m.163.com/nc/article/list/T1348654151579/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_6];
                break;
            case HTNewsTypeTravel:
                baseUrlString = @"http://c.m.163.com/nc/article/list/T1348654204705/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_7];
                break;
            case HTNewsTypeMovie:
                baseUrlString = @"http://c.m.163.com/nc/article/list/T1348648650048/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_8];
                break;
            case HTNewsTypeFasion:
                baseUrlString = @"http://c.m.163.com/nc/article/list/T1348650593803/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_9];
                break;
            case HTNewsTypeHistory:
                baseUrlString = @"http://c.m.163.com/nc/article/list/T1368497029546/";
                urlString = [NSString stringWithFormat:@"%@%d-20.html",baseUrlString,self.start_10];
                break;
            default:
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
                                self.start_1 += 20;
                                break;
                            case HTNewsTypeRefined:
                                newsList = [dict objectForKey:@"T1467284926140"];
                                self.start_2 += 20;
                                break;
                            case HTNewsTypeSport:
                                newsList = [dict objectForKey:@"T1348649079062"];
                                self.start_3 += 20;
                                break;
                            case HTNewsTypeEntertainment:
                                newsList = [dict objectForKey:@"T1348648517839"];
                                self.start_4 += 20;
                                break;
                            case HTNewsTypeEconomy:
                                newsList = [dict objectForKey:@"T1348648756099"];
                                self.start_5 += 20;
                                break;
                            case HTNewsTypeGame:
                                newsList = [dict objectForKey:@"T1348654151579"];
                                self.start_6 += 20;
                                break;
                            case HTNewsTypeTravel:
                                newsList = [dict objectForKey:@"T1348654204705"];
                                self.start_7 += 20;
                                break;
                            case HTNewsTypeMovie:
                                newsList = [dict objectForKey:@"T1348648650048"];
                                self.start_8 += 20;
                                break;
                            case HTNewsTypeFasion:
                                newsList = [dict objectForKey:@"T1348650593803"];
                                self.start_9 += 20;
                                break;
                            case HTNewsTypeHistory:
                                newsList = [dict objectForKey:@"T1368497029546"];
                                self.start_10 += 20;
                                break;
                            default:
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

- (void)fetfhPhotosetWithId:(NSString *)photoSetID block:(photoSetCallBack)block{
    dispatch_async(self.queue, ^{
        NSString *param1 = [[photoSetID substringFromIndex:4] componentsSeparatedByString: @"|"][0];
        NSString *param2 = [[photoSetID substringFromIndex:4] componentsSeparatedByString: @"|"][1];
        NSString *baseURL = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json", param1, param2];
        NSURL *url = [[NSURL alloc] initWithString:baseURL];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if(!error){
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                if(dict){
                    NSArray *arr = dict[@"photos"];
                    block(YES, arr);
                }
                block(YES, nil);
            }else{
                block(NO, nil);
            }
        }];
        [task resume];
    });
}

@end
