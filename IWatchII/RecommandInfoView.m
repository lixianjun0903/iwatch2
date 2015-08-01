//
//  RecommandInfoView.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecommandInfoView.h"

@implementation RecommandInfoView

@synthesize delegate, OnRecommandSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        mImageView = [[NetImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-63)];
        mImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mImageView.mImageType = TImageType_AutoSize;
        [self addSubview:mImageView];
        
        UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-63, self.frame.size.width, 63)];
        botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        botView.image = [UIImage imageNamed:@"f_detail20.png"];
        [self addSubview:botView];
        
        mlbDay = [[UILabel alloc] initWithFrame:CGRectMake(0, 8, 50, 30)];
        mlbDay.backgroundColor = [UIColor clearColor];
        mlbDay.textAlignment = UITextAlignmentCenter;
        mlbDay.font = [UIFont boldSystemFontOfSize:25];
        mlbDay.textColor = [UIColor blackColor];
        [botView addSubview:mlbDay];
        
        mlbMonth = [[UILabel alloc] initWithFrame:CGRectMake(0, 28, 50, 30)];
        mlbMonth.backgroundColor = [UIColor clearColor];
        mlbMonth.textAlignment = UITextAlignmentCenter;
        mlbMonth.font = [UIFont systemFontOfSize:11];
        mlbMonth.textColor = [UIColor blackColor];
        [botView addSubview:mlbMonth];
        
        mlbTitle = [[UILabel alloc] initWithFrame:CGRectMake(52, 12, botView.frame.size.width-70, 20)];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.font = [UIFont systemFontOfSize:16];
        mlbTitle.textColor = [UIColor blackColor];
        [botView addSubview:mlbTitle];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(52, 32, botView.frame.size.width-70, 20)];
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.font = [UIFont systemFontOfSize:13];
        mlbDesc.textColor = [UIColor grayColor];
        [botView addSubview:mlbDesc];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        btn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [btn addTarget:self action:@selector(OnButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}

- (void)OnButtonClick {
    if (delegate && OnRecommandSelect) {
        SafePerformSelector([delegate performSelector:OnRecommandSelect withObject:self]);
    }
}

- (void)LoadContent:(RecommandInfo *)info {
    [mImageView GetImageByStr:info.thumb];
    mlbTitle.text = info.title;
    mlbDesc.text = info.m_description;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info.updatetime floatValue]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"M-d";
    NSString *datestr = [df stringFromDate:date];
    NSArray *timearray = [datestr componentsSeparatedByString:@"-"];
    if (timearray.count == 2) {
        NSArray *months = @[@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"OCT",@"NOV",@"DEC"];
        int iMonth = [[timearray objectAtIndex:0] intValue];
        mlbMonth.text = [NSString stringWithFormat:@"%@", [months objectAtIndex:iMonth-1]];
        mlbDay.text = [NSString stringWithFormat:@"%@", [timearray objectAtIndex:1]];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
