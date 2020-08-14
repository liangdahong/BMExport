//
//  BMOCModelTool.h
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BMOCModelCompleteBlock)(NSString *ocModelCodeString);

@interface BMOCModelTool : NSObject

+ (NSError *)propertyStringWithJson:(NSString *)json
                          modelName:(NSString *)modelName
                              block:(BMOCModelCompleteBlock)block
                                add:(BOOL)add
                          alignment:(BOOL)alignment;

@end
