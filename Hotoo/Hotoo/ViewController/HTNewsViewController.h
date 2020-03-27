//
//  HTNewsViewController.h
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"


@interface HTNewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, assign) HTNewsType index;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, strong) NSMutableArray *newsList;

- (instancetype) initWithIndex:(HTNewsType)index;
- (void)scrollToRefreshTable;

@end

