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
#import "HTColorUtil.h"
#import "HTImageZoomingManager.h"
#import "UIScrollView+MJRefresh.h"

@import MJRefresh;



@interface HTNewsViewController ()

@property (nonatomic, strong) dispatch_queue_t queue1;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSDate *lastRefresh;
@property (nonatomic, weak) UIImageView *loadingView;

@end

@implementation HTNewsViewController{
    NSTimer *_timer;
    NSInteger _loadingcnt;
}

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
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [self.view addSubview:imageView];
    self.loadingView = imageView;
    self.loadingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.loadingView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.loadingView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:10].active = YES;
    [self.loadingView setImage:[UIImage imageNamed:@"preloader-1"]];
    
    // timer for loading animation
    _loadingcnt = 1;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        self->_loadingcnt ++;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadingView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"preloader-%@", @((self->_loadingcnt - 1) % 12 + 1)]]];
            if(self.newsList && self.newsList.count > 0 && self->_loadingcnt >= 20){
                [timer invalidate];
                [self.loadingView setHidden:YES];
                [self.tableView setAlpha:0];
                [self.tableView setHidden:NO];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.tableView setAlpha:1.0];
                }];
            }
        });
    }];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    
    // table view
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

    // MJ Refresh
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(handleMJRefresh:)];
    NSMutableArray *imgTmpArr = [NSMutableArray array];
    for(int i = 1; i <= 12; i++){
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"preloader-%d",i]];
        [imgTmpArr addObject:img];
    }

    NSArray *refreshingImages = [imgTmpArr copy];
    [header setImages:refreshingImages forState:MJRefreshStateRefreshing];
    NSArray *pullingImagesImages = [imgTmpArr copy];
    [header setImages:pullingImagesImages forState:MJRefreshStatePulling];

    header.backgroundColor = [UIColor whiteColor];
    [header setTitle:@"努力加载中..." forState:MJRefreshStateRefreshing];
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [header setTitle:@"努力加载中..." forState:MJRefreshStatePulling];
    [header setTitle:@"努力加载中..." forState:MJRefreshStateWillRefresh];

    [header.lastUpdatedTimeLabel setHidden:YES];
    [header.stateLabel setHidden:YES];
    [header.gifView setHidden:NO];
    tableView.mj_header = header;

    // add refresh control
//    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
//    [refreshControl addTarget:self action:@selector(handleMJRefresh:) forControlEvents:UIControlEventValueChanged];
//    tableView.refreshControl = refreshControl;
//    self.refreshControl = refreshControl;
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setHidden:YES];
    [self.tableView setAlpha:0];
    
}

- (void)handleMJRefresh:(MJRefreshStateHeader *)sender{
    self.isRefreshing = YES;
    dispatch_async(self.queue1, ^{
        [[DataManager sharedInstance] loadNewsDataWithBlock:^(BOOL success, NSArray *lists){
            [self.newsList removeAllObjects];
            [self.newsList addObjectsFromArray:lists];
            self.lastRefresh = [NSDate date];
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(self.newsList && self.newsList.count > 0){
                        [self.tableView reloadData];
                    }
                    [self.tableView.mj_header endRefreshing];
                    self.isRefreshing = NO;
                });
                // [self saveDataToDisk:self.newsList];
            });
        } withIndex:self.index reset:YES];
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.newsList){
        return;
    }
    self.isRefreshing = YES;
    dispatch_async(self.queue1, ^{
        [[DataManager sharedInstance] loadNewsDataWithBlock:^(BOOL success, NSArray *lists){
            self.newsList = [lists mutableCopy];
            self.lastRefresh = [NSDate date];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [UIView animateWithDuration:0.5 animations:^{
                    [self.tableView setAlpha:1.0];
                } completion:^(BOOL finished){
                    self.isRefreshing = NO;
                }];
                // [self saveDataToDisk:self.newsList];
            });
        } withIndex:self.index];
    });
}
- (void) scrollToRefreshTable{
    if (_lastRefresh && ABS([_lastRefresh timeIntervalSinceNow]) <= 600){
        if(self.newsList && self.newsList.count > 0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_header beginRefreshing];
    });
}
- (void) preloadData{
    self.isRefreshing = YES;
    dispatch_async(self.queue1, ^{
        [[DataManager sharedInstance] loadNewsDataWithBlock:^(BOOL success, NSArray *lists){
            self.lastRefresh = [NSDate date];
            [self.newsList addObjectsFromArray:[lists copy]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                // [self saveDataToDisk:self.newsList];
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
//    // 1. head news cell
//    if (entity.imgType &&  [entity.imgType intValue] == 1){
//        HTHeadNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"headNewsCell"];
//        if(!cell){
//            cell = [[HTHeadNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"headNewsCell"];
//        }
//        [cell layoutCellWithModel:self.newsList[indexPath.row]];
//        // preload data when less than 10 cells need to be shown
//        if (!self.isRefreshing && indexPath.row - self.newsList.count == -5){
//            [self preloadData];
//        }
//        return cell;
//    }
    // 1. img news cell
    if (entity.imgextra && entity.imgextra.count == 2){
        HTImagesNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"imgNewsCell"];
        if(!cell){
            cell = [[HTImagesNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"imgNewsCell"];
        }
        [cell layoutCellWithModel:self.newsList[indexPath.row]];
        // preload data when less than 10 cells need to be shown
        if (!self.isRefreshing && indexPath.row - self.newsList.count == -5){
            [self preloadData];
        }
        return cell;
    }
    // 2. normal news cell
    else{
        HTNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"newsCell"];
        if(!cell){
            cell = [[HTNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
        }
        [cell layoutCellWithModel:self.newsList[indexPath.row]];
        // preload data when less than 10 cells need to be shown
        if (!self.isRefreshing && indexPath.row - self.newsList.count == -5){
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
//    // 1. head news cell
//    if (entity.imgType &&  [entity.imgType intValue] == 1){
//        return 270;
//    }
    // 1. images news cell
    if (entity.imgextra && entity.imgextra.count == 2){
        return 165;
    }
    // 3. normal news cell
    else{
        return 110;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HTNewsEntity *model = self.newsList[indexPath.row];
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"_"];
    NSRange range = [model.docid rangeOfCharacterFromSet:cset];
    if (range.location != NSNotFound) {
        return;
    }else{
        HTNewsDetailViewController *detailView = [[HTNewsDetailViewController alloc] initWithURL:model.url withEntity:model];
        [self showViewController:detailView sender:self];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
