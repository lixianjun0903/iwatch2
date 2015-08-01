//
//  LoginViewController.m
//  IWatchII
//
//  Created by mac on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LoginViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "SettingViewController.h"
#import "RegistViewController.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *passWD;
    UITextField *account;
    BOOL isSuccess;
    
//    UIActivityIndicatorView *mActView;

}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation LoginViewController

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
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN object:nil];
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isSuccess  = NO;
    self.title = @"登录";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    [self makeUI];
    
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 120)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderWidth = 0.5;
    view.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [self.view addSubview:view];
    
    UIImageView *accountIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    accountIcon.image = [UIImage imageNamed:@"1_13.png"];
    [view addSubview:accountIcon];
    
    account = [[UITextField alloc]initWithFrame:CGRectMake(50, 10, 240, 40)];
    account.placeholder= @"请输入登陆账号";
    account.delegate = self;
    account.returnKeyType = UIReturnKeyNext;
    [view addSubview:account];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 60, self.view.frame.size.width - 20, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [view addSubview:line];
    
    UIImageView *passWDIcon = [[UIImageView alloc]initWithFrame:CGRectMake(20, 80, 20, 20)];
    passWDIcon.image = [UIImage imageNamed:@"1_15.png"];
    [view addSubview:passWDIcon];
    
    
    passWD = [[UITextField alloc]initWithFrame:CGRectMake(50, 70, 240, 40)];
    passWD.placeholder= @"请输入登陆密码";
    passWD.delegate =self;
    [passWD setSecureTextEntry:YES];
    passWD.returnKeyType = UIReturnKeyGo;
    [view addSubview:passWD];
    
    UIButton *loginBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 150, self.view.frame.size.width - 40, 50)];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"43a_05.png"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(loginBtn) forControlEvents:UIControlEventTouchUpInside];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:loginBtn];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    
    UIButton *registBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 210, self.view.frame.size.width - 40, 50)];
    [registBtn setBackgroundImage:[UIImage imageNamed:@"43a_05.png"] forState:UIControlStateNormal];
    [registBtn addTarget:self action:@selector(registBtn) forControlEvents:UIControlEventTouchUpInside];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.view addSubview:registBtn];
}
-(void)registBtn
{
    RegistViewController *vc = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //判断是谁触发
    if(textField == account)
    {
        [passWD becomeFirstResponder];
    }else
    {
        //开始登录
        [self loginBtn];
    }
    return YES;
}

-(void)tap
{
    [self.view endEditing:YES];
}
-(void)loginBtn
{
    if(account.text.length > 0&&passWD.text.length > 0)
    {
        //收回键盘
        [self.view endEditing:YES];
        //执行登录
        [self StartLoginName:account.text PassWD:passWD.text];
    }
    else
    {
        UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写完整的用户名密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [av show];
    }

}
-(void)StartLoginName:(NSString *)username PassWD:(NSString *)passwd
{
    
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.net/json/iphone/json.php?t=301&fid=username&p=password
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=301&fid=%@&p=%@", SERVER_URL,username,passwd];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
//    mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    mActView.color = [UIColor blackColor];
//    mActView.frame = CGRectMake((self.view.frame.size.width-30)/2, (self.view.frame.size.height-30)/2, 30, 30);
//    mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//    mActView.hidesWhenStopped = YES;
//    [mActView startAnimating];
//    [self.view addSubview:mActView];

    
    [_mDownManager GetImageByStr:urlstr];
    
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSNumber *num  =  dict[@"success"];
        if ([num intValue] == 1) {
           isSuccess = YES;
            NSString *userID = dict[@"uid"];
            //首先本地存储用户名密码
            NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
            [user setObject:account.text forKey:@"userName"];
            [user setObject:passWD.text forKey:@"passWord"];
            [user setObject:userID forKey:@"userID"];
            [user synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN object:nil];
            self.mDownManager.delegate = nil;
//            [mActView stopAnimating];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
//            [mActView stopAnimating];
            UIAlertView * av = [[UIAlertView alloc] initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [av show];
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
