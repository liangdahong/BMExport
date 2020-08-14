# 一个 JSON 转 Model 属性代码的 Mac 小工具，目前支持 Objective-C，Swift class， Swift struct 。

- 【点击直接下载，建议直接编译源码马上体验最新更全功能 https://github.com/liangdahong/BMExport/raw/master/dmg.dmg 】。

<img width="80%" src="https://user-images.githubusercontent.com/12118567/90214199-58ead880-de2a-11ea-814a-ff87765d4bb6.gif"/>

# 当前功能
- JSON -> Model 属性代码
- 添加注释占位
- 属性对齐
- 目前解析 JSON 是独立模块，所以支持其他语言也很简单，只需要编写相关其他语言的特性代码即可。
- 支持 swift 只需如下代码即可：
![image](https://user-images.githubusercontent.com/12118567/90214567-82f0ca80-de2b-11ea-8265-c4b08817674e.png)
```OBJC
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
```

- 支持 Objective-C 只需如下代码即可：
![image](https://user-images.githubusercontent.com/12118567/90214557-78cecc00-de2b-11ea-954a-f022487fb097.png)
```OBJC
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
