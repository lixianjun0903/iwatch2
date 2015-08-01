//
//  RecommandListCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecommandListCell.h"
#import "TouchView.h"

@implementation RecommandListCell

@synthesize delegate, OnRecommandSelect;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        int iLeft = (self.frame.size.width-280)/3;
        
        for (int i = 0; i < 2; i ++) {
            NetImageView *imageView = [[NetImageView alloc] initWithFrame:CGRectMake(iLeft+i*(140+iLeft), iLeft, 140, 140)];
            imageView.mImageType = TImageType_AutoSize;
            imageView.backgroundColor = [UIColor whiteColor];
            imageView.mDefaultImage = [UIImage imageNamed:@"aibiaozu@2x.png"];
            [self.contentView addSubview:imageView];
            
            UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.size.height-36, imageView.frame.size.width, 36)];
            backView.userInteractionEnabled = NO;
            backView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
            [imageView addSubview:backView];
            
            UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, backView.frame.size.width-20, 15)];
            lbTitle.backgroundColor = [UIColor clearColor];
            lbTitle.font = [UIFont systemFontOfSize:13];
            lbTitle.textColor = [UIColor whiteColor];
            [backView addSubview:lbTitle];
            
            UILabel *lbTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 18, backView.frame.size.width-20, 15)];
            lbTime.backgroundColor = [UIColor clearColor];
//            lbTime.textAlignment = NSTextAlignmentCenter;
            lbTime.font = [UIFont systemFontOfSize:10];
            lbTime.textColor = [UIColor whiteColor];
            [backView addSubview:lbTime];
            
            TouchView *touchView = [[TouchView alloc] initWithFrame:imageView.bounds];
            touchView.tag = i+3000;
            touchView.delegate = self;
            touchView.OnViewClick = @selector(OnViewClick:);
            [imageView addSubview:touchView];
            
            if (i == 0) {
                mLeftView = imageView;
                mlbLeftTitle = lbTitle;
                mlbLeftTime = lbTime;
            }
            else {
                mRightView = imageView;
                mlbRightTitle = lbTitle;
                mlbRightTime = lbTime;
            }
        }
    }
    return self;
}

- (void)LoadContent:(RecommandInfo *)info :(RecommandInfo *)info2 {
    NSLog(@"%@, %@", info.thumb, info2.thumb);
    if (info) {
        mLeftView.hidden = NO;
        [mLeftView GetImageByStr:info.thumb];
        mlbLeftTitle.text = info.title;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info2.updatetime intValue]];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        mlbLeftTime.text = currentDateStr;
//        mlbLeftTime.text = [UserInfoManager GetFormatDateByInterval:[info.updatetime intValue]];
    }
    else {
        mLeftView.hidden = YES;
    }
    if (info2) {
        mRightView.hidden = NO;
        [mRightView GetImageByStr:info2.thumb];
        mlbRightTitle.text = info2.title;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        //用[NSDate date]可以获取系统当前时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[info2.updatetime intValue]];
        NSString *currentDateStr = [dateFormatter stringFromDate:date];
        mlbRightTime.text = currentDateStr;
//        mlbRightTime.text = [UserInfoManager GetFormatDateByInterval:[info2.updatetime intValue]];
    }
    else {
        mRightView.hidden = YES;
    }
}

- (void)OnViewClick:(TouchView *)sender {
    self.miIndex = sender.tag-3000;
    if (delegate && OnRecommandSelect) {
        SafePerformSelector([delegate performSelector:OnRecommandSelect withObject:self]);
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
