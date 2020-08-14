//
//  BMModelManager.m
//  Property
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "BMModelInfoModel.h"

@interface BMModelInfoModel ()

@property (nonatomic, copy, readwrite) NSString *hashKey;

@end

@implementation BMModelInfoModel

- (NSString *)hashKey {
    if (_hashKey) {
        return _hashKey;
    }
    NSMutableArray <BMPropertyInfo * > *arr = self.propertyInfoArray.mutableCopy;
    [arr sortUsingComparator:^NSComparisonResult(BMPropertyInfo *  _Nonnull obj1, BMPropertyInfo * _Nonnull obj2) {
        return [obj1.propertyName compare:obj2.propertyName];
    }];
    NSMutableString *hashKey = @"".mutableCopy;
    [arr enumerateObjectsUsingBlock:^(BMPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [hashKey appendFormat:@"%@%ld", obj.propertyName, (long)obj.propertyType];
    }];
    _hashKey = hashKey;
    return hashKey;
}

@end
