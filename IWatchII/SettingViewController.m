//
//  SettingViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SettingViewController.h"
#import "NetImageView.h"
#import "SysSettingViewController.h"
#import "LoginViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "TieziViewController.h"
#import "ShoucangbasViewController.h"
#import "SelfCenterViewController.h"
#import "SixinViewController.h"


#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@interface SettingViewController ()<UIAlertViewDelegate,UMSocialUIDelegate,UIScrollViewDelegate>
{
    NetImageView *headImageView;
    UILabel *name;
    NSString *userID;
    UIButton *loginBtn;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation SettingViewController

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
    self.title = @"设置";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1.0];
    [self makeUI];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:LOGIN object:nil];
}
-(void)refresh
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userid = [user objectForKey:@"userID"];
    if (userid == nil) {
        headImageView.mDefaultImage = [UIImage imageNamed:@"默认人物头像.jpg"];
        [headImageView GetImageByStr:[NSString stringWithFormat:@"1"]];
        name.text = @"请登录";
    }
    [self loadData];
}

-(void)loadData
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    userID = [user objectForKey:@"userID"];
    if (userID == nil) {
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        return;
    }
    else
    {
        [loginBtn setTitle:@"退出" forState:UIControlStateNormal];
    }

    if (_mDownManager) {
        return;
    }
    //www.iwatch365.net/json/iphone/json.php?t=3&fid=fid
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=3&fid=%@", SERVER_URL,userID];
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
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:array[0]];
            [self reloadData];
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)reloadData
{
    [headImageView GetImageByStr:[NSString stringWithFormat:@"1"]];
    name.text = @"请登录";
    [headImageView GetImageByStr:[NSString stringWithFormat:@"http://www.iwatch365.com/iwatchcenter/avatar.php?uid=%@&size=middle",userID]];
    name.text = self.dataDic[@"username"];
    NSLog(@"%@",userID);
    
    
}
-(void)makeUI
{
    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.delegate = self;
    mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 500 + 64 + 49);
    [self.view addSubview:mainScroll];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
    topView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"wax_02.png"]];
    [mainScroll addSubview:topView];
    headImageView = [[NetImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 50, 10, 100, 100)];
    headImageView.clipsToBounds = YES;
    headImageView.layer.cornerRadius = 50;
    headImageView.mDefaultImage = [UIImage imageNamed:@"默认人物头像.jpg"];
    [headImageView GetImageByStr:[NSString stringWithFormat:@"1"]];
    [headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)]];
    [topView addSubview:headImageView];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 - 100, 110, 200, 40)];
    name.text = @"请登录";
    name.textAlignment = NSTextAlignmentCenter;
    name.textColor = [UIColor whiteColor];
    name.font = [UIFont systemFontOfSize:15];
    [topView addSubview:name];
    
    UIView *FirstView = [[UIView alloc]initWithFrame:CGRectMake(0, 170, self.view.frame.size.width, 150)];
    FirstView.layer.borderWidth = 0.5;
    FirstView.backgroundColor = [UIColor whiteColor];
    FirstView.layer.borderColor = [[UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1]CGColor];
    [mainScroll addSubview:FirstView];
    
    UILabel *sixin = [[UILabel alloc]initWithFrame:CGRectMake(60, 16, 80, 18)];
    sixin.text = @"我的私信";
    sixin.font = [UIFont boldSystemFontOfSize:18];
    [FirstView addSubview:sixin];
    
    UIImageView *sixinIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
    sixinIcon.image = [UIImage imageNamed:@"wax_10.png"];
    sixinIcon.layer.cornerRadius = 3;
    sixinIcon.clipsToBounds = YES;
    [FirstView addSubview:sixinIcon];

    
    UIImageView *rightView1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 16, 10, 18)];
    rightView1.image = [UIImage imageNamed:@"3z_03.png"];
    [FirstView addSubview:rightView1];
    UIImageView *rightView2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 66, 10, 18)];
    rightView2.image = [UIImage imageNamed:@"3z_03.png"];
    [FirstView addSubview:rightView2];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 50, self.view.frame.size.width - 15, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    [FirstView addSubview:line];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(15, 100, self.view.frame.size.width - 15, 0.5)];
    line2.backgroundColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    [FirstView addSubview:line2];
    
    UILabel *tiezi = [[UILabel alloc]initWithFrame:CGRectMake(60, 66, 80, 18)];
    tiezi.text = @"我的帖子";
    tiezi.font = [UIFont boldSystemFontOfSize:18];
    [FirstView addSubview:tiezi];
    
    UIImageView *tieziIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 65, 20, 20)];
    tieziIcon.image = [UIImage imageNamed:@"wax_13.png"];
    tieziIcon.layer.cornerRadius = 3;
    tieziIcon.clipsToBounds = YES;
    [FirstView addSubview:tieziIcon];
    
    
    UILabel *shoucang = [[UILabel alloc]initWithFrame:CGRectMake(60, 116, 80, 18)];
    shoucang.text = @"我的收藏";
    shoucang.font = [UIFont boldSystemFontOfSize:18];
    [FirstView addSubview:shoucang];
    
    UIImageView *shoucangIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 115, 20, 20)];
    shoucangIcon.image = [UIImage imageNamed:@"收藏了.png"];
    shoucangIcon.layer.cornerRadius = 3;
    shoucangIcon.clipsToBounds = YES;
    [FirstView addSubview:shoucangIcon];

    UIImageView *rightView5 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 116, 10, 18)];
    rightView5.image = [UIImage imageNamed:@"3z_03.png"];
    [FirstView addSubview:rightView5];
    
    
    
    UIView *SecView = [[UIView alloc]initWithFrame:CGRectMake(0, 325, self.view.frame.size.width, 100)];
    SecView.layer.borderWidth = 0.5;
    SecView.backgroundColor = [UIColor whiteColor];
    SecView.layer.borderColor = [[UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1]CGColor];
    [mainScroll addSubview:SecView];
    
    UILabel *share = [[UILabel alloc]initWithFrame:CGRectMake(60, 16, 80, 18)];
    share.text = @"分享好友";
    share.font = [UIFont boldSystemFontOfSize:18];
    [SecView addSubview:share];
    
    UIImageView *shareIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 15, 20, 20)];
    shareIcon.image = [UIImage imageNamed:@"wax_15.png"];
    shareIcon.layer.cornerRadius = 3;
    shareIcon.clipsToBounds = YES;
    [SecView addSubview:shareIcon];
    
    UIImageView *rightView3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 16, 10, 18)];
    rightView3.image = [UIImage imageNamed:@"3z_03.png"];
    [SecView addSubview:rightView3];
    UIImageView *rightView4 = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 66, 10, 18)];
    rightView4.image = [UIImage imageNamed:@"3z_03.png"];
    [SecView addSubview:rightView4];
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 50, self.view.frame.size.width - 15, 0.5)];
    line1.backgroundColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    [SecView addSubview:line1];
    
    UILabel *sysset = [[UILabel alloc]initWithFrame:CGRectMake(60, 66, 80, 18)];
    sysset.text = @"系统设置";
    sysset.font = [UIFont boldSystemFontOfSize:18];
    [SecView addSubview:sysset];
    
    UIImageView *syssetIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 65, 20, 20)];
    syssetIcon.image = [UIImage imageNamed:@"wax_17.png"];
    syssetIcon.layer.cornerRadius = 3;
    syssetIcon.clipsToBounds = YES;
    [SecView addSubview:syssetIcon];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    btn1.tag = 100;
    [btn1 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:btn1];
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    btn2.tag = 101;
    [btn2 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:btn2];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 50)];
    btn.tag = 102;
    [btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [FirstView addSubview:btn];

    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    btn3.tag = 103;
    [btn3 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [SecView addSubview:btn3];
    UIButton *btn4 = [[UIButton alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
    btn4.tag = 104;
    [btn4 addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    [SecView addSubview:btn4];
    
    
    
    loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 445, self.view.frame.size.width, 50)];
    [loginBtn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.tag = 105;
    [loginBtn setBackgroundColor:[UIColor whiteColor]];
    [loginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [mainScroll addSubview:loginBtn];
    
    
}
-(void)tap
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    userID = [user objectForKey:@"userID"];
    if (!userID) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        SelfCenterViewController *vc = [[SelfCenterViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        vc.dataDic = [NSDictionary dictionaryWithDictionary:self.dataDic];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)btn:(UIButton *)btn
{
    int index = btn.tag - 100;
    switch (index) {
        case 0:
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            userID = [user objectForKey:@"userID"];
            if (!userID) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                SixinViewController *vc = [[SixinViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }

            
        }
            break;
        case 1:
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            userID = [user objectForKey:@"userID"];
            if (!userID) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                TieziViewController *vc = [[TieziViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 2:
        {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            userID = [user objectForKey:@"userID"];
            if (!userID) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed =YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                ShoucangbasViewController *vc = [[ShoucangbasViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 3:
        {
            [self.tabBarController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.window.frame.size.height +49)];
            
            UIView *blackBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height+64)];
            blackBGView.tag = 60;
            blackBGView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
            [self.tabBarController.view addSubview:blackBGView];
             [blackBGView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow)]];
            
            
            
            UIView *view = (UIView *)[self.tabBarController.view viewWithTag:50];
            if (view) {
                return;
            }
            view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height+64, self.view.frame.size.width, 140)];
            [self.tabBarController.view addSubview:view];
            view.tag = 50;
            view.userInteractionEnabled = YES;
            view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
            
            [UIView animateWithDuration:0.3 animations:^{
                view.frame = CGRectMake(0, self.view.frame.size.height - 140+64, self.view.frame.size.width, 140);
            }];
            
            
         float   btnWidth = self.view.frame.size.width / 4;
            NSArray *picArray = @[@"新浪微博.png",@"腾讯微博.png"];
             NSArray *tArray = @[@"新浪微博",@"腾讯微博"];
            for (int i = 0; i < picArray.count; i++) {
                UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(15 +i * btnWidth, 10, 50, 50)];
                btn.layer.cornerRadius = 5;
                btn.clipsToBounds = YES;
                btn.tag = 1000 + i;
                [btn setBackgroundImage:[UIImage imageNamed:picArray[i]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(pClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:btn];
                UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(i * btnWidth , 60, btnWidth, 30)];
                l.textColor = [UIColor lightGrayColor];
                l.text =tArray[i];
                l.textAlignment = NSTextAlignmentCenter;
                l.font = [UIFont systemFontOfSize:12];
                [view addSubview:l];
            }
            float width_wx = 0;
            if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
            {
                UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 + btnWidth * 2 , 10, 50, 50)];
                wxBtn.layer.cornerRadius = 5;
                wxBtn.clipsToBounds = YES;
                wxBtn.tag = 10000;
                [wxBtn setBackgroundImage:[UIImage imageNamed:@"朋友圈.png"] forState:UIControlStateNormal];
                [wxBtn addTarget:self action:@selector(pClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:wxBtn];
                UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth * 2 , 60, btnWidth, 30)];
                l.textColor = [UIColor lightGrayColor];
                l.text =@"朋友圈";
                l.textAlignment = NSTextAlignmentCenter;
                l.font = [UIFont systemFontOfSize:12];
                [view addSubview:l];
                width_wx = btnWidth;
            }
            else
            {
                
            }
            float witdh_qq = 0;
            if ([QQApi isQQInstalled]&&[QQApi isQQSupportApi]) {
                UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(15 + btnWidth*2 + width_wx , 10, 50, 50)];
                wxBtn.layer.cornerRadius = 5;
                wxBtn.clipsToBounds = YES;
                wxBtn.tag = 10001;
                [wxBtn setBackgroundImage:[UIImage imageNamed:@"qq空间.png"] forState:UIControlStateNormal];
                [wxBtn addTarget:self action:@selector(pClick:) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:wxBtn];
                UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(btnWidth*2 + width_wx , 60, btnWidth, 30)];
                l.textColor = [UIColor lightGrayColor];
                l.text =@"QQ空间";
                l.textAlignment = NSTextAlignmentCenter;
                l.font = [UIFont systemFontOfSize:12];
                [view addSubview:l];
                witdh_qq = btnWidth;
            }
            else
            {
                
            }
            UIButton *quxiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, view.frame.size.height-40, view.frame.size.width, 40)];
            [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
            [quxiaoBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            quxiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
            [quxiaoBtn setBackgroundColor:[UIColor lightGrayColor]];
            [quxiaoBtn addTarget:self action:@selector(dddd) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:quxiaoBtn];
        }
            break;
        case 4:
        {
            SysSettingViewController *vc =[[SysSettingViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:
        {
            if (userID == nil) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"你打算退出此账号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
                [alert show];
            }
        }
            break;
        default:
            break;
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        userID = nil;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userName"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"passWord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tapShadow];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pClick:(UIButton *)sender
{
    [self tapShadow];
    NSString *shareText =[NSString stringWithFormat:@"爱表族这个软件不错，如果你也喜爱腕表，就快加入爱表一族吧"];
    int index = sender.tag;
    UIImage *imagea = [UIImage imageNamed:@"fenxianglogo@2x.png"];
    if (index == 1000) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareText image:imagea location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    else if (index == 1001)
    {
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imagea socialUIDelegate:nil];     //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
    else if (index == 10000)
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareText image:imagea location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    else if (index == 10001)
    {
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imagea socialUIDelegate:nil];     //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
    }
}
-(void)tapShadow
{
    UIView *view = (UIView *)[self.tabBarController.view viewWithTag:50];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    
    
    UIView *blackBGView = [self.tabBarController.view viewWithTag:60];
    [blackBGView removeFromSuperview];
    [self.tabBarController.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.window.frame.size.height)];
}
-(void)dddd
{
    [self tapShadow];
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
