//
//  BMModelManager.m
//  Property
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "BMModelManager.h"

@implementation BMModelManager

+ (void)propertyStringWithDict:(NSDictionary *)dict
                     modelName:(NSString *)modelName
                         block:(BMModelManagerBlock)block
                           add:(BOOL)add
                     alignment:(BOOL)alignment {
    NSMutableArray *arr = @[].mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 获取 value 的类名称 Array Dictionary Number Boolean String
        NSString *className = [obj className];
        
        // 定义类型 typeName  【NSArray <<#type#> *> * ， BOOL 】
        NSString *typeName = nil;
        
        // 定义修饰词 type2 strong assign copy 等
        NSString *type2 = nil;
        if ([className containsString:@"Array"]) {
            typeName = @"NSArray <<#type#> *> *";
            type2 = @"strong";
            [self propertyStringWithObj:obj modelName:modelName block:block add:add alignment:alignment];
        } else if ([className containsString:@"Dictionary"]) {
            typeName = @"<#type#> *";
            type2 = @"strong";
            [self propertyStringWithDict:obj modelName:modelName block:block add:add alignment:alignment];
        } else if ([className containsString:@"Number"]) {
            typeName = @"NSInteger ";
            type2 = @"assign";
        } else if ([className containsString:@"Boolean"]) {
            typeName = @"BOOL ";
            type2 = @"assign";
        } else if ([className containsString:@"String"]) {
            
            // String 里面可以有 bool 类型
            if ([obj isEqualToString:@"YES"]
                || [obj isEqualToString:@"yes"]
                || [obj isEqualToString:@"NO"]
                || [obj isEqualToString:@"no"]
                || [obj isEqualToString:@"FALSE"]
                || [obj isEqualToString:@"TRUE"]
                || [obj isEqualToString:@"false"]
                || [obj isEqualToString:@"true"]) {
                typeName = @"BOOL ";
                type2 = @"assign";
            } else {
                // 确定为 字符串类型
                typeName = @"NSString *";
                type2 = @"copy";
            }
            
        } else {
            // 其他类型默认使用 NSObject
            typeName = @"NSObject *";
            type2 = @"strong";
        }
        
        // 使用 Array 缓存起来【 @property (nonatomic, %@) %@%@; 】
        [arr addObject:[NSString stringWithFormat:@"@property (nonatomic, %@) %@%@;", type2, typeName, key]];
    }];

    if (!arr.count) {
        return;
    }

    if (alignment) {
        // 如果需要对齐
        __block NSInteger len = 0;
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length > len) {
                len = obj.length;
            }
        }];
        
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length < len) {
                NSInteger l = len - obj.length;
                NSMutableString *s = [NSMutableString string];
                [s appendString:obj];
                while (l--) {
                    [s appendString:@" "];
                }
                if (add) {
                    [s appendString:@" ///< <#属性注释#>"];
                }
                arr[idx] = s;
            } else {
                NSMutableString *s = [NSMutableString string];
                [s appendString:obj];
                if (add) {
                    [s appendString:@" ///< <#属性注释#>"];
                }
                arr[idx] = s;
            }
        }];
    } else {
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableString *s = [NSMutableString string];
            [s appendString:obj];
            if (add) {
                [s appendString:@" ///< <#属性注释#>"];
            }
            arr[idx] = s;
        }];
    }
    
    NSMutableString *modelStr = @"".mutableCopy;
    [modelStr appendFormat:@"@interface %@ : NSObject\n\n", modelName];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [modelStr appendString:obj];
        [modelStr appendString:@" \n"];
    }];
    [modelStr appendString:@"\n@end"];
    !block ? : block(modelStr.copy);
}

+ (void)propertyStringWithObj:(id)obj
                    modelName:(NSString *)modelName
                        block:(BMModelManagerBlock)block
                          add:(BOOL)add
                    alignment:(BOOL)alignment {
    NSString *className = [obj className];
    if ([className containsString:@"Array"]) {
        NSArray *arr = obj;
        if (arr.count) {
            [self propertyStringWithObj:arr[0]
                              modelName:modelName
                                  block:block
                                    add:add
                              alignment:alignment];
        }
    } else if ([className containsString:@"Dictionary"]) {
        [self propertyStringWithDict:obj
                           modelName:modelName
                               block:block
                                 add:add
                           alignment:alignment];
    }
}

+ (NSError *)propertyStringWithJson:(NSString *)json
                           modelName:(NSString *)modelName
                              block:(BMModelManagerBlock)block
                                add:(BOOL)add
                          alignment:(BOOL)alignment {
    if (!json.length) {
        return [NSError errorWithDomain:@"JSON 为空" code:-10010101 userInfo:nil];
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return [NSError errorWithDomain:@"未知错误" code:-10010101 userInfo:nil];
    }
    NSError *error = nil;
    NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        return error;
    }
    
    NSMutableArray *arr = @[].mutableCopy;
    NSMutableDictionary *dict = @{}.mutableCopy;
    [self propertyStringWithObj:obj
                      modelName:modelName
                          block:^(NSString *str) {
        if (!dict[str]) {
            dict[str] = @YES;
            [arr addObject:str];
            !block ? : block(str);
        }
    } add:add alignment:alignment];
    return nil;
}

@end
