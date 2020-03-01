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

@interface HTNewsDetailViewController () <WKNavigationDelegate>

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // web view
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.frame = CGRectMake(0, 88, self.view.frame.size.width, self.view.frame.size.height - 88);
    
    self.webView.navigationDelegate = self;
    [[self.viewModel.fetchNewsDetailCommand execute:nil] subscribeError:^(NSError *error) {
        // 暂时不做什么操作
    } completed:^{
        [self showInWebView];
    }];
    
    [self.view sizeToFit];
    
    
}

- (void)dealloc
{
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    self.progressView.progress = 0;
//}
//
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
//    self.progressView.progress = self.webView.estimatedProgress;
//}

- (void)showInWebView{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *baseUrl = [NSURL URLWithString:@"file:///Hotoo/"];
        [self.webView loadHTMLString:[self.viewModel getHtmlString] baseURL:baseUrl];
    });
}

@end
