//
//  TodayViewController.m
//  WidgetDemoToday
//
//  Created by 栾美娜 on 2017/5/4.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "TodayViewController.h"
#import "UIView+SDKCustomView.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (nonatomic, assign) CGFloat selfW;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    _selfW = [UIScreen mainScreen].bounds.size.width;
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        _selfW -= 20;
    }
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _selfW, 0)];
    [self.view addSubview:container];
    
    NSArray *titlesArr = @[@"one", @"two", @"three", @"four", @"five", @"six", @"seven"];
    CGFloat itemWH = 50;
    int rowCount = 5;
    CGFloat paddingX = (_selfW-rowCount*itemWH)/(rowCount+1);
    CGFloat paddingY = 40;
  
    for (int i = 0; i < titlesArr.count; i++) {
        int row = i / rowCount;
        int col = i % rowCount;
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = 1000 +i;
        btn.frame = CGRectMake(paddingX+ col*(paddingX+itemWH), paddingY+(paddingY+itemWH)*row, itemWH, itemWH);
        btn.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
        [btn setTitle:titlesArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [container addSubview:btn];
    }
    container.height = CGRectGetMaxY(container.subviews.lastObject.frame);

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 10.0) {
        self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
    } else {
        self.preferredContentSize = CGSizeMake(_selfW, CGRectGetMaxY(self.view.subviews.lastObject.frame));
    }
}

- (void)btnAction:(UIButton *)sender {
    NSLog(@"%d", sender.tag-1000);

    [self saveDataByNSUserDefaults];
    if (sender.tag -1000 == 0) {
        
        [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoHomePage"] completionHandler:^(BOOL success) {
            
            NSLog(@"res%@", success ? @"true" : @"false");
        }];
    } else {
        [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=GotoTestPage"] completionHandler:^(BOOL success) {
        }];
    }
    
}

// 保存数据
- (void)saveDataByNSUserDefaults{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mn"];
                              [shared setObject:@"asdfasdf" forKey:@"widget"];
                              [shared synchronize];
                              
    
}

//读取数据
- (NSString *)readDataFromNSUserDefaults{
    NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.mn"];
    NSString *value = [shared valueForKey:@"widget"];
    return value;
}

                              
                              
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode withMaximumSize:(CGSize)maxSize {
    
    if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
        
        self.preferredContentSize = CGSizeMake(_selfW, CGRectGetMaxY(self.view.subviews.lastObject.frame) + 20);
        
    } else {
        self.preferredContentSize = CGSizeMake(_selfW, 110);
    }
}

@end
