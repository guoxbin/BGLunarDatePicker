//
//  BGLunarDatePicker.m
//  BGLunarDatePickerDemo
//
//  Created by GB on 16/4/14.
//  Copyright © 2016年 binguo. All rights reserved.
//

#import "BGLunarDatePicker.h"

const NSInteger Repeat = 100;
const NSInteger NumberOfComponents = 7;

const NSInteger ComponentYear = 0;
const NSInteger ComponentMonth = 1;
const NSInteger ComponentDay = 2;

const NSInteger LunarOffset = 2697;

const NSInteger LunarYearCountOfEra = 60;

const unsigned UnitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;

@interface BGLunarDatePicker()

@property (nonatomic, strong) NSArray *monthName;
@property (nonatomic, strong) NSArray *dayName;

@property (nonatomic, strong) NSArray *heavenlyStems;
@property (nonatomic, strong) NSArray *earthlyBranches;

@property (nonatomic, strong) NSMutableArray *yearComponentsList;
@property (nonatomic, strong) NSMutableArray *monthComponentsList;
@property (nonatomic, strong) NSMutableArray *dayComponentsList;

@property (nonatomic, strong) NSCalendar *lunarCalendar;
@end

@implementation BGLunarDatePicker

-(instancetype)init{
    if (self = [super init]){
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self initialize];
}

- (void)initialize{
    
     self.lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    self.monthName = [NSArray arrayWithObjects:@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月",  @"十月", @"冬月", @"腊月", nil];
    
    self.dayName = [NSArray arrayWithObjects:@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十", @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十", @"三一", nil];
    
    self.heavenlyStems = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸",nil];
    self.earthlyBranches = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    
    [self reset];
    
}

- (void)setMinimumDate:(NSDate *)minimumDate{
    _minimumDate = minimumDate;
    
    [self reset];
}

- (void)setMaximumDate:(NSDate *)maximumDate{
    _maximumDate = maximumDate;
    
    [self reset];
}

-(void)setDate:(NSDate *)date{
    
    [self setDate:date animated:false];
    
}

-(void)setDate:(NSDate *)date animated:(BOOL)animated{
    
    _date = [self getTrimedDate:date];
    [self render:animated];
    
}

-(void)reset{
    
    _date = self.date==nil ? [NSDate date] : self.date;
    
    _minimumDate = self.minimumDate == nil ? [NSDate distantPast] : self.minimumDate;
    
    _maximumDate = self.maximumDate == nil ? [NSDate distantFuture] : self.maximumDate;
    
    _date = [self getTrimedDate:_date];
    _minimumDate = [self getTrimedDate:_minimumDate];
    _maximumDate = [self getTrimedDate:_maximumDate];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self render:false];
    
}

- (void)render:(bool)animated{
    
    [self refreshYearList];
    [self reloadComponent:ComponentYear];
    
    [self selectRow:[self rowForYear] inComponent:ComponentYear animated:animated];
    
    
    [self refreshMonthList];
    [self reloadComponent:ComponentMonth];
    
    [self selectRow:[self rowForMonth] inComponent:ComponentMonth animated:animated];
    
    
    [self refreshDayList];
    [self reloadComponent:ComponentDay];
    
    [self selectRow:[self rowForDay] inComponent:ComponentDay animated:animated];
    
}

- (NSInteger)rowForYear{
    
    NSDateComponents *components = [self componentsForDate:self.date];
    
    NSUInteger index = 0;
    
    for (NSDateComponents *itComponents in self.yearComponentsList) {
        
        if(itComponents.year==components.year && itComponents.era==components.era){
            break;
        }
            
        index++;
    }
    
    NSInteger row = index+(self.yearComponentsList.count*Repeat/2);
    
    return row;
}

- (NSInteger)rowForMonth{

    NSDateComponents *components = [self componentsForDate:self.date];
    
    NSUInteger index = 0;
    
    for (NSDateComponents *itComponents in self.monthComponentsList) {
        if(itComponents.month==components.month){
            break;
        }
        
        index++;
    }
    
    NSInteger row = index+(self.monthComponentsList.count*Repeat/2);
    
    return row;
}

