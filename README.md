# BGLunarDatePicker
A date time picker which can choose date in chinese calendar

![ScreenShot](https://raw.github.com/guoxbin/BGLunarDatePicker/master/demo.jpg =320)

## Feature
1. setting min date
1. setting max date

## Usage
1. drag foler "BGLunarDatePicker" to your project.
1. code as below

```
BGLunarDatePicker *picker = [[BGLunarDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    
picker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:-32*365*86400];
    
picker.date = [NSDate dateWithTimeIntervalSinceNow:0];
    
[self.view addSubview:picker];
```