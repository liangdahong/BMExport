//
//  BMJsonParsingManager.h
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BMModelInfoModel.h"

typedef void(^BMJsonParsingCompleteBlock)(NSArray <BMModelInfoModel *> *modelInfoModelArray);

/// json 解析工具
@interface BMJsonParsingManager : NSObject

+ (NSError *)propertyStringWithJson:(NSString *)json
                modelInfoModelBlock:(BMJsonParsingCompleteBlock)modelInfoModelBlock;

@end
