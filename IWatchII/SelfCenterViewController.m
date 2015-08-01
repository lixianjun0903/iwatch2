//
//  SelfCenterViewController.m
//  IWatchII
//
//  Created by mac on 14-11-17.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SelfCenterViewController.h"
#import "NetImageView.h"
@interface SelfCenterViewController ()
{
    NetImageView *imageView;
    UILabel *nameLabel;
    UILabel *goldNum;
    UILabel *zhimingdu;
    UILabel *weiwang;
    UILabel *jifen;
    UILabel *jinghuatie;
    UILabel *tieziNum;
    
}
@end

@implementation SelfCenterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"个人中心";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)GoBack {
    //    if (delegate && OnGoBack) {
    //        [delegate performSelector:OnGoBack withObject:self];
    //    }
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
-(void)makeUI
{
    
    UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    scroll.contentSize = CGSizeMake(self.view.frame.size.width, 380);
    [self.view addSubview:scroll];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, self.view.frame.size.width, 120)];
    topView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:topView];
    imageView = [[NetImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 10, 60, 60)];
    imageView.layer.cornerRadius = 30;
    imageView.clipsToBounds = YES;
    imageView.mDefaultImage = [UIImage imageNamed:@"wax_05.png"];
    [topView addSubview:imageView];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 30, 100, 20)];
    headLabel.text = @"头像";
    headLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:headLabel];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 10, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line1];
    UILabel *nickLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, 100, 20)];
    nickLabel.text = @"昵称";
    nickLabel.font = [UIFont systemFontOfSize:15];
    [topView addSubview:nickLabel];
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 90, 120, 20)];
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.textAlignment = NSTextAlignmentRight;
    [topView addSubview:nameLabel];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 135, self.view.frame.size.width, 240)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:bottomView];
    
    UILabel *goldLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    goldLabel.text = @"金币";
    goldLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:goldLabel];
    
    goldNum = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 10, 120, 20)
                 ];
    goldNum.font = [UIFont systemFontOfSize:15];
    goldNum.textAlignment = NSTextAlignmentRight;
    goldNum.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:goldNum];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, 40, self.view.frame.size.width - 10, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line2];
    
    UILabel *zhimingduLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 100, 20)];
    zhimingduLabel.text = @"社区知名度";
    zhimingduLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:zhimingduLabel];
    
    zhimingdu = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 50, 120, 20)
               ];
    zhimingdu.font = [UIFont systemFontOfSize:15];
    zhimingdu.textAlignment = NSTextAlignmentRight;
    zhimingdu.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:zhimingdu];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(10, 80, self.view.frame.size.width - 10, 0.5)];
    line3.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line3];
    
    UILabel *weiwangLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 90, 100, 20)];
    weiwangLabel.text = @"威望";
    weiwangLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:weiwangLabel];
    
    weiwang = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 90, 120, 20)
                 ];
    weiwang.font = [UIFont systemFontOfSize:15];
    weiwang.textAlignment = NSTextAlignmentRight;
    weiwang.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:weiwang];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(10, 120, self.view.frame.size.width - 10, 0.5)];
    line4.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line4];
    
    UILabel *jifenLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 130, 100, 20)];
    jifenLabel.text = @"积分";
    jifenLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:jifenLabel];
    
    jifen = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 130, 120, 20)
               ];
    jifen.font = [UIFont systemFontOfSize:15];
    jifen.textAlignment = NSTextAlignmentRight;
    jifen.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:jifen];
    
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(10, 160, self.view.frame.size.width - 10, 0.5)];
    line5.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line5];
    
    UILabel *jinghuatieLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 170, 100, 20)];
    jinghuatieLabel.text = @"精华帖";
    jinghuatieLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:jinghuatieLabel];
    
    jinghuatie = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 170, 120, 20)
             ];
    jinghuatie.font = [UIFont systemFontOfSize:15];
    jinghuatie.textAlignment = NSTextAlignmentRight;
    jinghuatie.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:jinghuatie];
    
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(10, 200, self.view.frame.size.width - 10, 0.5)];
    line6.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line6];
    
    UILabel *tieziNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 210, 100, 20)];
    tieziNumLabel.text = @"帖子数目";
    tieziNumLabel.font = [UIFont systemFontOfSize:15];
    [bottomView addSubview:tieziNumLabel];
    
    tieziNum = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 130, 210, 120, 20)
                  ];
    tieziNum.font = [UIFont systemFontOfSize:15];
    tieziNum.textAlignment = NSTextAlignmentRight;
    tieziNum.textColor = [UIColor lightGrayColor];
    [bottomView addSubview:tieziNum];
}
-(void)loadData
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user objectForKey:@"userID"];
    
    [imageView GetImageByStr:[NSString stringWithFormat:@"http://www.iwatch365.com/iwatchcenter/avatar.php?uid=%@&size=middle",userID]];
    nameLabel.text = self.dataDic[@"username"];
    goldNum.text= self.dataDic[@"extcredits2"];
    zhimingdu.text = self.dataDic[@"extcredits3"];
    weiwang.text = self.dataDic[@"extcredits1"];
    jifen.text = self.dataDic[@"credits "];
    jinghuatie.text = self.dataDic[@"digestposts"];
    tieziNum.text = self.dataDic[@"posts "];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
