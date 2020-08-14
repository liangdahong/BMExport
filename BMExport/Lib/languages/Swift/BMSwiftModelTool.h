//
//  BMSwiftModelTool.h
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SwiftModelType) {
    SwiftModelTypeClass,
    SwiftModelTypeStruct,
};

typedef void(^BMSwiftModelCompleteBlock)(NSString *ocModelCodeString);

@interface BMSwiftModelTool : NSObject

+ (NSError *)propertyStringWithJson:(NSString *)json
                          modelName:(NSString *)modelName
                              block:(BMSwiftModelCompleteBlock)block
                     swiftModelType:(SwiftModelType)type
                                add:(BOOL)add
                          alignment:(BOOL)alignment;

@end
