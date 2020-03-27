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
#import "HTNewsDetailViewController.h"
#import "HTHotWordCell.h"
#import "HTViewUtil.h"

@interface HTSearchPageControllerViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, HTHotWordCellDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) UIButton *cancelButton;
@property (nonatomic, weak) UIView *initialView;
@property (nonatomic, weak) UITableView *hotwordView;
@property (nonatomic, weak) UIView *beginView;

@property (nonatomic, assign) CGFloat maxRight;
@property (nonatomic, assign) CGFloat maxBottom;
@property (nonatomic, strong) NSArray *hotwordArray;
@property (nonatomic, strong) HTSearchModel *viewModel;
@property (nonatomic, strong) NSArray *searchListArray;

@property (strong, nonatomic) UIPanGestureRecognizer *panToPop;
@property (strong, nonatomic) UIView *targetView;

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
    
    // pan gesture
    NSMutableArray *_targets = [self.navigationController.interactivePopGestureRecognizer valueForKey: @"_targets"];
    id target = [[_targets firstObject] valueForKey: @"_target"];
    SEL handler = NSSelectorFromString(@"handleNavigationTransition:");
    self.targetView = self.navigationController.interactivePopGestureRecognizer.view;
    
    //创建pan手势，作用范围是全屏
    UIPanGestureRecognizer * fullScreenGes = [[UIPanGestureRecognizer alloc]initWithTarget:target action:handler];
    fullScreenGes.delegate = self;
    self.panToPop = fullScreenGes;
    
    [self.targetView addGestureRecognizer: self.panToPop];
    [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    
    // navigation bar
    // bar button item color
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor lightGrayColor];
    
    
    // search bar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 0, 20)];
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    self.searchBar.layer.masksToBounds = YES;
    [self.searchBar setBarStyle:UIBarStyleDefault];// 搜索框样式
    [self.searchBar setBackgroundImage:[UIImage imageWithCIImage:[CIImage imageWithColor:[CIColor colorWithCGColor:[UIColor whiteColor].CGColor]]]];
    UITextField *textField = (UITextField*)[self.searchBar findSubview:@"UITextField" recursive:YES];
    if (textField){
        textField.textColor = [UIColor grayColor];
        textField.tintColor = [UIColor grayColor];
        textField.backgroundColor = [UIColor whiteColor];
        textField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        // iOS13不能KVC设置颜色了，所以不能直接设置 self.searchBar.placeholder, 需要通过下面方式来设置颜色
        NSString *placeHolderText = @"Hotoo热搜 ｜ 猜你喜欢";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:placeHolderText attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}];
        textField.attributedPlaceholder = attributedString;
        textField.layer.cornerRadius = 16;
        textField.layer.borderWidth = 0.3f;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
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
    
//    //  hot search label
//    UILabel *label = [[UILabel alloc] init];
//    [label setText:@"猜你喜欢"];
//    [label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
//    [label sizeToFit];
//    [label setTextColor:[UIColor lightGrayColor]];
//    [self.beginView addSubview:label];
//    label.translatesAutoresizingMaskIntoConstraints = NO;
//    [label.leadingAnchor constraintEqualToAnchor:self.beginView.leadingAnchor constant:10].active = YES;
//    [label.topAnchor constraintEqualToAnchor:self.beginView.topAnchor constant:10].active = YES;
//
//    // separator
//    UIView *separator = [[UIView alloc] init];
//    separator.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.beginView addSubview:separator];
//    [separator.topAnchor constraintEqualToAnchor:label.bottomAnchor constant:10].active = YES;
//    [separator.heightAnchor constraintEqualToConstant:0.4].active = YES;
//    [separator.leadingAnchor constraintEqualToAnchor:self.beginView.leadingAnchor constant:10].active = YES;
//    [separator.trailingAnchor constraintEqualToAnchor:self.beginView.trailingAnchor constant:-10].active = YES;
//    separator.backgroundColor = [UIColor lightGrayColor];
    
    
    // hot search scroll
    UITableView *hotSearchView = [[UITableView alloc] init];
    hotSearchView.tag = 0;
    [self.beginView addSubview:hotSearchView];
    self.hotwordView = hotSearchView;
    self.hotwordView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.hotwordView.leadingAnchor constraintEqualToAnchor:self.beginView.leadingAnchor constant:10].active = YES;
    [self.hotwordView.trailingAnchor constraintEqualToAnchor:self.beginView.trailingAnchor constant:-10].active = YES;
    [self.hotwordView.topAnchor constraintEqualToAnchor:self.beginView.topAnchor constant:0].active = YES;
    [self.hotwordView.bottomAnchor constraintEqualToAnchor:self.beginView.bottomAnchor constant:-5].active = YES;
    self.hotwordView.backgroundColor = [UIColor whiteColor];
    self.hotwordView.delegate = self;
    self.hotwordView.dataSource = self;
     [self.hotwordView setHidden:YES];
    [self fetchRecentHotWord];
    
    // table view
    UITableView *tableView = [[UITableView alloc] init];
    tableView.tag = 1;
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

}

