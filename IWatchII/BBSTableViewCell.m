//
//  BBSTableViewCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BBSTableViewCell.h"

@implementation BBSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mHeadView = [[NetImageView alloc] initWithFrame:CGRectMake(10, 5, 100, 62.5)];
        mHeadView.mImageType = TImageType_FullFill;
        mHeadView.mDefaultImage = [UIImage imageNamed:@"默认图（100x40）.jpg"];
        [self.contentView addSubview:mHeadView];
        
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 175, 30)];
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont boldSystemFontOfSize:17];
        [self.contentView addSubview:mlbName];
        
        mlbEnName = [[UILabel alloc] initWithFrame:CGRectMake(120, 5, 175, 30)];
        mlbEnName.backgroundColor = [UIColor clearColor];
        mlbEnName.font = [UIFont systemFontOfSize:13];
        mlbEnName.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbEnName];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(120, 45, 175, 16)];
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.font = [UIFont systemFontOfSize:13];
        mlbDesc.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbDesc];
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


- (void)ShowContent:(BBSListInfo *)info {
    
    [mHeadView GetImageByStr:info.icon];
    
    mlbName.text = info.name;
    mlbEnName.text = @"";
    
    CGSize calcsize = [mlbName.text sizeWithFont:mlbName.font];
    
    int iLeft = mlbName.frame.origin.x+calcsize.width+15;
    
    CGRect rect = mlbEnName.frame;
    rect.origin.x = iLeft;
    mlbEnName.frame = rect;
    mlbDesc.text = [NSString stringWithFormat:@"主题:%@  贴数:%@", info.threads, info.posts];
}

@end
