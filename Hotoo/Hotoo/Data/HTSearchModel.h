//
//  HTSearchModel.h
//  Hotoo
//
//  Created by Hantao Yang on 2/26/20.
//  Copyright © 2020 Hantao Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RACCommand.h"


@interface HTSearchModel : NSObject

@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) RACCommand *fetchHotWordCommand;
@property (nonatomic, strong) RACCommand *fetchSearchTextCommand;

@end

