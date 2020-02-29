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

@interface NewsViewController ()

@property (nonatomic, strong) NSArray *lblTexts;
@property (nonatomic, assign) NSInteger index;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIStackView *stackView = [[UIStackView alloc] initWithFrame:CGRectMake(5, 100, self.view.frame.size.width - 10, 40)];
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
    
    // add scroll view
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 140, self.view.frame.size.width, self.view.frame.size.height - 140)];
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 5, scrollView.frame.size.height);
    for (int i = 4; i >= 0; i--){
        CGFloat width = self.view.frame.size.width;
        CGFloat offsetX = i * width;
        
        HTNewsViewController *vc = [[HTNewsViewController alloc] initWithIndex:(HTNewsType)i];
        [scrollView addSubview:vc.view];
        vc.view.frame = CGRectMake(offsetX, 0, width, scrollView.frame.size.height);
        [self addChildViewController:vc];
    }
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    self.scv = scrollView;
}

- (NSArray *)lblTexts{
    if (!_lblTexts){
        _lblTexts = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsURLs" ofType:@"plist"]];
    }
    return _lblTexts;
}

#pragma mark - Delegate

- (void) changeLabelFrom:(NSInteger)from to:(NSInteger)to{
    
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
        self.scv.contentOffset = CGPointMake(currentLbl.tag * self.view.frame.size.width, 0);
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX == self.index){
        return;
    }
    self.index = offsetX;
    NSInteger index = offsetX / (self.view.frame.size.width);
    [UIView animateWithDuration:0.3 animations:^{
        for (HTBarLabel *lbl in self.stv.arrangedSubviews){
            lbl.scale = 0.0;
        }
        HTBarLabel *newLbl = (HTBarLabel *)self.stv.arrangedSubviews[index];
        newLbl.scale = 1.0;
    }];
}


@end
