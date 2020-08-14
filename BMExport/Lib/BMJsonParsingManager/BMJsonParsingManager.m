//
//  BMJsonParsingManager.m
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMJsonParsingManager.h"

typedef void(^BMJsonParsingOneCompleteBlock)(NSError *error,
                                             BMModelInfoModel *modelInfoModel);

@implementation BMJsonParsingManager

+ (NSError *)propertyStringWithJson:(NSString *)json
           modelInfoModelBlock:(BMJsonParsingCompleteBlock)modelInfoModelBlock {
    
    if (!json.length) {
        return [NSError errorWithDomain:@"JSON 为空" code:-10010101 userInfo:nil];
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return [NSError errorWithDomain:@"未知错误" code:-10010101 userInfo:nil];
    }
    NSError *error = nil;
    NSObject *jsonObj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        return error;
    }
    // 开始解析
    [self propertyStringWithJsonObj:jsonObj modelInfoModelBlock:modelInfoModelBlock];
    return nil;
}

+ (void)propertyStringWithJsonObj:(NSObject *)jsonObj
              modelInfoModelBlock:(BMJsonParsingCompleteBlock)modelInfoModelBlock {
    NSMutableArray <BMModelInfoModel *> *arr = @[].mutableCopy;
    // 去重处理
    NSMutableDictionary <NSString *, NSNumber *>*dict = @{}.mutableCopy;
    [self _propertyStringWithJsonObj:jsonObj modelInfoModelBlock:^(NSError *error, BMModelInfoModel *modelInfoModel) {
        if (modelInfoModel
            && !dict[modelInfoModel.hashKey]) {
            [arr addObject:modelInfoModel];
            dict[modelInfoModel.hashKey] = @YES;
        }
    }];
    modelInfoModelBlock(arr);
}

+ (void)_propertyStringWithJsonObj:(NSObject *)jsonObj
               modelInfoModelBlock:(BMJsonParsingOneCompleteBlock)modelInfoModelBlock {
    if ([jsonObj.className containsString:@"Array"]) {
        // 如果是 Array
        NSArray *arr = (NSArray *)jsonObj;
        if (arr.count) {
            // 取第一个开始解析
            [self _propertyStringWithJsonObj:arr[0]
                         modelInfoModelBlock:modelInfoModelBlock];
        }
    } else if ([jsonObj.className containsString:@"Dictionary"]) {
        // 如果是 Dictionary
        // 开始解析
        [self _propertyStringWithJsonDictionary:(NSDictionary *)jsonObj
                            modelInfoModelBlock:modelInfoModelBlock];
    }
    
}

+ (void)_propertyStringWithJsonDictionary:(NSDictionary *)jsonDictionary
                      modelInfoModelBlock:(BMJsonParsingOneCompleteBlock)modelInfoModelBlock {
    NSMutableArray <BMPropertyInfo *> *propertyInfoArray = @[].mutableCopy;
    [jsonDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 获取 value 的类名称 Array Dictionary Number Boolean String
        BMPropertyInfo *propertyInfo = BMPropertyInfo.new;
        propertyInfo.propertyName = key;
        
        NSString *className = [obj className];
        if ([className containsString:@"Array"]) {
            
            propertyInfo.propertyType = BMPropertyTypeArray;
            // 继续内部的模型
            [self _propertyStringWithJsonObj:obj modelInfoModelBlock:modelInfoModelBlock];
            
        } else if ([className containsString:@"Dictionary"]) {
            propertyInfo.propertyType = BMPropertyTypeDictionary;
            [self _propertyStringWithJsonObj:obj modelInfoModelBlock:modelInfoModelBlock];
            
        } else if ([className containsString:@"Number"]) {
            propertyInfo.propertyType = BMPropertyTypeInt;

        } else if ([className containsString:@"Boolean"]) {
            propertyInfo.propertyType = BMPropertyTypeBoolean;

        } else if ([className containsString:@"String"]) {
            
            // String 里面可以有 bool 类型
            NSString *objStr = (NSString *)obj;
            static NSDictionary *dict = nil;
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                dict =
                @{
                    @"YES"   : @0,
                    @"NO"    : @0,
                    @"FALSE" : @0,
                    @"TRUE"  : @0,
                };
            });
            if (dict[objStr.uppercaseString]) {
                propertyInfo.propertyType = BMPropertyTypeBoolean;
            } else {
                propertyInfo.propertyType = BMPropertyTypeString;
            }
            
        } else {
            propertyInfo.propertyType = BMPropertyTypeObject;
        }
        [propertyInfoArray addObject:propertyInfo];
    }];
    if (propertyInfoArray.count) {
        BMModelInfoModel *obj = BMModelInfoModel.new;
        obj.propertyInfoArray = propertyInfoArray;
        !modelInfoModelBlock ? : modelInfoModelBlock(nil, obj);
    }
}

@end
