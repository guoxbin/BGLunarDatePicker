//
//  ViewController.m
//  BGLunarDatePickerDemo
//
//  Created by GB on 16/4/14.
//  Copyright © 2016年 binguo. All rights reserved.
//

#import "ViewController.h"
#import "BGLunarDatePicker.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    BGLunarDatePicker *picker = [[BGLunarDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
    picker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-32*365*86400];
    
    picker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [self.view addSubview:picker];
    
    NSLog(@"date=%@", picker.date);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
