//
//  HTNewsViewController.m
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsViewController.h"
#import "HTNewsEntity.h"
#import "HTNewsCell.h"
#import "DataManager.h"
#import "HTNewsDetailViewController.h"
#import "HTHeadNewsCell.h"
#import "HTImagesNewsCell.h"
#import "MJRefresh.h"
#import "HTColorUtil.h"



@interface HTNewsViewController ()

@property (nonatomic, strong) NSMutableArray *newsList;
@property (nonatomic, strong) dispatch_queue_t queue1;
@property (nonatomic, assign) BOOL isRefreshing;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation HTNewsViewController

- (instancetype)initWithIndex:(HTNewsType)index{
    self = [super init];
    if(self){
        _queue1 = dispatch_queue_create("com.hantao.hotoo.queue1", DISPATCH_QUEUE_SERIAL);
        _index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
//    UITabBarController *tabBarVC = [[UITabBarController alloc] init];
//    CGFloat tabBarHeight = tabBarVC.tabBar.frame.size.height;
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    // MJ Refresh
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleMJRefresh:)];

    
//    NSArray *pullingImages = @[@"dog1", @"dog2", @"dog3"];
//    [header setImages:pullingImages forState:MJRefreshStatePulling];
    UIImage *img1 = [UIImage imageNamed:@"dogwalk1"];
    UIImage *img2 = [UIImage imageNamed:@"dogwalk2"];
    UIImage *img3 = [UIImage imageNamed:@"dogwalk3"];
    NSArray *refreshingImages = @[img1, img2, img3];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    NSArray *pullingImagesImages = @[img1, img2, img3];
    [header setImages:pullingImagesImages forState:MJRefreshStatePulling];

    [header.lastUpdatedTimeLabel setHidden:YES];
    [header.stateLabel setHidden:YES];

    header.backgroundColor = [UIColor whiteColor];
    [header setTitle:@"正在很努力加载中" forState:MJRefreshStateRefreshing];
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [header setTitle:@"正在很努力加载中" forState:MJRefreshStatePulling];
    [header setTitle:@"正在很努力加载中" forState:MJRefreshStateWillRefresh];
    tableView.mj_header = header;

    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setHidden:YES];
    
    // UI Refresh
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
//    tableView.refreshControl = refreshControl;
//    self.refreshControl = refreshControl;
}

- (void)handleMJRefresh:(MJRefreshGifHeader *)sender{
    dispatch_async(self.queue1, ^{
        [[DataManager sharedInstance] loadNewsDataWithBlock:^(BOOL success, NSArray *lists){
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:lists];
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                });
                [self saveDataToDisk:self.newsList];
            });
        } withIndex:self.index reset:YES];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.newsList){
        return;
    }
    dispatch_async(self.queue1, ^{
        [[DataManager sharedInstance] loadNewsDataWithBlock:^(BOOL success, NSArray *lists){
            self.newsList = [lists mutableCopy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                 [self.tableView setHidden:NO];
                [self saveDataToDisk:self.newsList];
            });
        } withIndex:self.index];
    });
}

- (void) preloadData{
    self.isRefreshing = YES;
    dispatch_async(self.queue1, ^{
        [[DataManager sharedInstance] loadNewsDataWithBlock:^(BOOL success, NSArray *lists){
            [self.newsList addObjectsFromArray:[lists copy]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self saveDataToDisk:self.newsList];
                self.isRefreshing = NO;
            });
        } withIndex:self.index];
    });
    
}

#pragma mark - Data serialization

- (void)saveDataToDisk:(NSArray<HTNewsEntity *>*)array{
    dispatch_async(self.queue1, ^{
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dirPath = [rootPath stringByAppendingPathComponent:@"HTNewsList"];
        [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *filePath = [dirPath stringByAppendingPathComponent:@"OldList"];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array requiringSecureCoding:YES error:nil];
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    });
    
}
- (NSArray<HTNewsEntity *>*)loadDataFromDisk{
    __block NSMutableArray *tmpArr = [NSMutableArray array];
    dispatch_sync(self.queue1, ^{
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dirPath = [rootPath stringByAppendingPathComponent:@"HTNewsList"];
        NSString *filePath = [dirPath stringByAppendingPathComponent:@"OldList"];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:filePath];
        if (data){
            NSArray<HTNewsEntity *>*list = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithObjects:[NSArray class], [HTNewsEntity class], nil] fromData:data error:nil];
            [tmpArr addObjectsFromArray:list];
        }
    });
    return [tmpArr copy];
}
#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewsEntity *entity = self.newsList[indexPath.row];
    // 1. head news cell
    if (entity.imgType &&  [entity.imgType intValue] == 1){
        HTHeadNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"headNewsCell"];
        if(!cell){
            cell = [[HTHeadNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headNewsCell"];
        }
        [cell layoutCellWithModel:self.newsList[indexPath.row]];
        // preload data when less than 10 cells need to be shown
        if (!self.isRefreshing && indexPath.row - self.newsList.count >= -5){
            [self preloadData];
        }
        return cell;
    }
    // 2. head news cell
    else if (entity.imgextra && entity.imgextra.count == 2){
        HTImagesNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"imgNewsCell"];
        if(!cell){
            cell = [[HTImagesNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imgNewsCell"];
        }
        [cell layoutCellWithModel:self.newsList[indexPath.row]];
        // preload data when less than 10 cells need to be shown
        if (!self.isRefreshing && indexPath.row - self.newsList.count >= -5){
            [self preloadData];
        }
        return cell;
    }
    // 3. normal news cell
    else{
        HTNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"newsCell"];
        if(!cell){
            cell = [[HTNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
        }
        [cell layoutCellWithModel:self.newsList[indexPath.row]];
        // preload data when less than 10 cells need to be shown
        if (!self.isRefreshing && indexPath.row - self.newsList.count >= -5){
            [self preloadData];
        }
        return cell;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.newsList.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewsEntity *entity = self.newsList[indexPath.row];
    // 1. head news cell
    if (entity.imgType &&  [entity.imgType intValue] == 1){
        return 270;
    }
    // 2. images news cell
    else if (entity.imgextra && entity.imgextra.count == 2){
        return 160;
    }
    // 3. normal news cell
    else{
        return 80;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewsEntity *model = self.newsList[indexPath.row];
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    NSRange range = [model.docid rangeOfCharacterFromSet:cset];
    if (range.location != NSNotFound) {
        return;
    }
    HTNewsDetailViewController *detailView = [[HTNewsDetailViewController alloc] initWithURL:model.url withEntity:model];
    [self showViewController:detailView sender:self];
}

@end
