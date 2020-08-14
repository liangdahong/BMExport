//
//  BMSwiftModelTool.m
//  BMExport
//
//  Created by liangdahong on 2020/8/14.
//  Copyright © 2020 liangdahong. All rights reserved.
//

#import "BMSwiftModelTool.h"
#import "BMJsonParsingManager.h"

@implementation BMSwiftModelTool

+ (NSError *)propertyStringWithJson:(NSString *)json
                          modelName:(NSString *)modelName
                              block:(BMSwiftModelCompleteBlock)block
                     swiftModelType:(SwiftModelType)type
                                add:(BOOL)add
                          alignment:(BOOL)alignment {
    return [BMJsonParsingManager propertyStringWithJson:json modelInfoModelBlock:^(NSArray<BMModelInfoModel *> *modelInfoModelArray) {
        NSMutableString *str = @"".mutableCopy;
        [modelInfoModelArray enumerateObjectsUsingBlock:^(BMModelInfoModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [str appendString:@"\n\n\n"];
            NSString *modelCode = [self _modelCodeWithModelInfoModel:obj modelName:modelName swiftModelType:(type) add:add alignment:alignment];
            [str appendString:modelCode];
        }];
        block(str);
    }];
}

+ (NSString *)_modelCodeWithModelInfoModel:(BMModelInfoModel *)modelInfoModel
                                 modelName:(NSString *)modelName
                            swiftModelType:(SwiftModelType)type
                                       add:(BOOL)add
                                 alignment:(BOOL)alignment {
    if (modelInfoModel.propertyInfoArray.count == 0) {
        return @"";
    }
    NSMutableArray <NSString *> *propertyArray = @[].mutableCopy;
    [modelInfoModel.propertyInfoArray enumerateObjectsUsingBlock:^(BMPropertyInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        switch (obj.propertyType) {
            case BMPropertyTypeInt:
                [propertyArray addObject:[NSString stringWithFormat:@"var %@ = 0",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeBoolean:
                [propertyArray addObject:[NSString stringWithFormat:@"var %@ = false",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeString:
                [propertyArray addObject:[NSString stringWithFormat:@"var %@ = \"\"",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeArray:
                [propertyArray addObject:[NSString stringWithFormat:@"var %@: Array<<#type#>> = []",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeDictionary:
                [propertyArray addObject:[NSString stringWithFormat:@"var %@: <#type#>?",
                                          obj.propertyName]];
                break;
                
            case BMPropertyTypeObject:
                [propertyArray addObject:[NSString stringWithFormat:@"var %@: <#type#>?",
                                          obj.propertyName]];
                break;
            default:
                break;
        }
    }];
    NSMutableString *modelStr = @"".mutableCopy;
    [modelStr appendFormat:@"%@ %@%u {\n",
     type  == SwiftModelTypeClass ? @"class" : @"struct",
     modelName,
     arc4random()];
    
    [propertyArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (add) {
            [modelStr appendString:@"    /// <#Description#>\n"];
        }
        [modelStr appendString:@"    "];
        [modelStr appendString:obj];
        [modelStr appendString:@"\n"];
    }];
    [modelStr appendString:@"\n}"];
    return modelStr;
}

@end
