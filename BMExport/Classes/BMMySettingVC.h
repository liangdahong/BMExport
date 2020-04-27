//
//  BMMySettingVC.h
//  BMExport
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^BMSettingVCBlock)(BOOL add, BOOL alignment);

@interface BMMySettingVC : NSViewController

@property (nonatomic, copy) BMSettingVCBlock block; ///< 修改配置 Block
@property (nonatomic, assign) BOOL add; ///< 加注释
@property (nonatomic, assign) BOOL alignment; ///< 是否对齐

@end
