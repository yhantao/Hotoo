//
//  HTNewsDetailViewController.h
//  Hotoo
//
//  Created by Hantao Yang on 2/23/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "HTNewsDetailsModel.h"
#import "HTNewsEntity.h"
#import "HTDetailEntity.h"

@interface HTNewsDetailViewController : UIViewController

@property (nonatomic, weak) WKWebView *webView;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) id<HTDetailEntityDelegate> entity;
@property (nonatomic, strong) HTNewsDetailsModel *viewModel;

- (instancetype)initWithURL:(NSString *)url withEntity:(id<HTDetailEntityDelegate>)entity;

@end

