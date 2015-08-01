//
//  ArticleListViewCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ArticleListViewCell.h"
#import "UserInfoManager.h"
@implementation ArticleListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {     
        mImageView = [[NetImageView alloc] initWithFrame:CGRectMake(12, 10, 80, 60)];
        mImageView.mImageType = TImageType_FullFill;
        mImageView.mDefaultImage = [UIImage imageNamed:@"60@2x.png"];
        [self.contentView addSubview:mImageView];
        
        mlbTitle = [[UILabel alloc] initWithFrame:CGRectMake(105, 0, self.frame.size.width-110, 60)];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.numberOfLines = 2;
        mlbTitle.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:mlbTitle];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(105, 55, 120, 20)];
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.textAlignment =NSTextAlignmentLeft;
        mlbDesc.font = [UIFont systemFontOfSize:12];
        mlbDesc.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbDesc];
        
        mlbAuthor = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 115, 55, 110, 20)];
        mlbAuthor.textAlignment = NSTextAlignmentRight;
        mlbAuthor.backgroundColor = [UIColor clearColor];
        mlbAuthor.font = [UIFont systemFontOfSize:12];
        mlbAuthor.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbAuthor];
    }
    return self;
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

- (void)LoadContent:(ArticleListInfo *)info {
    [mImageView GetImageByStr:info.thumb];
    mlbTitle.text = info.title;
    int time = [info.inputtime intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter* df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
//    mlbDesc.text = [df stringFromDate:date];
    mlbDesc.text = [UserInfoManager GetFormatDateByInterval:time];
//    mlbDesc.text = [NSString stringWithFormat:@"发表：%@",[df stringFromDate:date]];
    mlbAuthor.text = info.username;
}

@end
