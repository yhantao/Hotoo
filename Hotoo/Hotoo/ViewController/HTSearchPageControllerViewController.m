//
//  HTSearchPageControllerViewController.m
//  Hotoo
//
//  Created by Hantao Yang on 2/26/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTSearchPageControllerViewController.h"
#import "HTSearchModel.h"
#import "RACSignal.h"
#import "RACSubscriber.h"
#import "HTColorUtil.h"
#import "UIControl+RACSignalSupport.h"
#import "NSObject+RACLifting.h"
#import "HTSearchEntity.h"
#import "HTSearchCell.h"

@interface HTSearchPageControllerViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIView *initialView;
@property (nonatomic, weak) UIScrollView *hotwordView;
@property (nonatomic, weak) UIView *beginView;

@property (nonatomic, assign) CGFloat maxRight;
@property (nonatomic, assign) CGFloat maxBottom;
@property (nonatomic, strong) NSArray *hotwordArray;
@property (nonatomic, strong) HTSearchModel *viewModel;
@property (nonatomic, strong) NSArray *searchListArray;

@end

@implementation HTSearchPageControllerViewController

-(instancetype) init{
    self = [super init];
    if(self){
        _viewModel = [[HTSearchModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    // search bar
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    [self.searchBar setPlaceholder:@""];// 搜索框的占位符
    [self.searchBar setBarStyle:UIBarStyleDefault];// 搜索框样式
    [self.searchBar setTintColor:[UIColor grayColor]];
    [self.searchBar setBarTintColor:[UIColor whiteColor]];
    [self.searchBar setBackgroundImage:[UIImage new]];
    self.navigationItem.titleView = self.searchBar;
    
    self.searchBar.delegate = self;
    
    // begin view
    UIView *beginView = [[UIView alloc] init];
    [self.view addSubview:beginView];
    self.beginView = beginView;
    self.beginView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.beginView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [self.beginView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [self.beginView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
    [self.beginView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    
    //加手势
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.beginView addGestureRecognizer:gestureRecognizer];
    
    //  hot search label
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"近期热点 - 每30分钟刷新"];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:16]];
    [label sizeToFit];
    [self.beginView addSubview:label];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [label.leadingAnchor constraintEqualToAnchor:self.beginView.leadingAnchor constant:10].active = YES;
    [label.topAnchor constraintEqualToAnchor:self.beginView.topAnchor constant:20].active = YES;
    
    // separator
    UIView *separator = [[UIView alloc] init];
    separator.translatesAutoresizingMaskIntoConstraints = NO;
    [self.beginView addSubview:separator];
    [separator.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:15].active = YES;
    [separator.heightAnchor constraintEqualToConstant:0.5].active = YES;
    [separator.leadingAnchor constraintEqualToAnchor:self.beginView.leadingAnchor constant:10].active = YES;
    [separator.trailingAnchor constraintEqualToAnchor:self.beginView.trailingAnchor constant:-10].active = YES;
    separator.backgroundColor = [UIColor lightGrayColor];
    
    
    // hot search scroll
    UIScrollView *hotSearchView = [[UIScrollView alloc] init];
    [self.beginView addSubview:hotSearchView];
    self.hotwordView = hotSearchView;
    self.hotwordView.contentSize = self.hotwordView.bounds.size;
    self.hotwordView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.hotwordView.leadingAnchor constraintEqualToAnchor:self.beginView.leadingAnchor constant:10].active = YES;
    [self.hotwordView.trailingAnchor constraintEqualToAnchor:self.beginView.trailingAnchor constant:-10].active = YES;
    [self.hotwordView.topAnchor constraintEqualToAnchor:separator.bottomAnchor constant:20].active = YES;
    [self.hotwordView.bottomAnchor constraintEqualToAnchor:self.beginView.bottomAnchor constant:-5].active = YES;
    self.hotwordView.backgroundColor = [UIColor whiteColor];
    [self fetchRecentHotWord];
    
    // table view
    UITableView *tableView = [[UITableView alloc] init];
    tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:0].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:0].active = YES;
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:100].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0].active = YES;
    self.tableView.hidden = YES;
    
    [self.searchBar becomeFirstResponder];

}

- (void)fetchRecentHotWord{
    __weak typeof(self) welf = self;
    [[self.viewModel.fetchHotWordCommand execute:nil] subscribeNext:^(NSArray *x) {
        __weak typeof(welf) sself = self;
        sself.hotwordArray = x;
        [sself addHotWordInHotWordView];
    } error:^(NSError *error) {
        // 错误暂时先不管了
    }];
}

- (void)addHotWordInHotWordView
{
    for (NSDictionary *dict in self.hotwordArray) {
        [self addKeyWordBtnWithTitle:dict[@"hotWord"]];
    }
}

- (void)addKeyWordBtnWithTitle:(NSString *)title
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.maxRight, self.maxBottom, 0, 0)];
        [button setTitle:[NSString stringWithFormat:@"  %@  ",title] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
        
        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.cornerRadius = 2;
        button.layer.masksToBounds = YES;
        [button sizeToFit];
        
        RACSignal *btnSignal = [[button rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(UIButton *btn) {
            return btn.currentTitle;
        }];
        [self rac_liftSelector:@selector(buttonClick:) withSignalsFromArray:@[btnSignal]];
        
        [self.hotwordView addSubview:button];
        
        self.maxRight = button.frame.size.width + button.frame.origin.x + 10;

        if (self.maxRight > self.hotwordView.frame.size.width) {
            self.maxRight = 0;
            self.maxBottom += 48;
            button.frame = CGRectMake(self.maxRight, self.maxBottom, button.frame.size.width, button.frame.size.height);
            self.maxRight = button.frame.size.width + button.frame.origin.x + 10;
        }
    });
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.viewModel.searchText = searchBar.text;
    __weak typeof(self) welf = self;
    [[self.viewModel.fetchSearchTextCommand execute:nil] subscribeNext:^(NSArray *arr){
        __strong typeof(welf)sself = self;
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (NSDictionary *dict in arr){
            HTSearchEntity *entity = [HTSearchEntity new];
            [entity setTitle:dict[@"title"]];
            [entity setPtime:dict[@"ptime"]];
            [tmpArr addObject:entity];
        }
        sself.searchListArray = [tmpArr copy];
        dispatch_async(dispatch_get_main_queue(), ^{
            [sself.tableView reloadData];
            sself.beginView.hidden = YES;
            sself.tableView.hidden = NO;
        });
    }];
    
}

- (void)buttonClick:(NSString *)sender{
    self.searchBar.text = sender;
    self.viewModel.searchText = sender;
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HTSearchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if(!cell){
        cell = [[HTSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
    }
    HTSearchEntity *entity = self.searchListArray[indexPath.row];
    [cell layoutViews:entity.title andTime:entity.ptime];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchListArray.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.tableView.hidden = YES;
    self.beginView.hidden = NO;
}

-(void)tapped:(UITapGestureRecognizer *)sender{
    [self.searchBar resignFirstResponder];
}

@end
