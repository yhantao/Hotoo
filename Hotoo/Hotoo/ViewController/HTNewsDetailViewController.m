//
//  HTNewsDetailViewController.m
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTNewsDetailViewController.h"
#import "HTColorUtil.h"

@interface HTNewsDetailViewController () <WKNavigationDelegate>

@property (nonatomic, weak) UIProgressView *progressView;

@end

@implementation HTNewsDetailViewController


- (instancetype)initWithURL:(NSString *)url{
    self = [super init];
    if(self){
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    // progress bar
    UIProgressView *progressView = [[UIProgressView alloc] init];
    [self.view addSubview:progressView];
    self.progressView = progressView;
    self.progressView.frame = CGRectMake(0, 88, self.view.frame.size.width, 2);
    self.progressView.transform = CGAffineTransformScale(self.progressView.transform, 1, 2);
    
    // web view
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.frame = CGRectMake(0, 90, self.view.frame.size.width, self.view.frame.size.height - 90);
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[[NSURL alloc] initWithString:self.url]];
    [self.webView loadRequest:request];
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.webView.navigationDelegate = self;
    
    [self.view sizeToFit];
    
    
}

- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - Delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView.progress = 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    self.progressView.progress = self.webView.estimatedProgress;
}
@end
