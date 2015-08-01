//
//  UserInfoManager.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager


+ (NSDate *)GetStartDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *dateString = [df stringFromDate:date];
    return [df dateFromString:dateString];
}

+ (NSString *)GetFormatDateString:(NSDate *)date {
    NSDate *startdate = [UserInfoManager GetStartDate:[NSDate date]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:date toDate:startdate options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    int hour = [components hour];
    int minute = [components minute];
    int second = [components second];
    
    int iOffset = (hour*60+minute)*60+second;
    
    if (year == 0 && month == 0 && day < 2) {
        NSString *title = nil;
        if (day <= 0) {
            if (iOffset <= 0) {
                NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date toDate:[NSDate date] options:0];
                int hours = [components hour];
                int minutes = [components minute];
                if (hours == 0) {
                    return [NSString stringWithFormat:@"%d分钟前", minutes];
                }
                else if (hours <= 3) {
                    return [NSString stringWithFormat:@"%d小时前", hours];
                }
                else {
                    title = @"今天";
                }
            }
            else {
                title = @"昨天";
            }
        }
        else if (day == 1) {
            title = @"前天";
        }
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        return [df stringFromDate:date];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"MM-dd HH:mm";
    return [df stringFromDate:date];
}

+ (NSString *)GetFormatDateByInterval:(NSTimeInterval)interval {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return [UserInfoManager GetFormatDateString:date];
}

@end
