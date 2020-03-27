//
//  HTViewUtil.h
//  Hotoo
//
//  Created by Hantao Yang on 3/16/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HTViewUtil : NSObject

@end


@interface UIView (HT)

- (UIView *)findSubview:(NSString *)name recursive:(BOOL)resursion;

@end
