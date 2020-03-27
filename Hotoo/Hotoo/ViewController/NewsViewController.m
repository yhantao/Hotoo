//
//  NewsViewController.m
//  Hotoo
//
//  Created by Hantao Yang on 2/22/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "NewsViewController.h"
#import "HTNewsViewController.h"
#import "DataManager.h"
#import "HTColorUtil.h"

@interface NewsViewController ()

@property (nonatomic, strong) NSArray *lblTexts;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) HTNewsViewController *currentNewsController;
@property (nonatomic, strong) NSMutableDictionary *map;
@property (nonatomic, weak) UIScrollView *scrollBar;
@property (nonatomic, weak) UIView *segment;

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // init vc map
    self.map = [NSMutableDictionary dictionary];
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
    [stackView setDistribution:UIStackViewDistributionFillProportionally];
    [stackView setAxis:UILayoutConstraintAxisHorizontal];
    
    // add text label in stack view
    for (int i = 0; i < 5; i++){
        CGFloat width = self.view.frame.size.width / 5;
        CGFloat offsetX = i * width;
        HTBarLabel *lbl = [[HTBarLabel alloc] initWithFrame:CGRectMake(offsetX, 0, width, 30)];
        [lbl setText:self.lblTexts[i][@"title"]];
        if (i == 0){
            lbl.scale = 1.0;
        }
        lbl.tag = i;
        lbl.delegate = self;
        [lbl setUserInteractionEnabled:YES];
        [lbl addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(lblClicked:)]];
        [stackView addArrangedSubview:lbl];
        lbl.translatesAutoresizingMaskIntoConstraints = NO;
        [lbl.centerYAnchor constraintEqualToAnchor:stackView.centerYAnchor].active = YES;
    }
    [self.view addSubview:stackView];
    self.stv = stackView;
    self.stv.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    
    // scroll bar
    UIScrollView *scrollBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, 2)];
    [self.view addSubview:scrollBar];
    self.scrollBar = scrollBar;
    self.scrollBar.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1];
    UIView *segment = [[UIView alloc] initWithFrame:CGRectMake(10, 0, [UIScreen mainScreen].bounds.size.width / 5 - 20, 2)];
    segment.backgroundColor = [UIColor orange_ht];
    segment.layer.cornerRadius = 0.5f;
    [self.scrollBar addSubview:segment];
    self.segment = segment;
    
    // add scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 142, self.view.frame.size.width, self.view.frame.size.height - 142)];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 5, scrollView.frame.size.height);
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scv = scrollView;
    [self addNewsControllerIfNotPresent:0];
}

- (HTNewsViewController *)addNewsControllerIfNotPresent:(NSInteger)index{
    if (!self.map[@(index)]){
        CGFloat width = self.view.frame.size.width;
        CGFloat offsetX = index * width;
        
        HTNewsViewController *vc = [[HTNewsViewController alloc] initWithIndex:(HTNewsType)index];
        [self.scv addSubview:vc.view];
        vc.view.frame = CGRectMake(offsetX, 0, width, self.scv.frame.size.height);
        [self addChildViewController:vc];
        self.currentNewsController = vc;
        self.map[@(index)] = vc;
        return vc;
    }
    else{
        return self.map[@(index)];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.currentNewsController && self.currentNewsController.newsList){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.currentNewsController.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

- (NSArray *)lblTexts{
    if (!_lblTexts){
        _lblTexts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURLs" ofType:@"plist"]];
    }
    return _lblTexts;
}

#pragma mark - Target / Action

- (void)lblClicked:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.6 animations:^{
        HTBarLabel *currentLbl = (HTBarLabel *)sender.view;
        for (HTBarLabel *lbl in self.stv.arrangedSubviews){
            lbl.scale = 0.0;
        }
        currentLbl.scale = 1.0;
        self.index = currentLbl.tag;
        CGRect frame = self.segment.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width / 5 * self.index + 10;
        self.segment.frame = frame;
        self.scv.contentOffset = CGPointMake(currentLbl.tag * [UIScreen mainScreen].bounds.size.width, 0);
        self.currentNewsController.isRefreshing = NO;
        HTNewsViewController *newsController = [self addNewsControllerIfNotPresent:self.index];
        self.currentNewsController = newsController;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(!newsController.isRefreshing){
                [newsController scrollToRefreshTable];
            }
        });
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger currentIndex = offsetX / [UIScreen mainScreen].bounds.size.width;
    if (currentIndex == self.index){
        return;
    }
    self.index = currentIndex;
    [UIView animateWithDuration:0.6 animations:^{
        for (HTBarLabel *lbl in self.stv.arrangedSubviews){
            lbl.scale = 0.0;
        }
        HTBarLabel *newLbl = (HTBarLabel *)self.stv.arrangedSubviews[self.index];
        newLbl.scale = 1.0;
        CGRect frame = self.segment.frame;
        frame.origin.x = [UIScreen mainScreen].bounds.size.width / 5 * self.index + 10;
        self.segment.frame = frame;
    }];
    self.currentNewsController.isRefreshing = NO;
    HTNewsViewController *newsController = [self addNewsControllerIfNotPresent:self.index];
    self.currentNewsController = newsController;
    if(!newsController.isRefreshing){
         [newsController scrollToRefreshTable];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGRect frame = self.segment.frame;
    frame.origin.x = scrollView.contentOffset.x / 5 + 10;
    self.segment.frame = frame;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
