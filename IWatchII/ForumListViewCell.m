//
//  ForumListViewCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ForumListViewCell.h"

@implementation ForumListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        imageView.image = [UIImage imageNamed:@"f_detail41"];
//        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//        [self.contentView addSubview:imageView];
//
        jinghuaImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 50, 6, 50, 50)];
        jinghuaImage.image = [UIImage imageNamed:@"推荐64x64"];
        [self.contentView addSubview:jinghuaImage];
        jinghuaImage.hidden = YES;
        
        arrowImage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 20, 14)];
        arrowImage.image = [UIImage imageNamed:@"置顶图标2...png"];
        [self.contentView addSubview:arrowImage];
        arrowImage.hidden = YES;
        mlbTitle = [[UILabel alloc] initWithFrame:CGRectMake(13, 6, self.contentView.frame.size.width / 9 *8, 40)];
//        mlbTitle.font = [UIFont boldSystemFontOfSize:14];
        mlbTitle.backgroundColor = [UIColor clearColor];
        mlbTitle.numberOfLines = 2;
        mlbTitle.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:mlbTitle];
        
        mlbTime = [[UILabel alloc] initWithFrame:CGRectMake(13, 47, 200, 17)];
        mlbTime.backgroundColor = [UIColor clearColor];
        mlbTime.textColor = [UIColor grayColor];
        mlbTime.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:mlbTime];
        
        mFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(100,47, 15, 13)];
        mFlagView.image = [UIImage imageNamed:@"f_imageflag"];
        [self.contentView addSubview:mFlagView];
        
        mlbCount = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-210, 47, 200, 17)];
        mlbCount.backgroundColor = [UIColor clearColor];
        mlbCount.textColor = [UIColor grayColor];
        mlbCount.font = [UIFont systemFontOfSize:13];
        mlbCount.textAlignment = UITextAlignmentRight;
        [self.contentView addSubview:mlbCount];
        
        
        
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

- (void)LoadContent:(ForumListInfo *)info {
    mlbTitle.text = info.subject;
    
    NSString * str = info.subject;
    CGSize size =[self getSize:str];
    
    
    if ([info.displayorder isEqualToString:@"3"]) {
        arrowImage.hidden = NO;
        arrowImage.image = [UIImage imageNamed:@"betop_1.png"];
        if (size.height<20) {
            arrowImage.frame = CGRectMake(5, 19, 20, 14);
        }
        else
        {
            arrowImage.frame = CGRectMake(5, 10, 20, 14);
        }
        mlbTitle.frame = CGRectMake(27, 6, self.contentView.frame.size.width / 7 *6, 40);
        mlbTime.frame = CGRectMake(25, 45, 200, 17);
        mlbTitle.textColor = [UIColor redColor];
    }
    else if ([info.displayorder isEqualToString:@"1"]) {
        arrowImage.hidden = NO;
        arrowImage.image = [UIImage imageNamed:@"betop_2.png"];
        mlbTitle.frame = CGRectMake(27, 6, self.contentView.frame.size.width / 7 *6, 40);
        if (size.height<20) {
            arrowImage.frame = CGRectMake(5, 19, 20, 14);
        }
        else
        {
            arrowImage.frame = CGRectMake(5, 10, 20, 14);
        }
        mlbTime.frame = CGRectMake(25, 45, 200, 17);
        mlbTitle.textColor = [UIColor redColor];
    }
    else
    {
        arrowImage.hidden = YES;
        mlbTitle.frame = CGRectMake(13, 6, self.contentView.frame.size.width / 9 *8, 40);
        mlbTime.frame = CGRectMake(13, 47, 200, 17);
        mlbTitle.textColor = [UIColor blackColor];
    }
    NSString *time = [UserInfoManager GetFormatDateByInterval:[info.lastpost intValue]];
    if (self.flag == 18) {
        mlbTime.text = [NSString stringWithFormat:@"发表: %@", time];
    }
    else
    {
        mlbTime.text = [NSString stringWithFormat:@"最后: %@", time];
    }
    CGSize calcSize = [mlbTime.text sizeWithFont:mlbTime.font forWidth:220 lineBreakMode:NSLineBreakByCharWrapping];
    if (![info.attachment isEqualToString:@"0"]) {
        mFlagView.frame = CGRectMake(mlbTime.frame.origin.x+calcSize.width+10, 47, 15, 13);
        mFlagView.hidden = NO;
    }
    else
    {
        mFlagView.frame = CGRectMake(mlbTime.frame.origin.x+calcSize.width+10, 47, 15, 13);
        mFlagView.hidden = YES;
    }
    
    
    mlbCount.text = [NSString stringWithFormat:@"%@  %@回", info.author, info.replies];
    
    
    if (![info.digest isEqualToString:@"0"]) {
        jinghuaImage.hidden = NO;
    }
    else
    {
         jinghuaImage.hidden = YES;
    }
    
    if ([info.highlight intValue]>= 0 &&[info.highlight intValue]<= 10) {
        mlbTitle.textColor = [UIColor blackColor];
    }
    else if([info.highlight intValue]> 10 &&[info.highlight intValue]<= 20)
    {
        mlbTitle.textColor = [UIColor colorWithRed:0.16f green:0.45f blue:0.08f alpha:1.00f];
    }
    else if([info.highlight intValue]> 20 &&[info.highlight intValue]<= 30)
    {
        mlbTitle.textColor = [UIColor purpleColor];
    }
    else if([info.highlight intValue]> 30 &&[info.highlight intValue]<= 40)
    {
        mlbTitle.textColor = [UIColor orangeColor];
    }
    else if([info.highlight intValue]> 40 &&[info.highlight intValue]<= 50)
    {
        mlbTitle.textColor = [UIColor redColor];
    }
    else if([info.highlight intValue]> 50 &&[info.highlight intValue]<= 60)
    {
        mlbTitle.textColor = [UIColor purpleColor];
    }
    else
    {
        mlbTitle.textColor = [UIColor blueColor];
    }
    
}
-(CGSize)getSize:(NSString *)str
{
    CGSize size;
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width / 7 *6, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:16]constrainedToSize:CGSizeMake(self.contentView.frame.size.width / 7 *6, 1000)];
    }
    return size;
}
@end
