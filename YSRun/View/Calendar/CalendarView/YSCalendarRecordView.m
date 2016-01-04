//
//  YSCalendarRecordView.m
//  YSRun
//
//  Created by moshuqi on 15/10/15.
//  Copyright © 2015年 msq. All rights reserved.
//

#import "YSCalendarRecordView.h"
#import "YSCalendarTitleBarView.h"
//#import "YSDayCellModel.h"
//#import "YSCalendarDayCell.h"
#import "NSDate+YSDateLogic.h"
#import "YSAppMacro.h"
#import "YSCalendar.h"
#import "YSDevice.h"

#define CalendarReuseIdentifier @"CalendarReuseIdentifier"

@interface YSCalendarRecordView () <YSCalendarTitleBarViewDelegate, YSCalendarDelegate /*, UICollectionViewDelegate, UICollectionViewDataSource*/>

@property (nonatomic, weak) IBOutlet YSCalendarTitleBarView *titleBarView;
//@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet YSCalendar *calendar;

//@property (nonatomic, copy) NSArray *cellDataArray;
@property (nonatomic, strong) NSDate *currentDate;

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *titleBarHeightContraint;

@end

const CGFloat kMinimumInteritemSpacing = 0;
const CGFloat kMinimumLineSpacing = 1;

@implementation YSCalendarRecordView

- (void)awakeFromNib
{
    self.titleBarView.delegate = self;
    
//    [self.collectionView registerNib:[UINib nibWithNibName:@"YSCalendarDayCell" bundle:nil] forCellWithReuseIdentifier:CalendarReuseIdentifier];
//    [self.collectionView setCollectionViewLayout:[self getCollectionViewFlowLayout]];
//    self.collectionView.backgroundColor = RGB(213, 213, 213);
    
    self.calendar.delegate = self;
    [self.titleBarView setupWithDate:[NSDate date]];
    
    if ([YSDevice isPhone6Plus])
    {
        // 6p尺寸适配
        self.titleBarHeightContraint.constant = 68;
        [self.titleBarView setTitleFontSize:24 weekdayFontSize:15];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        UIView *containerView = [[[UINib nibWithNibName:@"YSCalendarRecordView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        CGRect newFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        containerView.frame = newFrame;
        containerView.backgroundColor = GreenBackgroundColor;
        
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)resetCalendarFrame
{
    [self.calendar resetSubviewFrame];
//    [self bringSubviewToFront:self.calendar];
}

- (UICollectionViewFlowLayout *)getCollectionViewFlowLayout
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
    flowLayout.minimumLineSpacing = kMinimumLineSpacing;
    
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    return flowLayout;
}

- (void)toLastMonth
{
    // 日历跳到上一个月
    
    [self.calendar slideToLastMonth];
}

- (void)toNextMonth
{
    // 日历跳到下一个月
    
    [self.calendar slideToNextMonth];
}

//- (NSArray *)getDataArrayWithDate:(NSDate *)date
//{
//    NSDate *firstDay = [date firstDayOfCurrentMonth];
//    NSDate *lastDay = [date lastDayOfCurrentMonth];
//    
//    NSInteger firstWeekday = [firstDay weekdayValue];   // 第一天是星期几
//    NSInteger lastWeekday = [lastDay weekdayValue];     // 最后一天是星期几
//    
//    NSInteger numberOfDaysInLastMonth = firstWeekday - 1;   // 上个月需要显示几天
//    NSInteger numberOfDaysInNextMonth = 7 - lastWeekday;    // 下个月需要显示几天
//    NSInteger numberOfDaysInMonth = [date numberOfDaysInCurrentMonth];  // 当前月一共有几天
//    
//    NSMutableArray *dataArray = [NSMutableArray array];
//    
//    // 上个月显示的cell
//    for (NSInteger i = 0; i < numberOfDaysInLastMonth; i++)
//    {
//        NSDate *date = [firstDay beforeDays:(numberOfDaysInLastMonth - i)];
//        YSDayCellModel *model = [self getCellModelWithDate:date isCurrentMonth:NO];
//        [dataArray addObject:model];
//    }
//    
//    // 当前月显示的cell
//    for (NSInteger i = 0; i < numberOfDaysInMonth; i++)
//    {
//        NSDate *date = [firstDay afterDays:i];
//        YSDayCellModel *model = [self getCellModelWithDate:date isCurrentMonth:YES];
//        [dataArray addObject:model];
//    }
//    
//    // 下个月显示的cell
//    for (NSInteger i = 0 ; i < numberOfDaysInNextMonth; i++)
//    {
//        NSDate *date = [lastDay afterDays:i + 1];
//        YSDayCellModel *model = [self getCellModelWithDate:date isCurrentMonth:NO];
//        [dataArray addObject:model];
//    }
//    
//    // 设置当前日期的颜色为绿色
//    NSInteger currentDayIndex = numberOfDaysInLastMonth + [date dayValue] - 1;
//    YSDayCellModel *model = dataArray[currentDayIndex];
//    model.textColor = GreenBackgroundColor;
//    
//    return dataArray;
//}
//
//- (YSDayCellModel *)getCellModelWithDate:(NSDate *)date isCurrentMonth:(BOOL)isCurrentMonth
//{
//    YSDayCellModel *model = [YSDayCellModel new];
//    model.day = [date dayValue];
//    model.textColor = isCurrentMonth ? RGB(144, 144, 144) : RGB(198, 198, 198);
//    
//    return model;
//}

- (void)resetCalendarWithDate:(NSDate *)date
{
    self.currentDate = date;
    
//    self.cellDataArray = [self getDataArrayWithDate:date];
//    [self.collectionView reloadData];
    
    [self.calendar resetCalanderWithDate:date];
    [self.titleBarView setupWithDate:date];
}

#pragma mark - YSCalendarTitleBarViewDelegate

- (void)titleBarLeftButtonClicked
{
    [self toLastMonth];
}

- (void)titleBarRightButtonClicked
{
    [self toNextMonth];
}

//#pragma mark - UICollectionViewDelegate
//
//
//
//
//#pragma mark - UICollectionViewDataSource
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return [self.cellDataArray count];
//}
//
//- (YSCalendarDayCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    YSCalendarDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CalendarReuseIdentifier forIndexPath:indexPath];
//    
//    YSDayCellModel *model = self.cellDataArray[indexPath.row];
//    [cell setupCellWithModel:model];
//    
//    return cell;
//}
//
//#pragma mark - UICollectionViewDelegateFlowLayout
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    const NSInteger weekdayCount = 7;
//    NSInteger numberOfRows = [self.cellDataArray count] / weekdayCount;
//    
//    CGFloat width = CGRectGetWidth(self.collectionView.bounds);
//    CGFloat height = CGRectGetHeight(self.collectionView.bounds);
//    
//    CGFloat itemWidth = (width - (weekdayCount - 1) * kMinimumInteritemSpacing) / weekdayCount;
//    CGFloat itemHeight = (height - (numberOfRows - 1) * kMinimumLineSpacing) / numberOfRows;
//    
//    CGSize size = CGSizeMake(itemWidth, itemHeight);
//    return size;
//}

#pragma mark - YSCalendarDelegate

- (void)calendarSlideFinishWithDisplayDate:(NSDate *)displayDate
{
    [self.titleBarView setupWithDate:displayDate];
}

- (void)calendarDidSelectedDate:(NSDate *)date
{
    [self.delegate calendarRecordDidSelectedDate:date];
}

@end