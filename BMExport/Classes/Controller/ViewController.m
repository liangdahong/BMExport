//
//  ViewController.m
//  BMExport
//
//  Created by ___liangdahong on 2017/12/8.
//  Copyright © 2017年 ___liangdahong. All rights reserved.
//

#import "ViewController.h"
#import "BMMySettingVC.h"
#import "BMCodeFormattingVC.h"
#import <PINCache/PINCache.h>
#import "BMOCModelTool.h"
#import "BMSwiftModelTool.h"

@interface ViewController () <NSTextViewDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *jsonTextView;
@property (unsafe_unretained) IBOutlet NSTextView *modelTextView;
@property (nonatomic, assign) BOOL add; ///< <#Description#>
@property (nonatomic, assign) BOOL alignment; ///< <#Description#>
@property (nonatomic, strong) PINCache *pinCache; ///< <#Description#>
@property (weak) IBOutlet NSComboBox *comboBox;


@end

@implementation ViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    _jsonTextView.automaticQuoteSubstitutionEnabled = NO;
    _modelTextView.automaticQuoteSubstitutionEnabled = NO;
    _pinCache = [[PINCache alloc] initWithName:@"setting"];
    NSNumber *addNum =  [_pinCache objectForKey:@"add"];
    if (addNum) {
        _add = addNum.boolValue;
    } else {
        _add = YES;
    }
    NSNumber *alignmentNum =  [_pinCache objectForKey:@"alignment"];
    if (alignmentNum) {
        _alignment = alignmentNum.boolValue;
    } else {
        _alignment = YES;
    }
}

- (void)textViewDidChangeSelection:(NSNotification *)notification {
    if ([self.comboBox.stringValue isEqualToString:@"Objective-C - iOS"]) {
        NSError *error = [BMOCModelTool propertyStringWithJson:self.jsonTextView.string modelName:@"ModelName" block:^(NSString *ocModelCodeString) {
            self.modelTextView.string = ocModelCodeString;
        } add:_add alignment:_alignment];
        if (error) {
            self.modelTextView.string = error.domain;
        }
        
    } else if ([self.comboBox.stringValue isEqualToString:@"Swift Class"]) {
        NSError *error = [BMSwiftModelTool propertyStringWithJson:self.jsonTextView.string
                                                        modelName:@"ModelName"
                                                            block:^(NSString *ocModelCodeString) {
            self.modelTextView.string = ocModelCodeString;
            } swiftModelType:(SwiftModelTypeClass) add:_add alignment:_alignment];
        if (error) {
            self.modelTextView.string = error.debugDescription;
        }
    } else if ([self.comboBox.stringValue isEqualToString:@"Swift Struct"]) {
        NSError *error = [BMSwiftModelTool propertyStringWithJson:self.jsonTextView.string
                                                        modelName:@"ModelName"
                                                            block:^(NSString *ocModelCodeString) {
            self.modelTextView.string = ocModelCodeString;
        } swiftModelType:(SwiftModelTypeStruct) add:_add alignment:_alignment];
        if (error) {
            self.modelTextView.string = error.debugDescription;
        }
    }
}

- (IBAction)settingButtonClick:(id)sender {
    BMMySettingVC *vc = [BMMySettingVC new];
    vc.add = _add;
    vc.alignment = _alignment;
    __weak typeof(self) weakSelf = self;
    vc.block = ^(BOOL add, BOOL alignment) {
        __strong typeof(self) self = weakSelf;
        self.add = add;
        self.alignment = alignment;
        self.jsonTextView.string = self.jsonTextView.string;
        [self.pinCache setObject:@(add) forKey:@"add"];
        [self.pinCache setObject:@(alignment) forKey:@"alignment"];
    };
    [self presentViewControllerAsModalWindow:vc];
}

- (IBAction)comboBox:(NSComboBox *)sender {
    self.jsonTextView.string = self.jsonTextView.string;
}

@end
