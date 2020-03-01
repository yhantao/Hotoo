//
//  HTSearchModel.m
//  Hotoo
//
//  Created by Hantao Yang on 2/26/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTSearchModel.h"
#import "DataManager.h"
#import "RACSignal.h"
#import "RACSubscriber.h"

@implementation HTSearchModel

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupCommands];
    }
    return self;
}

- (void) setupCommands{
    __weak typeof(self) welf1 = self;
    _fetchHotWordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            __strong typeof(welf1) sself1 = self;
            [sself1 requestForHotWordSuccessWithBlock:^(BOOL success, NSArray *arr) {
                [subscriber sendNext:arr];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
    
    __weak typeof(self) welf2 = self;
    _fetchSearchTextCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            __strong typeof(welf2)sself2 = self;
            [sself2 requestForSearchResultListArrayWithBlock:^(BOOL success, NSArray *arr) {
                [subscriber sendNext:arr];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

- (void)requestForHotWordSuccessWithBlock:(void(^)(BOOL success, NSArray *arr))block{
    [[DataManager sharedInstance] loadHotWord:^(BOOL success, NSArray *arr) {
        block(success, arr);
    }];
}

- (void)requestForSearchResultListArrayWithBlock:(void(^)(BOOL success, NSArray *arr))block{
    [[DataManager sharedInstance] fetchSearchWordList:self.searchText block:^(BOOL success, NSArray *arr) {
        block(success, arr);
    }];
}

@end