- (void)fetchRecentHotWord{
    __weak typeof(self) welf = self;
    [[self.viewModel.fetchHotWordCommand execute:nil] subscribeNext:^(NSArray *x) {
        __strong typeof(welf) sself = self;
        sself.hotwordArray = x;
        dispatch_async(dispatch_get_main_queue(), ^{
            [sself.hotwordView reloadData];
            [sself.hotwordView setHidden:NO];
        });
        // [sself addHotWordInHotWordView];
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
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(self.maxRight, self.maxBottom, 0, 0)];
        [button setTitle:[NSString stringWithFormat:@"  %@  ",title] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:14];

        button.layer.borderWidth = 0.5;
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.cornerRadius = 6;
        button.layer.masksToBounds = YES;
        [button sizeToFit];

        RACSignal *btnSignal = [[button rac_signalForControlEvents:UIControlEventTouchUpInside] map:^id(UIButton *btn) {
            return btn.currentTitle;
        }];
        [self rac_liftSelector:@selector(buttonClick:) withSignalsFromArray:@[btnSignal]];

        [self.hotwordView addSubview:button];

        self.maxRight = button.frame.size.width + button.frame.origin.x + 10;
        if (button.frame.origin.x == 0 && self.maxRight > self.hotwordView.frame.size.width / 2.0){
            self.maxRight = 0;
            self.maxBottom += 48;
        }
        else if (button.frame.origin.x == 0 && self.maxRight <= self.hotwordView.frame.size.width / 2.0){
            self.maxRight = self.hotwordView.frame.size.width / 2.0;
        }
        else if (button.frame.origin.x == self.hotwordView.frame.size.width / 2.0 && self.maxRight > self.hotwordView.frame.size.width) {
            self.maxRight = 0;
            self.maxBottom += 48;
            button.frame = CGRectMake(self.maxRight, self.maxBottom, button.frame.size.width, button.frame.size.height);
            self.maxRight = button.frame.size.width + button.frame.origin.x + 10;
        }
        else if (button.frame.origin.x == self.hotwordView.frame.size.width / 2.0 && self.maxRight <= self.hotwordView.frame.size.width){
            self.maxRight = 0;
            self.maxBottom += 48;
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
            [entity setDocid:dict[@"docid"]];
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
    // search result
    if(tableView.tag == 1){
        HTSearchCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"searchCell"];
        if(!cell){
            cell = [[HTSearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchCell"];
        }
        HTSearchEntity *entity = self.searchListArray[indexPath.row];
        [cell layoutViews:entity.title andTime:entity.ptime];
        return cell;
    }
    // hot words list
    else{
        HTHotWordCell *cell = (HTHotWordCell *)[self.hotwordView dequeueReusableCellWithIdentifier:@"hotWordCell"];
        if(!cell){
            cell = [[HTHotWordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotWordCell" index:indexPath.row + 1];
        }
        [cell setNumber:indexPath.row + 1];
        [cell setDetail:self.hotwordArray[indexPath.row][@"hotWord"]];
        cell.delegate = self;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // search result
    if(tableView.tag == 1){
        HTSearchEntity *model = self.searchListArray[indexPath.row];
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"_"];
        NSRange range = [model.docid rangeOfCharacterFromSet:cset];
        if (range.location != NSNotFound) {
            return;
        }
        HTNewsDetailViewController *detailView = [[HTNewsDetailViewController alloc] initWithURL:nil withEntity:model];
        [self showViewController:detailView sender:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag == 1){
        return self.searchListArray.count;
    }
    else{
        return self.hotwordArray.count;
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.tableView.hidden = YES;
    self.beginView.hidden = NO;
    if(self.searchBar.text.length > 0){
        return;
    }
    [self.searchBar resignFirstResponder];
}

-(void)tapped:(UITapGestureRecognizer *)sender{
    [self.searchBar resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)clicked:(NSInteger)index{
    NSString *sender = self.hotwordArray[index][@"hotWord"];
    self.searchBar.text = sender;
    self.viewModel.searchText = sender;
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
      //防止导航控制器只有一个rootViewcontroller时触发手势
    return self.navigationController.childViewControllers.count == 1 ? NO : YES;
}

@end
