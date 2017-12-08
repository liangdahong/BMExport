//
//  ViewController.m
//  BMExport
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "ViewController.h"
#import "BMModelManager.h"
#import "BMMySettingVC.h"

@interface ViewController () <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (unsafe_unretained) IBOutlet NSTextView *modelTextView;
@property (nonatomic, assign) BOOL add; ///< <#Description#>
@property (nonatomic, assign) BOOL alignment; ///< <#Description#>

@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    _add = YES;
    _alignment = YES;
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
    __block NSMutableString *string = @"".mutableCopy;
    NSError *error = [BMModelManager  propertyStringWithJson:self.jsonTextView.string clasName:@"RootClass" block:^(NSString *str) {
        [string appendString:@"\n\n\n"];
        [string appendString:str];        
        self.modelTextView.string = string;
    } add:_add alignment:_alignment];
    if (error) {
        self.modelTextView.string = error.domain;
    }
}

- (IBAction)settingButtonClick:(id)sender {
    BMMySettingVC *vc = [BMMySettingVC new];
    vc.add = _add;
    vc.alignment = _alignment;
    vc.block = ^(BOOL add, BOOL alignment) {
        self.add = add;
        self.alignment = alignment;
        self.jsonTextView.string = self.jsonTextView.string;
    };
    [self presentViewControllerAsModalWindow:vc];
}

@end
