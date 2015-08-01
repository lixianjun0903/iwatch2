//
//  ForumDetailViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//
#import "WXApi.h"
#import "UMSocialQQHandler.h"

#import "ForumDetailViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "huitieViewController.h"
#import "NetImageView.h"
#import "LoginViewController.h"
#import "huitieViewController.h"
//#import "UMSocial.h"

#import "SizeImageView.h"
#import "ShadowView.h"

#import "NJKWebViewProgress.h"


#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@interface ForumDetailViewController ()<UIGestureRecognizerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NJKWebViewProgressDelegate>
{
    BOOL isShoucang;
    UIWebView *webView;
    UILabel *pageNum;
    
    UIButton *allContent;
    UIButton *onlyLouzhu;
    int pageCount;
    
    int mpage1;
    int mpage2;
    int flag;
    UIView *BGView;
    NetImageView *netImageView;
    
    NetImageView *tempImageView;
    UIButton *shoucangBtn;
    NSString *textUrl;
    int MM;
//    UIActivityIndicatorView *mActView;
    UIActivityIndicatorView *actView;
    UILabel *pageForPic;
    UIScrollView *sc;
    
    UIButton *refreshBtn;
    
    int temppage1;
    int temppage2;
    ShadowView *view;
    UIButton *selectPageBtn;
    UIView *vv;
    UIButton *huifuBtn;
    
    NJKWebViewProgress *_progressProxy;
    UIProgressView *_progressView;
    UIImage *tempImage;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) ImageDownManager *secDownManger;
@property (nonatomic ,strong)ImageDownManager *thirdDownManger;
@property (nonatomic,strong)NSMutableArray *urlArray;
@end

@implementation ForumDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)GoBack {
    self.mDownManager.delegate = nil;
    self.secDownManger.delegate = nil;
    self.thirdDownManger.delegate = nil;
    //    if (delegate && OnGoBack) {
    //        [delegate performSelector:OnGoBack withObject:self];
    //    }
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        _progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            _progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
            _progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [_progressView setProgress:progress animated:NO];
}


-(void)dealloc
{
//    [self StopLoading];
    self.mDownManager = nil;
    self.secDownManger = nil;
    self.thirdDownManger = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    MM = -1;
    flag = 0;
    mpage1 = 0;
    mpage2 = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];

    
    UIButton *gengduoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gengduoBtn.frame = CGRectMake(0, 0, 40, 30);
    [gengduoBtn setTitle:@"分享" forState:UIControlStateNormal];
    [gengduoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gengduoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [gengduoBtn addTarget:self action:@selector(OnShareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:gengduoBtn];
    
    [self makeNav];
    
    
    
    
    
    
    webView = [[UIWebView alloc]initWithFrame:CGRectMake(-3, 0, self.view.frame.size.width, self.view.frame.size.height - 64 - 50)];
    [self.view addSubview:webView];
//    webView.scalesPageToFit = YES;
    webView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//    webView.delegate = self;
    
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 10)];
    [self.view addSubview:_progressView];

    webView.delegate = _progressProxy;
    
    
    
    [self addTapOnWebView];
    
