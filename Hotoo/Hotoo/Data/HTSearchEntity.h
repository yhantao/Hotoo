//
//  HTSearchEntity.h
//  Hotoo
//
//  Created by Hantao Yang on 2/27/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HTSearchEntity : NSObject

@property(nonatomic,copy)NSString *docid;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *skipID;
@property(nonatomic,copy)NSString *dkeys;
@property(nonatomic,copy)NSString *skipType;
@property(nonatomic,copy)NSString *ptime;

@end

