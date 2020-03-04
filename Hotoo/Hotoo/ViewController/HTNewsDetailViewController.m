//
//  HTNewsDetailViewController.m
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsDetailViewController.h"
#import "HTColorUtil.h"
#import "RACSignal.h"
#import "RACSubscriber.h"
#import "HTColorUtil.h"
#import "UIControl+RACSignalSupport.h"
#import "HTSimilarNewsCell.h"
#import "HTShareCell.h"

@interface HTNewsDetailViewController () <WKNavigationDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation HTNewsDetailViewController


- (instancetype)initWithURL:(NSString *)url withEntity:(id<HTDetailEntityDelegate>)entity{
    self = [super init];
    if(self){
        _url = url;
        _entity = entity;
    }
    return self;
}


- (HTNewsDetailsModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[HTNewsDetailsModel alloc] initWithEntity:self.entity];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    // navigation bar
    // bar button item color
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // table view
    UITableView *tableView = [[UITableView alloc] init];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    self.tableView.frame = CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 88);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
//    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:88].active = YES;
//    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    
    // web view
    WKWebView *webView = [[WKWebView alloc] init];
    self.webView = webView;
    self.webView.navigationDelegate = self;

    [[self.viewModel.fetchNewsDetailCommand execute:nil] subscribeError:^(NSError *error) {
        // 暂时不做什么操作
    } completed:^{
        [self showInWebView];
    }];
}


#pragma mark - Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}


- (void)showInWebView{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *baseUrl = [NSURL URLWithString:@"file:///Hotoo/"];
        [self.webView loadHTMLString:[self.viewModel getHtmlString] baseURL:baseUrl];
    });
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.webView.scrollView sizeToFit];
        self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.webView.scrollView.contentSize.height);
        [self.tableView reloadData];
    });
}

#pragma mark - Table View Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        if(self.webView.frame.size.height == 0){
            return self.view.frame.size.height - 88;
        }
        return self.webView.scrollView.contentSize.height;
    }else if(section == 1){
        return 20;
    }else{
        if(self.viewModel.sameNews.count > 0){
            return 20;
        }else{
            return 0;
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return self.webView;
    }else if(section == 1){
        return [UIView new];
    }else{
        UIView *header = [[UIView alloc] init];
        if(self.viewModel.sameNews.count > 0){
            UILabel *label = [[UILabel alloc] init];
            [label setFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:18]];
            [label setText:@"相关新闻"];
            [header addSubview:label];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [label.centerYAnchor constraintEqualToAnchor:header.centerYAnchor].active = YES;
            [label.leadingAnchor constraintLessThanOrEqualToAnchor:header.leadingAnchor constant:10].active = YES;
        }
        return header;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return [UITableViewCell new];
    }
    if(indexPath.section == 1){
        HTShareCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"sharedCell"];
        if(!cell){
            cell = [[HTShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sharedCell"];
        }
        return cell;
    }else{
        HTSimilarNewsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"simCell"];
        if(!cell){
            cell = [[HTSimilarNewsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"simCell"];
        }
        [cell layoutCellWithModel:self.viewModel.sameNews[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 0;
    }else if(indexPath.section == 1){
        return 120;
    }else{
        return 80;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if(section == 1){
        return 1;
    }else{
        return self.viewModel.sameNews.count;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        NSString *title = [NSString stringWithFormat:@"皮皮给爱生气的姐姐分享一则新闻 -- %@",self.viewModel.detailEntity.title];
        NSURL *url = [NSURL URLWithString:self.url];
        
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems: @[title, url] applicationActivities:nil];
        [self presentViewController:activityViewController animated:YES completion:nil];
    }
    else if(indexPath.section == 1){
        HTSimilarNewsEntity *model = self.viewModel.sameNews[indexPath.row];
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"_"];
        NSRange range = [model.docid rangeOfCharacterFromSet:cset];
        if (range.location != NSNotFound) {
            return;
        }
        HTNewsDetailViewController *detailView = [[HTNewsDetailViewController alloc] initWithURL:nil withEntity:model];
        [self showViewController:detailView sender:self];
    }
}



@end
