//
//  BDLunarDatePicker.h
//  BGLunarDatePickerDemo
//
//  Created by GB on 16/4/14.
//  Copyright © 2016年 binguo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BGLunarDatePickerDelegate <NSObject>

- (void)dateChanged:(NSDate *)date;

@end

@interface BGLunarDatePicker : UIPickerView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) id<BGLunarDatePickerDelegate> pickerDelegate;

@property (nonatomic, strong) NSDate *date;        // default is current date when picker created.

@property (nullable, nonatomic, strong) NSDate *minimumDate; // specify min/max date range. default is nil.
@property (nullable, nonatomic, strong) NSDate *maximumDate; // default is nil.

- (void)setDate:(NSDate *)date animated:(BOOL)animated; // if animated is YES, animate the wheels of time to display the new date

@end
