//
//  DealerTableViewCell.m
//  IWatchII
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "DealerTableViewCell.h"
#import "MapViewController.h"
@implementation DealerTableViewCell

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
    dealerName  = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, self.contentView.frame.size.width - 24, 20)];
    dealerName.textAlignment = NSTextAlignmentLeft;
    dealerName.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:dealerName];
    
    descLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 37, self.contentView.frame.size.width - 24, 15)];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:descLabel];
    
    detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 10 - 60, 15, 50, 32)];
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailBtn setBackgroundImage:[UIImage imageNamed:@"btn.png"] forState:UIControlStateNormal];
    detailBtn.layer.cornerRadius = 5;
    detailBtn.clipsToBounds = YES;
//    detailBtn.titleLabel.font = [UIFont systemFontOfSize:20];
//    [self.contentView addSubview:detailBtn];
    
    
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, 320, 122)];
    _bottomView.backgroundColor = [UIColor colorWithRed:223/256.0 green:223/256.0 blue:223/256.0 alpha:1];
    [self.contentView addSubview:_bottomView];
    UILabel * brand = [[UILabel alloc]initWithFrame:CGRectMake(20, 12, 50, 20)];
    brand.textAlignment = NSTextAlignmentLeft;
    brand.textColor = [UIColor lightGrayColor];
    brand.font = [UIFont systemFontOfSize:15];
    brand.text = @"主营：";
    [_bottomView addSubview:brand];
    brandName = [[UILabel alloc]initWithFrame:CGRectMake(70, 12, 200, 20)];
    brandName.textAlignment = NSTextAlignmentLeft;
    [_bottomView addSubview:brandName];
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 42, 50, 20)];
    phoneLabel.textAlignment = NSTextAlignmentLeft;
    phoneLabel.textColor = [UIColor lightGrayColor];
    phoneLabel.font = [UIFont systemFontOfSize:15];
    phoneLabel.text = @"电话：";
    [_bottomView addSubview:phoneLabel];
    phoneNum = [[UILabel alloc]initWithFrame:CGRectMake(70, 42, 200, 20)];
    phoneNum.textAlignment = NSTextAlignmentLeft;
    phoneNum.font = [UIFont systemFontOfSize:13];
    [_bottomView addSubview:phoneNum];
    
    UIView *phoneCallView = [[UIView alloc]initWithFrame:CGRectMake(30, 72, 120, 40)];
    phoneCallView.layer.cornerRadius = 5;
    phoneCallView.clipsToBounds = YES;
    phoneCallView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5_17.png"]];
    [_bottomView addSubview:phoneCallView];
    
    UIImageView *phoneIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 15, 15)];
    phoneIcon.image = [UIImage imageNamed:@"5_22.png"];
    [phoneCallView addSubview:phoneIcon];
    UIButton *phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(27, 0, 120 - 27, 40)];
    phoneBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [phoneBtn setTitle:@"拨打电话" forState:UIControlStateNormal];
    [phoneBtn addTarget:self action:@selector(phoneCall) forControlEvents:UIControlEventTouchUpInside];
    [phoneCallView addSubview:phoneBtn];
    
    UIView *mapView = [[UIView alloc]initWithFrame:CGRectMake(170, 72, 120, 40)];
    mapView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"5_19.png"]];
    mapView.layer.cornerRadius = 5;
    mapView.clipsToBounds = YES;
    [_bottomView addSubview:mapView];
    UIImageView *mapIcon = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 15, 15)];
    mapIcon.image = [UIImage imageNamed:@"5_25.png"];
    [mapView addSubview:mapIcon];
    UIButton *mapBtn = [[UIButton alloc]initWithFrame:CGRectMake(27, 0, 120 - 27, 40)];
    mapBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    mapBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [mapBtn setTitle:@"查看地图" forState:UIControlStateNormal];
    [mapBtn addTarget:self action:@selector(goMap) forControlEvents:UIControlEventTouchUpInside];
    [mapView addSubview:mapBtn];
    
}
-(void)goMap
{
    MapViewController *vc =[[MapViewController alloc]init];
    vc.placeMark =placemark;
    vc.dealerName =dealerName.text;
    [_delegate.navigationController pushViewController:vc animated:YES];
}
-(void)phoneCall
{
    UIWebView*callWebview =[[UIWebView alloc] init];
    
    NSArray *array = [phoneNum.text componentsSeparatedByString:@"；"];
    NSString *telUrl = [NSString stringWithFormat:@"tel:%@",array[0]];
    NSURL *telURL =[NSURL URLWithString:telUrl];
//    NSURL *telURL =[NSURL URLWithString:phoneNum.text];// 貌似tel:// 或者 tel: 都行
    [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
    //记得添加到view上
    [self.contentView addSubview:callWebview];
}
-(void)sendTitle:(NSString *)title
{
    if ([title isEqualToString:@"经销商列表"]) {
        brandName.text = dealerName.text;
    }
    else
    {
        brandName.text = title;
    }
    
}
-(void)showContent:(NSDictionary *)dic
{
    dealerName.text = dic[@"title"];
    descLabel.text = dic[@"title"];
    
    NSString *str = dic[@"lianxidianhua"];
    NSArray *array = [str componentsSeparatedByString:@"/"];
    
    phoneNum.text = array[0];
    placemark = dic[@"bddizhi"];
    
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