- (NSInteger)rowForDay{

    NSDateComponents *components = [self componentsForDate:self.date];
    
    NSUInteger index = 0;
    
    for (NSDateComponents *itComponents in self.dayComponentsList) {
        if(itComponents.day==components.day){
            break;
        }
        
        index++;
    }
    
    NSInteger row = index+(self.dayComponentsList.count*Repeat/2);
    
    return row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return NumberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger numberOfRows = 1;
    
    switch (component) {
        case ComponentYear:
            numberOfRows = self.yearComponentsList.count * Repeat;
            break;
            
        case ComponentMonth:
            numberOfRows = self.monthComponentsList.count * Repeat;
            break;
            
        case ComponentDay:
            numberOfRows = self.dayComponentsList.count * Repeat;
            break;
            
        default:
            break;
    }
    
    return numberOfRows;
    
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat width = 88;
    switch (component) {
            
        case ComponentYear:
            width = 120;
            break;
            
        default:
            break;
    }
    return width;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *title = nil;
    NSDateComponents *components = nil;
    
    switch (component) {
        case ComponentYear:
            row = row % self.yearComponentsList.count;
            components = self.yearComponentsList[row];
            title = [self yearNameForComponents:components];
            break;
            
        case ComponentMonth:
            row = row % self.monthComponentsList.count;
            components = self.monthComponentsList[row];
            title = [self monthNameForComponents:components];
            break;
            
        case ComponentDay:
            row = row % self.dayComponentsList.count;
            components = self.dayComponentsList[row];
            title = [self dayNameForComponents:components];
            break;
            
        default:
            break;
    }
    
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    
    if(component == ComponentYear){
        
        [self refreshMonthList];
        [self reloadComponent:ComponentMonth];
        
        [self selectRow:[self rowForMonth] inComponent:ComponentMonth animated:NO];
        
        [self refreshDayList];
        [self reloadComponent:ComponentDay];
        
        [self selectRow:[self rowForDay] inComponent:ComponentDay animated:NO];
    }
    
    if(component == ComponentMonth){
        
        [self refreshDayList];
        [self reloadComponent:ComponentDay];
        
        [self selectRow:[self rowForDay] inComponent:ComponentDay animated:NO];
        
    }
    
    bool adjusted = false;
    
    _date = [self dateForSelection:&adjusted];
    
    if(adjusted){
        
        [self render:true];
        
    }
    
    NSLog(@"date updated date=%@", self.date);
    
    [self.pickerDelegate dateChanged:self.date];
    
}

- (void)refreshYearList{
    
    self.yearComponentsList = [NSMutableArray array];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *diffComp = [[NSDateComponents alloc] init];
    [diffComp setYear:1];
    [diffComp setMonth:0];
    [diffComp setDay:0];
    NSDate *currentDate = [NSDate distantPast];
    while(true){
        if([currentDate compare:[NSDate distantFuture]]>0){
            break;
        }
        
        NSDateComponents *components = [self componentsForDate:currentDate];
        components.month = 1;
        components.day = 1;
        
        [self.yearComponentsList addObject:components];
        
        currentDate = [calendar dateByAddingComponents:diffComp toDate:currentDate options:0];
    }
    
}

- (void)refreshMonthList{
    
    long yearRow = [self selectedRowInComponent:ComponentYear];
    
    yearRow = yearRow%self.yearComponentsList.count;
    
    NSDateComponents *components = self.yearComponentsList[yearRow];
    
    self.monthComponentsList = [self getMonthComponentsListComponents:components];
    
}

- (void)refreshDayList{
    
    long monthRow = [self selectedRowInComponent:ComponentMonth];
    
    monthRow = monthRow%self.monthComponentsList.count;
    
    NSDateComponents *components = self.monthComponentsList[monthRow];
    
    self.dayComponentsList = [self getDayComponentsListComponents:components];

}


