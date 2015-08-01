//
//  RegistViewController.m
//  IWatchII
//
//  Created by mac on 14-11-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RegistViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
@interface RegistViewController ()
{
    UIWebView *webView;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation RegistViewController

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
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self createWebView];
    [self loadData];
    // Do any additional setup after loading the view.
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
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=200",SERVER_URL];
    [self StartLoading];
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
        [self loadWebView:dict[@"link"]];
    }
    
}
-(void)loadWebView:(NSString *)link
{
      [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
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

-(void)createWebView
{
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
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