//    mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    mActView.color = [UIColor blackColor];
//    mActView.frame = CGRectMake((self.view.frame.size.width-30)/2, (self.view.frame.size.height-30)/2, 30, 30);
//    mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//    mActView.hidesWhenStopped = YES;
//    [self.view addSubview:mActView];
    [self loadData];
    
    [self createBottomView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tip) name:@"tip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAgain) name:@"reloadAgain" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeZoom) name:@"remove" object:nil];
    
}
-(void)reloadAgain
{
    [self loadData];
//    [self checkShoucang];
}
-(void)createBottomView
{
    UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.userInteractionEnabled = YES;
    botView.backgroundColor = [UIColor colorWithRed:247.0/256 green:247.0/256 blue:247.0/256 alpha:0.3];
    [self.view addSubview:botView];
    
    huifuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    huifuBtn.frame = CGRectMake(15, 12, botView.frame.size.width - 70 -15, 30);
    [huifuBtn setTitle:@"发表回帖" forState:UIControlStateNormal];
    [huifuBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    huifuBtn.layer.borderWidth = 0.5;
    huifuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    huifuBtn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [huifuBtn addTarget:self action:@selector(huifuClick) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:huifuBtn];
    
    pageNum = [[UILabel alloc]initWithFrame:CGRectMake(botView.frame.size.width - 110, 15, 100, 20)];
    pageNum.textAlignment = NSTextAlignmentRight;
    pageNum.font = [UIFont systemFontOfSize:15];
    pageNum.textColor = [UIColor blackColor];
//    pageNum.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"df_23.png"]];
    [botView addSubview:pageNum];
    
    selectPageBtn = [[UIButton alloc]initWithFrame:CGRectMake(botView.frame.size.width - 110, 15, 100, 20)];
    [selectPageBtn addTarget:self action:@selector(selectPageClick) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:selectPageBtn];
    
    vv = [[UIView alloc]initWithFrame:CGRectMake(botView.frame.size.width - 110, 0, 110, 50)];
    vv.backgroundColor=[UIColor colorWithRed:252.0/256 green:252.0/256 blue:252.0/256 alpha:0.3];
    [botView addSubview:vv];
    vv.hidden = NO;
    
    actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actView.color = [UIColor lightGrayColor];
    actView.frame = CGRectMake(vv.frame.size.width - 50, 15, 20, 20);
//    actView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    actView.hidesWhenStopped = YES;
    [vv addSubview:actView];
    [self getPageCount];

}
-(void)tapShadow
{
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];

}
-(void)selectPageClick
{
    view = [[ShadowView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64)];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow)]];
    [self.tabBarController.view addSubview:view];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 190, view.frame.size.width, 140)];
    pickerView.delegate = self;
    pickerView.userInteractionEnabled = YES;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    if (flag == 0) {
        [pickerView selectRow:mpage1 inComponent:0 animated:YES];
    }
    else
    {
        [pickerView selectRow:mpage2 inComponent:0 animated:YES];
    }
    [view addSubview:pickerView];
    
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, view.frame.size.height-30, view.frame.size.width / 2, 30)];
    [cancelBtn setBackgroundColor:[UIColor whiteColor]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelBtn];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(view.frame.size.width / 2, view.frame.size.height - 30, view.frame.size.width / 2, 30)];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[UIColor blackColor]];
    [view addSubview:confirmBtn];
}
-(void)cancelClick
{
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    view = nil;
}
-(void)confirmClick
{
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    if (flag == 0) {
        mpage1 = temppage1;
    }
    else if(flag == 1)
    {
        mpage2 = temppage2;
    }
    [self.urlArray removeAllObjects];
    [self loadData];
    [self getPageCount];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pageCount;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init];
    if (flag == 0) {
        NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < pageCount +1; i ++) {
            NSString *str =[NSString stringWithFormat:@"第%d页",i];
            [numArray addObject:str];
        }
        
        label.text = numArray[row];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
    }
    else
    {
        NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 1; i < pageCount + 1; i ++) {
            NSString *str =[NSString stringWithFormat:@"第%d页",i];
            [numArray addObject:str];
        }
        
        label.text = numArray[row];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
    }
   
    return label;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (flag == 0) {
        temppage1 = row;
    }
    else if (flag == 1)
    {
        temppage2 = row;
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL =[request URL];
    NSLog(@"%@",requestURL);
    NSString *scheme = [requestURL scheme];
    if ([scheme isEqualToString:@"ref"]) {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *userID = [user objectForKey:@"userID"];
        if (userID == nil) {
            LoginViewController *vc = [[LoginViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            NSArray * array = [[requestURL absoluteString] componentsSeparatedByString:@"ref:"];
            NSString *str = array[1];
            huitieViewController *vc = [[huitieViewController alloc]init];
            vc.louzhuContent = str;
            vc.fid = self.fid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    return YES;
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
//    [mActView stopAnimating];
    [self StopLoading];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView1
{
//    [mActView stopAnimating];
    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",30.0];
//    [webView stringByEvaluatingJavaScriptFromString:str];
    NSString *js = @"document.documentElement.innerHTML";
    NSString *content = [webView stringByEvaluatingJavaScriptFromString:js];
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    NSArray *tempArray = [content componentsSeparatedByString:@"http://"];
    for (NSString *str in tempArray) {
        if ([str hasPrefix:@"www."]) {
            [arr addObject:str];
        }
    }
    self.urlArray = [NSMutableArray arrayWithCapacity:0];
    for (NSString *tempstr in arr) {
        NSArray *temparr = [tempstr componentsSeparatedByString:@"\""];
        NSString *urlstr = [NSString stringWithFormat:@"http://%@",temparr[0]];
        if ([urlstr hasSuffix:@"jpg"]||[urlstr hasSuffix:@"png"]||[urlstr hasSuffix:@"jpeg"]||[urlstr hasSuffix:@"attach"]) {
            if ([urlstr hasPrefix:@"http://www.iwatch365.com/uploadfile"]||[urlstr hasPrefix:@"http://www.iwatch365.com/data/attachment"]) {
                [self.urlArray addObject:urlstr];
            }
            
        }
        
    }

    
}
-(void)addTapOnWebView
{
    UITapGestureRecognizer* picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)];
    [webView addGestureRecognizer:picTap];
    picTap.delegate = self;
    picTap.cancelsTouchesInView = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)picTap:(UITapGestureRecognizer *)sender
{
    if (self.urlArray == nil)
    {
        return;
    }
    if (self.urlArray.count == 0) {
        return;
    }
    CGPoint pt = [sender locationInView:webView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [webView stringByEvaluatingJavaScriptFromString:imgURL];
//    NSLog(@"image url=%@", urlToSave);
    if ([urlToSave hasPrefix:@"http://www.iwatch365.com/uploadfile"]||[urlToSave hasPrefix:@"http://www.iwatch365.com/data/attachment"]) {
        
        if (MM == -1) {
            
        }
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        BGView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:BGView];
        BGView.userInteractionEnabled = YES;
       
    
        sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BGView.frame.size.width, BGView.frame.size.height)];
        sc.pagingEnabled = YES;
        sc.showsHorizontalScrollIndicator = NO;
        sc.contentSize = CGSizeMake(self.urlArray.count *BGView.frame.size.width, BGView.frame.size.height);
        [BGView addSubview:sc];
        
        for (int i = 0; i < self.urlArray.count; i++) {
            NSLog(@"urlToSave:%@",urlToSave);
            NSLog(@"%@",self.urlArray[i]);
            if ([urlToSave isEqualToString:self.urlArray[i]]) {
                MM = i;
                NSLog(@"same");
            }
        }
        sc.contentOffset = CGPointMake(MM * BGView.frame.size.width, 0);
        
        for (int i = 0 ; i <self.urlArray.count; i++) {
            SizeImageView *sizeimageView = [[SizeImageView alloc]initWithFrame:CGRectMake(i * BGView.frame.size.width, 0, BGView.frame.size.width, BGView.frame.size.height)];
            [sizeimageView getImageFromURL:self.urlArray[i]];
            [sizeimageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeZoom)]];
             [sizeimageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [sc addSubview:sizeimageView];
            
        }
        pageForPic = [[UILabel alloc]initWithFrame:CGRectMake((sc.frame.size.width - 80)/2, sc.frame.size.height - 45, 80, 30)];
        pageForPic.textColor = [UIColor whiteColor];
        pageForPic.textAlignment = NSTextAlignmentCenter;
        pageForPic.text = [NSString stringWithFormat:@"%d/%d",MM+1,self.urlArray.count];
        [BGView addSubview:pageForPic];
        
        [sc addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    int numForPic  = sc.contentOffset.x / sc.frame.size.width;
    pageForPic.text = [NSString stringWithFormat:@"%d/%d",numForPic + 1,self.urlArray.count];
}
-(void)removeZoom
{
    [sc removeObserver:self forKeyPath:@"contentOffset"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    for (UIView *v in BGView.subviews) {
        [v removeFromSuperview];
    }
    [BGView removeFromSuperview];
    BGView = nil;
    
}

-(void)tip
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"评论成功";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}
-(void)shoucangClick
{
    
    if (isShoucang) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"你已经收藏了";
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:1.5];
        return;
    }
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *userID = [user objectForKey:@"userID"];
    if (userID == nil) {
        for (UIView *v in view.subviews) {
            [v removeFromSuperview];
        }
        [view removeFromSuperview];
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self StartLoading];
        //www.iwatch365.com/json/iphone/json.php?t=102&fid=fid&uid=uid&favtype=ftype
        NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=102&fid=%@&uid=%@&favtype=%@", SERVER_URL,self.fid,userID,self.fid];
        NSLog(@"%@",urlstr);
        self.mDownManager = [[ImageDownManager alloc] init];
        _mDownManager.delegate = self;
        _mDownManager.OnImageDown = @selector(OnLoadFinish:);
        _mDownManager.OnImageFail = @selector(OnLoadFail:);
        [_mDownManager GetImageByStr:urlstr];
    }
    
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        if ([[dict[@"success"] stringValue]isEqualToString:@"1"]) {
            [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"收藏了.png"] forState:UIControlStateNormal];
            isShoucang = YES;
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"收藏成功";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
            NSLog(@"OK");
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

