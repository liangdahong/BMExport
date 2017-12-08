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

@end

@implementation ViewController

- (void)textViewDidChangeSelection:(NSNotification *)notification {
    __block NSMutableString *string = @"".mutableCopy;
    NSMutableArray *arr = @[].mutableCopy;    
    NSError *error = [BMModelManager  propertyStringWithJson:self.jsonTextView.string clasName:@"RootClass" block:^(NSString *str) {
        for (NSString *s in arr) {
            if ([str isEqualToString:s])return;
        }
        [arr addObject:str];
        [string appendString:@"\n\n\n"];
        [string appendString:str];        
        self.modelTextView.string = string;
    }];
    if (error) {
        self.modelTextView.string = error.domain;
    }
}

- (IBAction)settingButtonClick:(id)sender {
    [self presentViewControllerAsModalWindow:[BMMySettingVC new]];
}

@end
