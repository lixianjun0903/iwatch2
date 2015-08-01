//
//  TieZiTableViewCell.m
//  IWatchII
//
//  Created by mac on 14-11-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TieZiTableViewCell.h"

@implementation TieZiTableViewCell

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
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20)];
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    
    time = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, self.contentView.frame.size.width - 20, 15)];
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:time];
}
-(void)config:(NSDictionary *)dic
{
    title.text = dic[@"1"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dic[@"2"] intValue]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *str = [formatter stringFromDate:date];
    time.text = str;
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