- (void)Cancel {
    [self StopLoading];
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
}
-(void)huifuClick
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString  * userID = [user objectForKey:@"userID"];
    if (userID == nil) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        huitieViewController *vc = [[huitieViewController alloc]init];
        vc.fid = self.fid;
        vc.bID = self.bID;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(void)OnShareClick
{
    view = [[ShadowView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64)];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow)]];
    [self.tabBarController.view addSubview:view];
    
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, view.frame.size.width, 130)];
    bg.backgroundColor = [UIColor whiteColor];
    [view addSubview:bg];
    [UIView animateWithDuration:0.2 animations:^{
        bg.frame =CGRectMake(0, view.frame.size.height - 130, view.frame.size.width, 130);
    }];
    
    UILabel *tishi = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bg.frame.size.width, 30)];
    tishi.text = @"更多";
    tishi.font = [UIFont systemFontOfSize:16];
    tishi.textAlignment = NSTextAlignmentCenter;
    tishi.backgroundColor = [UIColor colorWithRed:229.0/256 green:229.0/256 blue:229.0/256 alpha:1];
//    [bg addSubview:tishi];
    
    UIScrollView * sc1 = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, bg.frame.size.width, 90)];
    sc1.showsHorizontalScrollIndicator = NO;
    [bg addSubview:sc1];
    
    shoucangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shoucangBtn.frame = CGRectMake(15, 10, 50, 50);
    [shoucangBtn addTarget:self action:@selector(shoucangClick) forControlEvents:UIControlEventTouchUpInside];
    [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"还未收藏.png"] forState:UIControlStateNormal];
    [sc1 addSubview:shoucangBtn];
    [self checkShoucang];
    UILabel *sclabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 70, 30)];
    sclabel.textColor = [UIColor lightGrayColor];
    sclabel.text =@"收藏";
    sclabel.textAlignment = NSTextAlignmentCenter;
    sclabel.font = [UIFont systemFontOfSize:12];
    [sc1 addSubview:sclabel];
    
    NSArray *pArray = @[@"新浪微博.png",@"腾讯微博.png"];
    NSArray *tArray = @[@"新浪微博",@"腾讯微博"];
    
    for (int i = 0; i < pArray.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(80 + i * 70, 10, 50, 50)];
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
        btn.tag = 1000 + i;
        [btn setBackgroundImage:[UIImage imageNamed:pArray[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(pClick:) forControlEvents:UIControlEventTouchUpInside];
        [sc1 addSubview:btn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(70 + i * 70 , 60, 70, 30)];
        l.textColor = [UIColor lightGrayColor];
        l.text =tArray[i];
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:12];
        [sc1 addSubview:l];
    }
    float width_wx = 0;
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi])
    {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(80 + 70 * 2 , 10, 50, 50)];
        wxBtn.layer.cornerRadius = 5;
        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 10000;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"朋友圈.png"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(pClick:) forControlEvents:UIControlEventTouchUpInside];
        [sc1 addSubview:wxBtn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(70 + 70 * 2 , 60, 70, 30)];
        l.textColor = [UIColor lightGrayColor];
        l.text =@"朋友圈";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:12];
        [sc1 addSubview:l];
        width_wx = 70;
    }
    else
    {
        
    }
    float witdh_qq = 0;
    if ([QQApi isQQInstalled]&&[QQApi isQQSupportApi]) {
        UIButton *wxBtn = [[UIButton alloc]initWithFrame:CGRectMake(80 + 70*2 + width_wx , 10, 50, 50)];
        wxBtn.layer.cornerRadius = 5;
        wxBtn.clipsToBounds = YES;
        wxBtn.tag = 10001;
        [wxBtn setBackgroundImage:[UIImage imageNamed:@"qq空间.png"] forState:UIControlStateNormal];
        [wxBtn addTarget:self action:@selector(pClick:) forControlEvents:UIControlEventTouchUpInside];
        [sc1 addSubview:wxBtn];
        UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(70 + 70*2 + width_wx , 60, 70, 30)];
        l.textColor = [UIColor lightGrayColor];
        l.text =@"QQ空间";
        l.textAlignment = NSTextAlignmentCenter;
        l.font = [UIFont systemFontOfSize:12];
        [sc1 addSubview:l];
        witdh_qq = 70;
    }
    else
    {
        
    }
    sc1.contentSize = CGSizeMake(80 + 70 * 2 + width_wx + witdh_qq, 90);
    
    UIButton *quxiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 90, bg.frame.size.width, 40)];
    [quxiaoBtn setTitle:@"取消" forState:UIControlStateNormal];
    [quxiaoBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    quxiaoBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [quxiaoBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [quxiaoBtn setBackgroundColor:[UIColor colorWithRed:229.0/256 green:229.0/256 blue:229.0/256 alpha:1]];
    [bg addSubview:quxiaoBtn];
}
-(void)pClick:(UIButton *)sender
{
    [self tapShadow];
    
//    NSString *shareUrl = [NSString stringWithFormat:@"http://www.iwatch365.com/thread-%@-1-1.html",self.fid];
    [UMSocialWechatHandler setWXAppId:@"wx95d07660d567467e" appSecret:@"d8a52bb496087e06d5cb688c45054e2a" url:textUrl];
    
    [UMSocialQQHandler setQQWithAppId:@"1103602046" appKey:@"Woj5gpCWyv8MkBXL" url:textUrl];
    
    NSString *shareText =[NSString stringWithFormat:@"%@\n%@",self.title,textUrl];
    UIImage *imagea = [UIImage imageNamed:@"fenxianglogo@2x.png"];
    
    int index = sender.tag;
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
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareText image:imagea location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }
}
-(void)loadData
{
    if (flag == 0) {
        [webView stopLoading];
//        [mActView startAnimating];
        textUrl  =  [NSString stringWithFormat:@"http://www.iwatch365.com/thread-%@-1-1.html",self.fid];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iwatch365.com/json/barnr.php?fid=%@&p=%d&uid=0",self.fid,mpage1 + 1]]]];

       
    }
    else if(flag == 1)
    {
        [webView stopLoading];
//        [mActView startAnimating];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iwatch365.com/json/barnr.php?fid=%@&p=%d&uid=1",self.fid,mpage2 + 1]]]];
    }

}
-(void)makeNav
{
    UIView *chosenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    
    allContent = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [allContent setTitle:@"全部内容" forState:UIControlStateNormal];
    [allContent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    allContent.selected = YES;
    [allContent setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [allContent addTarget:self action:@selector(allContentClick) forControlEvents:UIControlEventTouchUpInside];
    [chosenView addSubview:allContent];
   UIView *line = [[UIView alloc]initWithFrame:CGRectMake(chosenView.frame.size.width/2, 5, 1, 20)];
    line.backgroundColor = [UIColor whiteColor];
    [chosenView addSubview:line];
    
    onlyLouzhu = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 80, 30)];
    [onlyLouzhu addTarget:self action:@selector(onlyLouzhuClick) forControlEvents:UIControlEventTouchUpInside];
    [onlyLouzhu setTitle:@"只看楼主" forState:UIControlStateNormal];
    [onlyLouzhu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [onlyLouzhu setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [chosenView addSubview:onlyLouzhu];
    self.navigationItem.titleView = chosenView;
}
-(void)allContentClick
{
    allContent.selected = YES;
    onlyLouzhu.selected = NO;
    flag = 0;
    temppage2 = 0;
//    pageNum.text =[NSString stringWithFormat:@"%d/%d",mpage1,pageCount];
    [self loadData];
    [self getPageCount];
}
-(void)onlyLouzhuClick
{
    onlyLouzhu.selected = YES;
    allContent.selected = NO;
    flag = 1;
    temppage1 = 0;
//    pageNum.text =[NSString stringWithFormat:@"%d/%d",1,1];
    [self loadData];
    [self getPageCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getPageCount
{
    if (_secDownManger) {
        return;
    }
    [actView startAnimating];
    vv.hidden = NO;
    selectPageBtn.enabled = NO;
    NSString *urlstr;
    if (flag == 0) {
        urlstr = [NSString stringWithFormat:@"%@json.php?t=12&fid=%@", SERVER_URL,self.fid];
    }
    else if(flag == 1)
    {
        urlstr = [NSString stringWithFormat:@"%@json.php?t=12&fid=%@&uid=1", SERVER_URL,self.fid];
    }
    
    self.secDownManger = [[ImageDownManager alloc] init];
    _secDownManger.delegate = self;
    _secDownManger.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManger.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManger GetImageByStr:urlstr];

}
- (void)OnLoadFinish1:(ImageDownManager *)sender {
    selectPageBtn.enabled = YES;
    [actView stopAnimating];
    vv.hidden = YES;
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            pageCount = [array[0][@"num"] intValue];
            if (pageCount >= 1000) {
                huifuBtn.frame = CGRectMake(15, 12, self.view.frame.size.width - 110 -15, 30);
            }
            if (pageCount >= 100&&pageCount<1000) {
                huifuBtn.frame = CGRectMake(15, 12, self.view.frame.size.width - 90 -15, 30);
            }
            if (flag == 0) {
                pageNum.text = [NSString stringWithFormat:@"%d/%d页",mpage1 + 1,pageCount];
            }
            else if (flag == 1)
            {
                 pageNum.text = [NSString stringWithFormat:@"%d/%d页",mpage2 + 1,pageCount];
            }
        }
    }
}
- (void)Cancel1 {
//    [self StopLoading];
    self.secDownManger.delegate = nil;
    SAFE_CANCEL_ARC(self.secDownManger);
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [actView stopAnimating];
    [self Cancel1];
}

#pragma mark   验证是否收藏
-(void)checkShoucang
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString  * userID = [user objectForKey:@"userID"];
    if (userID == nil) {
        isShoucang = NO;
        return;
    }
    if (_thirdDownManger) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php? t=19&uid=%@&fid=%@", SERVER_URL,userID,self.fid];
    self.thirdDownManger = [[ImageDownManager alloc] init];
    _thirdDownManger.delegate = self;
    _thirdDownManger.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManger.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManger GetImageByStr:urlstr];
}
- (void)OnLoadFinish2:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel2];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            int num = [array[0][@"num"] intValue];
            if ( num > 0) {
                isShoucang = YES;
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"收藏了.png"] forState:UIControlStateNormal];
                
            }
            else
            {
                isShoucang = NO;
                [shoucangBtn setBackgroundImage:[UIImage imageNamed:@"还未收藏.png"] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)Cancel2 {
//    [self StopLoading];
    self.thirdDownManger.delegate = nil;
    SAFE_CANCEL_ARC(self.thirdDownManger);
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}


-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        SizeImageView *imageView = (SizeImageView *)sender.view;
        tempImage = imageView.mZoomView.image;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定保存图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else
    {
        if (tempImage != nil) {
            UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil,nil);
        }
    }
    
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
