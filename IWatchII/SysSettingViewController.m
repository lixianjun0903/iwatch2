//
//  SysSettingViewController.m
//  IWatchII
//
//  Created by mac on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SysSettingViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
@interface SysSettingViewController ()<UIActionSheetDelegate>
{
    UILabel *lixianChosen;
    UILabel *banbenNum;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation SysSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)GoBack {
    //    if (delegate && OnGoBack) {
    //        [delegate performSelector:OnGoBack withObject:self];
    //    }
    self.mDownManager.delegate = nil;
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
-(void)makeUI
{
    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.contentSize = CGSizeMake(self.view.frame.size.width, 455 + 49 +64);
    [self.view addSubview:mainScroll];
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 80, 25)];
    title1.text = @"更新设置";
    title1.textColor = [UIColor darkGrayColor];
    [mainScroll addSubview:title1];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 150)];
    topView.userInteractionEnabled = YES;
    topView.backgroundColor = [UIColor whiteColor];
    topView.layer.borderWidth = 0.5;
    topView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [mainScroll addSubview:topView];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(15, 50, self.view.frame.size.width - 15, 0.5)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(15, 100, self.view.frame.size.width - 15, 0.5)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [topView addSubview:line2];
    
    UILabel *lixianPic = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 130,26 )];
    lixianPic.text = @"自动离线图片";
    lixianPic.font = [UIFont boldSystemFontOfSize:18];
    [topView addSubview:lixianPic];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    
    lixianChosen = [[UILabel alloc]initWithFrame:CGRectMake(180, 12, 100, 26)];
    lixianChosen.font =[UIFont systemFontOfSize:18];
    lixianChosen.textColor = [UIColor darkGrayColor];
    NSString *str =[user objectForKey:@"wifi"];
    if (str) {
        lixianChosen.text = str;
    }
    else
    {
        lixianChosen.text = @"任何网络";
    }
    
    [topView addSubview:lixianChosen];
    
    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 30, 15, 10, 18)];
    rightView.image = [UIImage imageNamed:@"3z_03.png"];
    [topView addSubview:rightView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 , 0, self.view.frame.size.width / 2, 50)];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    
    
    UILabel *qingliebiao = [[UILabel alloc]initWithFrame:CGRectMake(12, 62, 250,26 )];
    qingliebiao.text = @"下次启动时清除列表缓存";
    qingliebiao.font = [UIFont boldSystemFontOfSize:18];
    [topView addSubview:qingliebiao];
    
    
    NSString *str1 =  [user objectForKey:@"liebiao"];
    UISwitch *swith1 = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 60, 40, 30)];
    [swith1 addTarget:self action:@selector(switch1:) forControlEvents:UIControlEventValueChanged];
    if ([str1 isEqualToString:@"1"]) {
        swith1.on = YES;
    }
    [topView addSubview:swith1];
    
    UILabel *qingPic = [[UILabel alloc]initWithFrame:CGRectMake(12, 112, 250,26 )];
    qingPic.text = @"下次启动时清除图片缓存";
    qingPic.font = [UIFont boldSystemFontOfSize:18];
    [topView addSubview:qingPic];
    
    UISwitch *swith2 = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 70, 110, 40, 30)];
    [swith2 addTarget:self action:@selector(switch2:) forControlEvents:UIControlEventValueChanged];
    NSString  *str2 = [user objectForKey:@"tupian"];
    if ([str2 isEqualToString:@"1"]) {
        swith2.on = YES;
    }
    [topView addSubview:swith2];
    
    
    UILabel *title3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 220, 80, 25)];
    title3.text = @"关于";
    title3.textColor = [UIColor darkGrayColor];
    [mainScroll addSubview:title3];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 250, self.view.frame.size.width, 50)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.layer.borderWidth = 0.5;
    bottomView.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [mainScroll addSubview:bottomView];
    
    UILabel *banben = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 130,26 )];
    banben.text = @"检测版本";
    banben.font = [UIFont boldSystemFontOfSize:18];
    [bottomView addSubview:banben];
    
    banbenNum = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 40, 12, 40, 26)];
    banbenNum.font =[UIFont systemFontOfSize:16];
    banbenNum.textColor = [UIColor darkGrayColor];
    banbenNum.text = @"1.2";
    [bottomView addSubview:banbenNum];
    
    UIButton *checkBanben = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, bottomView.frame.size.width, 50)];
//    [checkBanben setBackgroundColor:[UIColor redColor]];
    [checkBanben addTarget:self action:@selector(checkbanben) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:checkBanben];
}
-(void)btnClick
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"自动离线设置" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"WI-FI可用时",@"任何网络",nil];
    
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        lixianChosen.text =@"WI-FI可用时";
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:lixianChosen.text forKey:@"wifi"];
        [user synchronize];
    }
    else if(buttonIndex == 1)
    {
        lixianChosen.text =@"任何网络";
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        [user setObject:lixianChosen.text forKey:@"wifi"];
        [user synchronize];
    }
}
-(void)switch1:(UISwitch *)switch1
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str ;
    if (switch1.on) {
        str= @"1";
    }
    else
    {
        str = @"0";
    }
    [user setObject:str forKey:@"liebiao"];
    [user synchronize];
}
-(void)switch2:(UISwitch *)switch2
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str ;
    if (switch2.on) {
        str= @"1";
    }
    else
    {
        str = @"0";
    }
    [user setObject:str forKey:@"tupian"];
    [user synchronize];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统设置";
    
    self.view.backgroundColor = [UIColor colorWithRed:234.0/256 green:234.0/256 blue:234.0/256 alpha:1];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)checkbanben
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.net/json/iphone/json.php?t=3&fid=fid
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=0", SERVER_URL];
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
       
            if ([banbenNum.text isEqualToString:dict[@"fid"]]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"已经是最新了";
                hud.margin = 10.f;
                hud.yOffset = 150.f;
                hud.removeFromSuperViewOnHide = YES;
                [hud hide:YES afterDelay:1.5];
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message: [NSString stringWithFormat:@"存有新版本%@了",dict[@"fid"]] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alert show];
            }
        
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络问题" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [av show];
}
- (void)Cancel {
    [self StopLoading];
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
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
