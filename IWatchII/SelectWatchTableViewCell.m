//
//  SelectWatchTableViewCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SelectWatchTableViewCell.h"

@implementation SelectWatchTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mHeadView = [[NetImageView alloc] initWithFrame:CGRectMake(10, 5, 90, 45)];
        mHeadView.mImageType = TImageType_AutoSize;
        mHeadView.mDefaultImage = [UIImage imageNamed:@"默认图（90x45）.jpg"];
        [self.contentView addSubview:mHeadView];
        
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 90, 25)];
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:mlbName];
        
        mlbEnName = [[UILabel alloc] initWithFrame:CGRectMake(110, 30, 180, 15)];
        mlbEnName.backgroundColor = [UIColor clearColor];
        mlbEnName.font = [UIFont systemFontOfSize:13];
        mlbEnName.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbEnName];
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


- (void)ShowContent:(NSDictionary *)dict {
    NSString *imagename = [dict objectForKey:@"1"];
    [mHeadView GetImageByStr:imagename];
    mlbName.text = [dict objectForKey:@"2"];
    mlbEnName.text = [dict objectForKey:@"3"];
}

@end
