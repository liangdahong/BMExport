//
//  BMModelManager.m
//  Property
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "BMModelManager.h"

@implementation BMModelManager

+ (void)propertyStringWithDict:(NSDictionary *)dict clasName:(NSString *)clasNa block:(BMModelManagerBlock)block {
    NSMutableArray *arr = @[].mutableCopy;
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *className = [obj className];
        NSString *type1 = nil;
        NSString *type2 = nil;
        if ([className containsString:@"Array"]) {
            type1 = @"NSArray <<#type#> *> *";
            type2 = @"strong";
            [self propertyStringWithObj:obj clasName:key block:block];
        }
        else if ([className containsString:@"Dictionary"]) {
            type1 = @"<#type#> *";
            type2 = @"strong";
            [self propertyStringWithDict:obj clasName:key block:block];
        }
        else if ([className containsString:@"Number"]) {
            type1 = @"NSInteger ";
            type2 = @"assign";
        }
        else if ([className containsString:@"Boolean"]) {
            type1 = @"BOOL ";
            type2 = @"assign";
        }
        else if ([className containsString:@"String"]) {
            if ([obj isEqualToString:@"YES"]
                || [obj isEqualToString:@"yes"]
                || [obj isEqualToString:@"NO"]
                || [obj isEqualToString:@"no"]
                || [obj isEqualToString:@"FALSE"]
                || [obj isEqualToString:@"TRUE"]
                || [obj isEqualToString:@"false"]
                || [obj isEqualToString:@"true"]) {
                type1 = @"BOOL ";
                type2 = @"assign";
            } else {
                type1 = @"NSString *";
                type2 = @"copy";
            }
        } else {
            type1 = @"NSObject *";
            type2 = @"strong";
        }
        [arr addObject:[NSString stringWithFormat:@"@property (nonatomic, %@) %@%@;",type2, type1, key]];
    }];

    if (!arr.count) {
        return;
    }

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
            [s appendString:@" ///< <#名称#>"];
            arr[idx] = s;
        } else {
            NSMutableString *s = [NSMutableString string];
            [s appendString:obj];
            [s appendString:@" ///< <#名称#>"];
            arr[idx] = s;
        }
    }];
    NSMutableString *modelStr = @"".mutableCopy;
    [modelStr appendFormat:@"@interface %@ : NSObject\n\n",clasNa];
    [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [modelStr appendString:obj];
        [modelStr appendString:@" \n"];
    }];
    [modelStr appendString:@"\n@end"];
    !block ? : block(modelStr.copy);
}

+ (void)propertyStringWithObj:(id)obj clasName:(NSString *)clasNa block:(BMModelManagerBlock)block {
    NSString *className = [obj className];
    if ([className containsString:@"Array"]) {
        NSArray *arr = obj;
        if (arr.count) {
            [self propertyStringWithObj:arr[0] clasName:clasNa block:block];
        }
    } else if ([className containsString:@"Dictionary"]) {
        [self propertyStringWithDict:obj clasName:clasNa block:block];
    }
}

+ (NSError *)propertyStringWithJson:(NSString *)json clasName:(NSString *)clasName block:(BMModelManagerBlock)block {
    if (!json.length) {
        return [NSError errorWithDomain:@"json为nil" code:-10010101 userInfo:nil];
    }
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) {
        return [NSError errorWithDomain:@"json非法" code:-10010101 userInfo:nil];
    }
    NSError *error = nil;
    NSObject *obj = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error) {
        return error;
    }
    [self propertyStringWithObj:obj clasName:clasName block:block];
    return nil;
}




@end