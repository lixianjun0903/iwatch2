//
//  SixinTableViewCell.m
//  IWatchII
//
//  Created by xll on 14/11/26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SixinTableViewCell.h"

@implementation SixinTableViewCell

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
    titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 200, 20)];
    titleLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:titleLabel];
    
    authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 220, 30, 200, 15)];
    authorLabel.textColor = [UIColor lightGrayColor];
    authorLabel.textAlignment = NSTextAlignmentRight;
    authorLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:authorLabel];
}
-(void)config:(NSDictionary *)dic
{
    titleLabel.text = dic[@"subject"];
    authorLabel.text = dic[@"lastauthor"];
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
