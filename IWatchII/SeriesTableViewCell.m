//
//  SeriesTableViewCell.m
//  IWatchII
//
//  Created by mac on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SeriesTableViewCell.h"

@implementation SeriesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
//    self.backgroundColor = [UIColor colorWithRed:246 / 256.0 green:246 / 256.0 blue:246 / 256.0 alpha:1];
    imageView = [[NetImageView alloc]initWithFrame:CGRectMake(12, 5, 68, 68)];
    imageView.mImageType = TImageType_AutoSize;
    imageView.mDefaultImage = [UIImage imageNamed:@"brand68.jpg"];
    [self.contentView addSubview:imageView];
    title = [[UILabel alloc]initWithFrame:CGRectMake(12 + imageView.frame.size.width + 12, 15, 200, 20)];
    title.textAlignment = NSTextAlignmentLeft;
    title.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:title];
    count = [[UILabel alloc]initWithFrame:CGRectMake(12 + imageView.frame.size.width + 12, 43, 100, 15)];
    count.textAlignment = NSTextAlignmentLeft;
    count.textColor = [UIColor lightGrayColor];
    count.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:count];
    rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightImageView.center = CGPointMake(self.contentView.frame.size.width - 30, 44);
    rightImageView.image = [UIImage imageNamed:@"3_10.png"];
//    [self.contentView addSubview:rightImageView];
  
}
- (void)ShowContent:(NSDictionary *)dic
{
    NSString *imagename = [dic objectForKey:@"1"];
    [imageView GetImageByStr:imagename];
    
    title.text = [dic objectForKey:@"2"];
    count.text = [NSString stringWithFormat:@"%@款",dic[@"num"]];
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
