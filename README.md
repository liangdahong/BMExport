# 一个 JSON 转 Model 属性的 Mac 小工具，目前支持 Objective-C，Swift class, Swift struct 。

> 自动将 JSON 转换为 Model 属性代码，支持自动对齐（强迫症的最爱，不在敲空格了哈）和添加注释（注释是给别人看的哈, 自己以后看也轻松）

- 【点击直接下载 https://github.com/liangdahong/BMExport/raw/master/dmg.dmg 】。

<img width="80%" src="https://user-images.githubusercontent.com/12118567/90214199-58ead880-de2a-11ea-814a-ff87765d4bb6.gif"/>

# 当前功能
- JSON -> Model 属性代码
- 添加注释占位
- 属性对齐
- 目前解析 JSON 是独立模块，所以支持其他语言也很简单，只需要编写相关其他语言的特性代码即可。
- 支持 swift 只需如下代码即可：
```OC
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
```


# 联系
- 欢迎 [issues](https://github.com/liangdahong/BMExport/issues) 和 [PR](https://github.com/liangdahong/BMExport/pulls)
- 也可以添加微信<img width="20%" src="https://user-images.githubusercontent.com/12118567/86319172-72fb9d80-bc66-11ea-8c6e-8127f9e5535f.jpg"/> 进微信交流群。
# 计划
- 支持自动生成 `Model` 文件
- 按属性类型排序等
- 网页版工具
- 其他语言（ 逃  [推荐使用此库，支持多种语言哈](https://github.com/Ahmed-Ali/JSONExport) ）
- 等。
