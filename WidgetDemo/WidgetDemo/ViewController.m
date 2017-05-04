//
//  ViewController.m
//  WidgetDemo
//
//  Created by 栾美娜 on 2017/5/4.
//  Copyright © 2017年 栾美娜. All rights reserved.
//

#import "ViewController.h"
#import "HomeViewController.h"
#import "TestViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVC:) name:@"pushNote" object:nil];
}

- (void)pushVC:(NSNotification *)note {
    NSLog(@"%@", note.userInfo);
    
    NSString *res = [self readDataFromNSUserDefaults];
    NSLog(@"%@", res);
    
    if ([note.userInfo[@"key"] isEqualToString:@"GotoHomePage"]) {
        [self.navigationController pushViewController:[HomeViewController new] animated:true];
        
    } else if ([note.userInfo[@"key"] isEqualToString:@"GotoTestPage"]) {
        [self.navigationController pushViewController:[TestViewController new] animated:true];
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

@end