- (NSDate *)getTrimedDate:(NSDate *)date{
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    comps.hour = 0;
    comps.minute = 0;
    comps.second = 0;
    comps.nanosecond = 0;
    
    NSDate *trimedDate = [calendar dateFromComponents:comps];
    
    return trimedDate;
}

- (NSString *)yearNameForDate:(NSDate *)date{
    
    NSDateComponents *lunarComps = [self.lunarCalendar components:UnitFlags fromDate:date];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [calendar components:UnitFlags fromDate:date];
    
    return [self yearNameForComponents:lunarComps];
}

- (NSString *)monthNameForDate:(NSDate *)date{
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *lunarComps = [lunarCalendar components:unitFlags fromDate:date];
    
    return [self monthNameForComponents:lunarComps];
}

- (NSString *)dayNameForDate:(NSDate *)date{
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *lunarCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSDateComponents *lunarComps = [lunarCalendar components:unitFlags fromDate:date];
    
    return [self dayNameForComponents:lunarComps];
}

- (NSString *)yearNameForComponents:(NSDateComponents* )components{
    
    NSString *year = [NSString stringWithFormat:@"%ld", components.era*LunarYearCountOfEra+components.year-LunarOffset];
    NSString *hs = self.heavenlyStems[(components.year-1)%self.heavenlyStems.count];
    NSString *eb = self.earthlyBranches[(components.year-1)%self.earthlyBranches.count];
    year = [NSString stringWithFormat:@"%@%@%@", year, hs, eb];
    
    return year;
    
}

- (NSString *)monthNameForComponents:(NSDateComponents*)components{
    
    NSString *month = self.monthName[components.month-1];
    month = [NSString stringWithFormat:@"%@%@", components.isLeapMonth?@"闰":@"", month];
    
    return month;
}

- (NSString *)dayNameForComponents:(NSDateComponents* )components{
    
    return self.dayName[components.day-1];
    
}

- (NSMutableArray *)getMonthComponentsListComponents:(NSDateComponents *)components{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSDate *date = [self.lunarCalendar dateFromComponents:components];
    
    while(true){
        
        NSDateComponents *lunarComps = [self.lunarCalendar components:UnitFlags fromDate:date];
        
        if(lunarComps.year!=components.year){
            break;
        }
        
        [array addObject:lunarComps];
        
        NSDateComponents *diffComp = [[NSDateComponents alloc] init];
        [diffComp setYear:0];
        [diffComp setMonth:1];
        [diffComp setDay:0];
        date = [self.lunarCalendar dateByAddingComponents:diffComp toDate:date options:0];

    }
    
    return array;
}

- (NSMutableArray *)getDayComponentsListComponents:(NSDateComponents *)components{
    
    NSMutableArray *array = [NSMutableArray array];
    
    NSDate *date = [self.lunarCalendar dateFromComponents:components];
    
    while(true){
        
        NSDateComponents *lunarComps = [self componentsForDate:date];
        
        if(lunarComps.month!=components.month){
            break;
        }
        
        [array addObject:lunarComps];
        
        NSDateComponents *diffComp = [[NSDateComponents alloc] init];
        [diffComp setYear:0];
        [diffComp setMonth:0];
        [diffComp setDay:1];
        date = [self.lunarCalendar dateByAddingComponents:diffComp toDate:date options:0];
        
    }
    
    return array;
}

- (NSDateComponents *)componentsForDate:(NSDate *)date{
    
    NSDateComponents *components = [self.lunarCalendar components:UnitFlags fromDate:date];
    
    return components;
    
}

- (NSDate *)dateForSelection:(bool *)adjusted{
    
    *adjusted = false;
    
    long dayRow = [self selectedRowInComponent:ComponentDay];
    
    dayRow = dayRow%self.dayComponentsList.count;
    
    NSDateComponents *components = self.dayComponentsList[dayRow];
    
    NSDate *date = [self.lunarCalendar dateFromComponents:components];
    
    if([date compare:self.minimumDate]<0){
        date = self.minimumDate;
        *adjusted = true;
    }
    
    if([date compare:self.maximumDate]>0){
        date = self.maximumDate;
        *adjusted = true;
    }
    
    return date;
}


@end
