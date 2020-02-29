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

- (instancetype) initWithIndex:(HTNewsType)index;

@end

