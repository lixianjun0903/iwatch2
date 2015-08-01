

//
//  SearchResultTableViewCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SearchResultTableViewCell.h"

@implementation SearchResultTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        mHeadView = [[NetImageView alloc] initWithFrame:CGRectMake(13, 10, 65, 65)];
        mHeadView.mImageType = TImageType_AutoSize;
        mHeadView.mDefaultImage = [UIImage imageNamed:@"65@2x.png"];
        [self.contentView addSubview:mHeadView];
        mlbName = [[UILabel alloc] initWithFrame:CGRectMake(90, 8, 200, 30)];
        mlbName.backgroundColor = [UIColor clearColor];
        mlbName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:mlbName];
        
        mlbDesc = [[UILabel alloc] initWithFrame:CGRectMake(90, 38, 200, 16)];
        mlbDesc.backgroundColor = [UIColor clearColor];
        mlbDesc.font = [UIFont systemFontOfSize:13];
        mlbDesc.textColor = [UIColor grayColor];
        [self.contentView addSubview:mlbDesc];
        
        mlbPrice = [[UILabel alloc] initWithFrame:CGRectMake(90, 60, 200, 16)];
        mlbPrice.backgroundColor = [UIColor clearColor];
        mlbPrice.font = [UIFont systemFontOfSize:15];
        mlbPrice.textColor = [UIColor colorWithRed:0.75 green:0.0 blue:0.0 alpha:1.0];
        [self.contentView addSubview:mlbPrice];
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
    [mHeadView GetImageByStr:dict[@"thumb"]];
    mlbName.text = [dict objectForKey:@"title"];
    mlbDesc.text = [dict objectForKey:@"description"];
    mlbPrice.text = [NSString stringWithFormat:@"￥%@", [dict objectForKey:@"price"]];
}

@end
