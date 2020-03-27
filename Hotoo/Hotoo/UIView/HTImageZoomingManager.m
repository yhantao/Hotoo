//
//  HTImageZoomingManager.m
//  Hotoo
//
//  Created by Hantao Yang on 3/12/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import "HTImageZoomingManager.h"
#import "HTImagesNewsCell.h"
#import "DataManager.h"
#import "RACSignal.h"
#import "RACSubscriber.h"
#import "HTImageEnlargeEntity.h"
#import "SDWebImage.h"

HTImageZoomingManager *instance;

@interface HTImageZoomingManager()

@property (nonatomic, strong) NSMutableArray *photoSet;
@property (nonatomic, strong) UIScrollView *scrollView;
@end


@implementation HTImageZoomingManager

- (instancetype) initWithPhotoSetID: (NSString *)photoSetId{
    self = [super init];
    if(self){
        _photoSetID = photoSetId;
        [self setupFetchCommand];
    }
    return self;
}

- (void)setupFetchCommand{
    __weak typeof(self) welf1 = self;
    _fetchPhotoSetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            __strong typeof(welf1) sself1 = self;
            [sself1 requestForHotWordSuccessWithBlock:^(BOOL success, NSArray *arr) {
                [subscriber sendNext:arr];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
    }];
}

- (void)requestForHotWordSuccessWithBlock:(void(^)(BOOL success, NSArray *arr))block{
    [[DataManager sharedInstance] fetfhPhotosetWithId:self.photoSetID block:^(BOOL success, NSArray *arr) {
        block(success, arr);
    }];
}

- (void) imageTapped:(UITapGestureRecognizer *)sender{
    UIImageView *imgView = (UIImageView *)sender.view;
    UIWindow *myWindow = [UIApplication sharedApplication].windows[0];
    CGRect fromRect = [imgView.superview convertRect:imgView.frame toView:myWindow];
    self.initFrame = fromRect;
    UIImageView *zoomView = [[UIImageView alloc] initWithFrame:fromRect];
    UIView *backgroundView = [[UIView alloc] initWithFrame:myWindow.frame];
    backgroundView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [backgroundView addGestureRecognizer:gesture];
    [backgroundView addSubview:zoomView];
    zoomView.contentMode = UIViewContentModeScaleAspectFit;
    zoomView.image = imgView.image;
    [myWindow addSubview:backgroundView];
    [UIView animateWithDuration:0.3 animations:^{
        zoomView.frame = myWindow.frame;
    }];
}

- (void)viewTapped:(UITapGestureRecognizer *)sender{
    __weak typeof(self) welf = self;
    [[self.fetchPhotoSetCommand execute:nil] subscribeNext:^(NSArray *x) {
        __strong typeof(welf) sself = self;
        sself.photoSet = [NSMutableArray array];
        for (NSDictionary *dict in x){
            HTImageEnlargeEntity *entity = [HTImageEnlargeEntity newsModelWithDict:dict];
            [sself.photoSet addObject:entity];
        }
        [sself showScrollView:sender];
    } error:^(NSError * _Nullable error) {
        // 暂时先不管error了
    }];
}
     
- (void)showScrollView:(UITapGestureRecognizer *)sender{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imgView = (UIImageView *)sender.view;
        UIWindow *myWindow = [UIApplication sharedApplication].windows[0];
        CGRect fromRect = [imgView.superview convertRect:imgView.frame toView:myWindow];
        self.initFrame = fromRect;
        UIView *backgroundView = [[UIView alloc] initWithFrame:myWindow.frame];
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.initFrame];
        self.scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.photoSet.count, [UIScreen mainScreen].bounds.size.height);
        self.scrollView.backgroundColor = [UIColor blackColor];
        self.scrollView.alpha = 0;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.pagingEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(returnTapped:)];
        [self.scrollView addGestureRecognizer:gesture];
        [backgroundView addSubview:self.scrollView];
        [myWindow addSubview:backgroundView];

        [UIView animateWithDuration:0.5 animations:^{
            self.scrollView.frame = myWindow.frame;
            self.scrollView.alpha = 1.0;
            // add img to image view
            for (int i = 0; i < self.photoSet.count; i++){
                HTImageEnlargeEntity *model = [self.photoSet objectAtIndex:i];
                CGFloat width = self.scrollView.frame.size.width;
                CGFloat height = self.scrollView.frame.size.height - 300;
                
                // add imageView
                UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i * width + 10, 150, width - 20, height)];
                imgView.contentMode = UIViewContentModeScaleAspectFit;
                [imgView sd_setImageWithURL:[NSURL URLWithString:model.imgurl] placeholderImage:[UIImage imageNamed:@"placeholder-img"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    NSLog(@"");
                }];
                [self.scrollView addSubview:imgView];
                
                // add note label
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 10, self.scrollView.frame.size.height - 140, width - 20, 140)];
                [label setNumberOfLines:7];
                [label setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:14]];
                [label setTextColor:[UIColor whiteColor]];
                [label setText:[NSString stringWithFormat:@"%@", model.note]];
                [self.scrollView addSubview:label];
                [label sizeToFit];
                
                // add page label
                UILabel *pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(i * width + 10, 100, 50, 50)];
                [pageLabel setNumberOfLines:1];
                [pageLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:16]];
                [pageLabel setTextColor:[UIColor whiteColor]];
                [pageLabel setTextAlignment:NSTextAlignmentRight];
                [pageLabel setText:[NSString stringWithFormat:@"%@/%@", @(i+1), @(self.photoSet.count)]];
                [self.scrollView addSubview:pageLabel];
                [pageLabel sizeToFit];

                
            }
        } completion:^(BOOL finished) {
            
        }];
    });
}

- (void)returnTapped:(UITapGestureRecognizer *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.scrollView.frame = self.initFrame;
        self.scrollView.alpha = 0;
    } completion:^(BOOL finished) {
        [sender.view.superview removeFromSuperview];
    }];
    
}
@end
