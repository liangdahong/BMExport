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
                      clasName:(NSString *)clasNa
                         block:(BMModelManagerBlock)block
                           add:(BOOL)add
                     alignment:(BOOL)alignment {
    NSMutableArray *arr = @[].mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        // 获取 value 的类名称
        NSString *className = [obj className];
        // 定义类型 classType
        NSString *classType = nil;
        // 定义修饰词 type2
        NSString *type2 = nil;

        if ([className containsString:@"Array"]) {
            classType = @"NSArray <<#type#> *> *";
            type2 = @"strong";
            [self propertyStringWithObj:obj clasName:key block:block add:add alignment:alignment];
        } else if ([className containsString:@"Dictionary"]) {
            classType = @"<#type#> *";
            type2 = @"strong";
            [self propertyStringWithDict:obj clasName:key block:block add:add alignment:alignment];
        } else if ([className containsString:@"Number"]) {
            classType = @"NSInteger ";
            type2 = @"assign";
        } else if ([className containsString:@"Boolean"]) {
            classType = @"BOOL ";
            type2 = @"assign";
        } else if ([className containsString:@"String"]) {
            if ([obj isEqualToString:@"YES"]
                || [obj isEqualToString:@"yes"]
                || [obj isEqualToString:@"NO"]
                || [obj isEqualToString:@"no"]
                || [obj isEqualToString:@"FALSE"]
                || [obj isEqualToString:@"TRUE"]
                || [obj isEqualToString:@"false"]
                || [obj isEqualToString:@"true"]) {
                classType = @"BOOL ";
                type2 = @"assign";
            } else {
                classType = @"NSString *";
                type2 = @"copy";
            }
        } else {
            classType = @"NSObject *";
            type2 = @"strong";
        }
        [arr addObject:[NSString stringWithFormat:@"@property (nonatomic, %@) %@%@;",type2, classType, key]];
    }];

    if (!arr.count) {
        return;
    }

    if (alignment) {
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
    [modelStr appendFormat:@"@interface %@ : NSObject\n\n",clasNa];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [modelStr appendString:obj];
        [modelStr appendString:@" \n"];
    }];
    [modelStr appendString:@"\n@end"];
    !block ? : block(modelStr.copy);
}

+ (void)propertyStringWithObj:(id)obj
                     clasName:(NSString *)clasNa
                        block:(BMModelManagerBlock)block
                          add:(BOOL)add
                    alignment:(BOOL)alignment {
    NSString *className = [obj className];
    if ([className containsString:@"Array"]) {
        NSArray *arr = obj;
        if (arr.count) {
            [self propertyStringWithObj:arr[0] clasName:clasNa block:block add:add alignment:alignment];
        }
    } else if ([className containsString:@"Dictionary"]) {
        [self propertyStringWithDict:obj clasName:clasNa block:block add:add alignment:alignment];
    }
}

+ (NSError *)propertyStringWithJson:(NSString *)json
                           clasName:(NSString *)clasName
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
    [self propertyStringWithObj:obj clasName:clasName block:^(NSString *str) {
        for (NSString *s in arr) {
            // 如果数组中已经存在就返回
            if ([str isEqualToString:s]) return;
        }
        [arr addObject:str];
        !block ? : block(str);
    } add:add alignment:alignment];
    return nil;
}

@end
