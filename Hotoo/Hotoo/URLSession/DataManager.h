//
//  DataManager.h
//  Hotoo
//
//  Created by Hantao Yang on 2/22/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, HTNewsType) {
    HTNewsTypeGeneral = 0,
    HTNewsTypeRefined = 1,
    HTNewsTypeSport = 2,
    HTNewsTypeEntertainment = 3,
    HTNewsTypeEconomy = 4,
    HTNewsTypeGame = 5,
    HTNewsTypeTravel = 6,
    HTNewsTypeMovie = 7,
    HTNewsTypeFasion = 8,
    HTNewsTypeHistory = 9,
};

typedef void (^newsDataCallBack)(BOOL, NSArray *);
typedef void (^hotwordsCallBack)(BOOL, NSArray *);
typedef void (^searchWordListCallBack)(BOOL, NSArray *);
typedef void (^newsDetailsCallBack)(BOOL, NSDictionary *);
typedef void (^photoSetCallBack)(BOOL, NSArray *);

@interface DataManager : NSObject

+ (instancetype)sharedInstance;
- (void)loadNewsDataWithBlock:(newsDataCallBack)block withIndex:(HTNewsType)index;
- (void)loadNewsDataWithBlock:(newsDataCallBack)block withIndex:(HTNewsType)index reset:(BOOL)isReset;
- (void)loadHotWord:(hotwordsCallBack)block;
- (void)fetchSearchWordList:(NSString *)string block:(searchWordListCallBack)block;
- (void)fetchNewsSDetailsWithDocId:(NSString *)docId block:(newsDetailsCallBack)block;
- (void)fetfhPhotosetWithId:(NSString *)photoSetID block:(photoSetCallBack)block;

@end

