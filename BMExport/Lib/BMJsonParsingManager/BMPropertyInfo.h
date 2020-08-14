//
//  BMPropertyInfo.h
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BMPropertyType) {
    BMPropertyTypeInt,
    BMPropertyTypeBoolean,
    BMPropertyTypeString,
    BMPropertyTypeArray,
    BMPropertyTypeDictionary,
    BMPropertyTypeObject,
};

@interface BMPropertyInfo : NSObject

@property (nonatomic, copy) NSString *propertyName; ///< 属性名字
@property (nonatomic, assign) BMPropertyType propertyType; ///< 属性类型

@end

