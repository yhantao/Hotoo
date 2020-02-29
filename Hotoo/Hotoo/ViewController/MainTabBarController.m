//
//  MainTabBarController.m
//  Hotoo
//
//  Created by Hantao Yang on 2/10/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "MainTabBarController.h"
#import "NewsViewController.h"
#import "HTColorUtil.h"
#import "HTSearchPageControllerViewController.h"

@interface MainTabBarController()<UISearchBarDelegate>

@property (nonatomic, weak) NewsViewController *vc1;
@property (nonatomic, weak) UIViewController *vc2;
@property (nonatomic, weak) UIViewController *vc3;
@property (nonatomic, weak) UIViewController *vc4;

@end


@implementation MainTabBarController

- (instancetype) init{
    self = [super init];
    if (self){
        self.view.backgroundColor = [UIColor orange_ht];
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    self.tabBar.translucent = NO;
    NewsViewController *vc1 = [[NewsViewController alloc] init];
    vc1.view.backgroundColor = [UIColor whiteColor];
    vc1.tabBarItem.title = @"资讯";
    NSDictionary *dict1 = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:9] forKey:NSFontAttributeName];
    [vc1.tabBarItem setTitleTextAttributes:dict1 forState:UIControlStateNormal];
    vc1.tabBarItem.image = [UIImage systemImageNamed:@"doc.text"];
    vc1.tabBarItem.selectedImage = [UIImage systemImageNamed:@"doc.text.fill"];
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = [UIColor whiteColor];
    vc2.tabBarItem.title = @"视频";
    NSDictionary *dict2 = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:9] forKey:NSFontAttributeName];
    [vc2.tabBarItem setTitleTextAttributes:dict2 forState:UIControlStateNormal];
    vc2.tabBarItem.image = [UIImage systemImageNamed:@"video.circle"];
    vc2.tabBarItem.selectedImage = [UIImage systemImageNamed:@"video.circle.fill"];
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = [UIColor whiteColor];
    vc3.tabBarItem.title = @"读书";
    NSDictionary *dict3 = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:9] forKey:NSFontAttributeName];
    [vc3.tabBarItem setTitleTextAttributes:dict3 forState:UIControlStateNormal];
    vc3.tabBarItem.image = [UIImage systemImageNamed:@"book"];
    vc3.tabBarItem.selectedImage = [UIImage systemImageNamed:@"book.fill"];
    
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = [UIColor whiteColor];
    vc4.tabBarItem.title = @"我的";
    NSDictionary *dict4 = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"HelveticaNeue-Light" size:9] forKey:NSFontAttributeName];
    [vc4.tabBarItem setTitleTextAttributes:dict4 forState:UIControlStateNormal];
    vc4.tabBarItem.image = [UIImage systemImageNamed:@"person.circle"];
    vc4.tabBarItem.selectedImage = [UIImage systemImageNamed:@"person.circle.fill"];
    
    [self setViewControllers:@[vc1, vc2, vc3, vc4]];
    
    self.vc1 = vc1;
    self.vc2 = vc2;
    self.vc3 = vc3;
    self.vc4 = vc4;
    
    self.tabBar.tintColor = [UIColor orange_ht];
    self.tabBar.unselectedItemTintColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
    
    // search bar icon
    UIImage *img = [UIImage systemImageNamed:@"magnifyingglass"];
    UIBarButtonItem *searchBarItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(searchBarClicked:)];
    searchBarItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = searchBarItem;
    // bar button item color
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    UISearchBar *searchBar = [[UISearchBar alloc] init];
    [self.view addSubview:searchBar];
    searchBar = searchBar;
    [searchBar setPlaceholder:@"热搜"];// 搜索框的占位符
    [searchBar setBarStyle:UIBarStyleDefault];// 搜索框样式
    [searchBar setTintColor:[UIColor whiteColor]];
    [searchBar setBarTintColor:[UIColor whiteColor]];
    [searchBar setBackgroundImage:[UIImage new]];
    searchBar.barStyle = UIBarStyleDefault;
    self.navigationItem.titleView = searchBar;
    searchBar.delegate = self;
    
    
}

-(void)searchBarClicked:(UIBarButtonItem *)sender{
    HTSearchPageControllerViewController *vc = [HTSearchPageControllerViewController new];
    [self.navigationController showViewController:vc sender:self];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    HTSearchPageControllerViewController *vc = [HTSearchPageControllerViewController new];
    [searchBar resignFirstResponder];
    [self.navigationController showViewController:vc sender:self];
}



@end
