//
//  SeriesDetailTableViewCell.m
//  IWatchII
//
//  Created by mac on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SeriesDetailTableViewCell.h"

@implementation SeriesDetailTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
        // Initialization code
    }
    return self;
}
-(void)makeUI
{
//    self.backgroundColor = [UIColor colorWithRed:246 / 256.0 green:246 / 256.0 blue:246 / 256.0 alpha:1];
    imageView = [[NetImageView alloc]initWithFrame:CGRectMake(12, 5, 68, 70)];
    imageView.mDefaultImage = [UIImage imageNamed:@"brand68.jpg"];
    imageView.mImageType = TImageType_AutoSize;
    [self.contentView addSubview:imageView];
    title = [[UILabel alloc]initWithFrame:CGRectMake(12 + imageView.frame.size.width + 12, 4, self.contentView.frame.size.width - 12 - 68 - 12 - 12, 40)];
    title.textAlignment = NSTextAlignmentLeft;
    title.numberOfLines = 0;
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    
    desc = [[UILabel alloc]initWithFrame:CGRectMake(12 + imageView.frame.size.width + 12, 42, self.contentView.frame.size.width - 12 - 68 - 12 - 12, 15)];
    desc.font = [UIFont systemFontOfSize:13];
    desc.textAlignment = NSTextAlignmentLeft;
    desc.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:desc];
    
    priceLab = [[UILabel alloc]initWithFrame:CGRectMake(12 + imageView.frame.size.width + 12, 60, self.contentView.frame.size.width - 12 - 68 - 12 - 12, 19)];
    priceLab.font = [UIFont systemFontOfSize:15];
    priceLab.textColor = [UIColor redColor];
    priceLab.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:priceLab];
    rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightImageView.center = CGPointMake(self.contentView.frame.size.width - 30, 44);
    rightImageView.image = [UIImage imageNamed:@"3_10.png"];
//    [self.contentView addSubview:rightImageView];
    
}
-(void)showContent:(NSDictionary *)dic
{
    NSString *imageName = dic[@"1"];
    [imageView GetImageByStr:imageName];
    title.text = dic[@"2"];
    desc.text = dic[@"3"];
    priceLab.text = [NSString stringWithFormat:@"￥%@",dic[@"price"]];
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
