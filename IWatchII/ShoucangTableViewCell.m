//
//  ShoucangTableViewCell.m
//  IWatchII
//
//  Created by mac on 14-11-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShoucangTableViewCell.h"

@implementation ShoucangTableViewCell

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
    [self.contentView addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)]];
    self.contentView.userInteractionEnabled = YES;
    title = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width - 20, 20)];
    title.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:title];
    
    time = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, self.contentView.frame.size.width - 20, 15)];
    time.font = [UIFont systemFontOfSize:12];
    time.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:time];
}
-(void)longPress:(UIGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算删除此收藏？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
        [alert show];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteshoucang];
    }
}
-(void)deleteshoucang
{
    if (_mDownManager) {
        return;
    }
    //www.iwatch365.com/json/iphone/json.php?t=101&fid=11
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=101&fid=%@", SERVER_URL,self.dataDic[@"favid"]];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];

}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict[@"success"] stringValue]isEqualToString:@"1"]) {
            NSLog(@"OK");
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH object:nil];
        }
        else
        {
            
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}

-(void)config:(NSDictionary *)dic
{
    self.dataDic = [NSDictionary dictionaryWithDictionary:dic];
    title.text = dic[@"title"];
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
