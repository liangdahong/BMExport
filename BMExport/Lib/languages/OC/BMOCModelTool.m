//
//  BMOCModelTool.m
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMOCModelTool.h"
#import "BMJsonParsingManager.h"

@implementation BMOCModelTool

+ (NSError *)propertyStringWithJson:(NSString *)json
                          modelName:(NSString *)modelName
                              block:(BMOCModelCompleteBlock)block
                                add:(BOOL)add
                          alignment:(BOOL)alignment {
    return [BMJsonParsingManager propertyStringWithJson:json modelInfoModelBlock:^(NSArray<BMModelInfoModel *> *modelInfoModelArray) {
        NSMutableString *str = @"".mutableCopy;
        [modelInfoModelArray enumerateObjectsUsingBlock:^(BMModelInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendString:@"\n\n\n"];
            NSString *modelCode = [self _modelCodeWithModelInfoModel:obj modelName:modelName add:add alignment:alignment];
            [str appendString:modelCode];
        }];
        block(str);
    }];
}

+ (NSString *)_modelCodeWithModelInfoModel:(BMModelInfoModel *)modelInfoModel
                                 modelName:(NSString *)modelName
                                       add:(BOOL)add
                                 alignment:(BOOL)alignment {
    if (modelInfoModel.propertyInfoArray.count == 0) {
        return @"";
    }
    NSMutableArray <NSString *> *propertyArray = @[].mutableCopy;
    [modelInfoModel.propertyInfoArray enumerateObjectsUsingBlock:^(BMPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.propertyType) {
            case BMPropertyTypeInt:
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeBoolean:
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeString:
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeArray:
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, copy) NSArray <<#type#> *> *%@;",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeDictionary:
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, strong) <#type#> *%@;",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeObject:
                [propertyArray addObject:[NSString stringWithFormat:@"@property (nonatomic, strong) <#type#> *%@;",
                                          obj.propertyName]];
                break;
            default:
                break;
        }
    }];
    NSMutableString *modelStr = @"".mutableCopy;
    [modelStr appendFormat:@"@interface %@%u : NSObject\n\n", modelName, arc4random()];
    
    // 添加属性代码
    if (alignment) {
        // 如果需要对齐
        __block NSInteger maxLen = 0;
        [propertyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length > maxLen) {
                maxLen = obj.length;
            }
        }];
        [propertyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.length < maxLen) {
                NSInteger diffLen = maxLen - obj.length;
                NSMutableString *tempStr = @"".mutableCopy;
                [tempStr appendString:obj];
                while (diffLen--) {
                    [tempStr appendString:@" "];
                }
                propertyArray[idx] = tempStr.copy;
            }
        }];
    }
    
    [propertyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [modelStr appendString:obj];
        if (add) {
            [modelStr appendString:@" ///< <#属性注释#>"];
        }
        [modelStr appendString:@"\n"];
    }];
    [modelStr appendString:@"\n@end"];
    return modelStr;
}

@end
