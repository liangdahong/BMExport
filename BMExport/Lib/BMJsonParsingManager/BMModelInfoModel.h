//
//  BMModelManager.h
//  Property
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMPropertyInfo.h"

@interface BMModelInfoModel : NSObject

@property (nonatomic, copy) NSArray <BMPropertyInfo *> *propertyInfoArray;
@property (nonatomic, copy, readonly) NSString *hashKey; ///< 哈希 key

@end
