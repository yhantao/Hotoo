//
//  HTNewsDetailViewController.h
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface HTNewsDetailViewController : UIViewController

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSString *url;

- (instancetype)initWithURL:(NSString *)url;
@end

