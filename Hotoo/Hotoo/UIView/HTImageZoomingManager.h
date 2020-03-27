//
//  HTImageZoomingManager.h
//  Hotoo
//
//  Created by Hantao Yang on 3/12/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "RACCommand.h"


@interface HTImageZoomingManager : NSObject

@property (nonatomic, strong) RACCommand *fetchPhotoSetCommand;
@property (nonatomic, strong) NSString *photoSetID;
@property (nonatomic, assign) CGRect initFrame;

- (instancetype) initWithPhotoSetID: (NSString *)photoSetId;
- (void)imageTapped:(UITapGestureRecognizer *)sender;
- (void)execute;
- (void)viewTapped:(UITapGestureRecognizer *)sender;

@end
