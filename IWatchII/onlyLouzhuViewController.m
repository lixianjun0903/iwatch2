//
//  onlyLouzhuViewController.m
//  IWatchII
//
//  Created by xll on 15/1/5.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import "onlyLouzhuViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "huitieViewController.h"
#import "LoginViewController.h"
#import "SizeImageView.h"
#import "ShadowView.h"

#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "WXApi.h"
#import "NJKWebViewProgress.h"
#import "testViewController.h"
@interface onlyLouzhuViewController ()<UIWebViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,NJKWebViewProgressDelegate,UIAlertViewDelegate>
{
    UIWebView *mWebView;
    UIWebView *mLastView;
    UIWebView *mNextView;
    UIView *mShadowView;
    CGPoint mStartPoint;
    BOOL mbLastDragBegin;
    BOOL mbNextDragBegin;
    
    
    int pageCount;
    int nowPage;
    UILabel *pageShowLabel;
    
    int MM;
    UIImage *tempImage;
    
    UIActivityIndicatorView * actView;
    int selectPage;
    
    UIButton *shoucangBtn;
    BOOL isShoucang;
    
    NJKWebViewProgress *_progressProxy;
    UIProgressView *_progressView;
    UIView *chosenView;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) ImageDownManager *secDownManger;
@property (nonatomic ,strong)ImageDownManager *thirdDownManger;

@property (nonatomic,strong)NSMutableArray *lastArray;
@property (nonatomic,strong)NSMutableArray *nowArray;
@property (nonatomic,strong)NSMutableArray *nextArray;

@end

@implementation onlyLouzhuViewController

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
    if (self.navigationController) {
        NSArray *pastArray = self.navigationController.viewControllers;
        UIViewController *vc = pastArray[1];
        [self.navigationController popToViewController:vc animated:NO];
//        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    UIButton *gengduoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gengduoBtn.frame = CGRectMake(0, 0, 40, 30);
    [gengduoBtn setTitle:@"分享" forState:UIControlStateNormal];
    [gengduoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    gengduoBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [gengduoBtn addTarget:self action:@selector(OnShareClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:gengduoBtn];
    
    [self makeNav];
    
    [self createBottomView];
    
    
    [self getPageCount];
    nowPage = 1;
    MM = 0;
    selectPage = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tip) name:@"tip" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAgain) name:@"reloadAgain" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeZoom) name:@"remove" object:nil];
}
-(void)reloadAgain
{
    [self getPageCount];
    nowPage = 1;
    MM = 0;
}
-(void)makeNav
{
    chosenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    
    
    UIButton * allContent = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [allContent setTitle:@"全部内容" forState:UIControlStateNormal];
    [allContent setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    allContent.selected = NO;
    allContent.tag =400;
    [allContent setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [allContent addTarget:self action:@selector(navClick:) forControlEvents:UIControlEventTouchUpInside];
    [chosenView addSubview:allContent];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(chosenView.frame.size.width/2, 5, 1, 20)];
    line.backgroundColor = [UIColor whiteColor];
    [chosenView addSubview:line];
    
    UIButton * onlyLouzhu = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 80, 30)];
    [onlyLouzhu addTarget:self action:@selector(navClick:) forControlEvents:UIControlEventTouchUpInside];
    onlyLouzhu.tag = 401;
    onlyLouzhu.selected = YES;
    [onlyLouzhu setTitle:@"只看楼主" forState:UIControlStateNormal];
    [onlyLouzhu setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [onlyLouzhu setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [chosenView addSubview:onlyLouzhu];
    self.navigationItem.titleView = chosenView;
}
-(void)navClick:(UIButton *)sender
{
    if (sender.selected == YES) {
        return;
    }
    for (int i = 400; i<402; i++) {
        UIButton *btn = (UIButton *)[chosenView viewWithTag:i];
        if (btn.tag == i) {
            btn.selected = YES;
        }
        else
        {
            btn.selected = NO;
        }
    }
    
    if (sender.tag == 400) {
        testViewController *vc =[[testViewController alloc]init];
        vc.bID = self.bID;
        vc.fid = self.fid;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}
-(void)getPageCount
{
    if (_secDownManger) {
        return;
    }
    
    UIView *botView = [self.view viewWithTag:100100];
    UIButton * selectPageBtn = (UIButton *)[botView viewWithTag:100103];
    UIView * vv = [botView viewWithTag:100104];
    vv.hidden = NO;
    selectPageBtn.enabled = NO;
    
    
    NSString *urlstr;
    urlstr = [NSString stringWithFormat:@"%@json.php?t=12&fid=%@&uid=1", SERVER_URL,self.fid];
    
    self.secDownManger = [[ImageDownManager alloc] init];
    _secDownManger.delegate = self;
    _secDownManger.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManger.OnImageFail = @selector(OnLoadFail1:);
    [actView startAnimating];
    [_secDownManger GetImageByStr:urlstr];
    
}
- (void)OnLoadFinish1:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            pageCount = [array[0][@"num"] intValue];
            UIView *botView = [self.view viewWithTag:100100];
            UIButton  *  huifuBtn = (UIButton *)[botView viewWithTag:100101];
            UILabel *pageNum = (UILabel *)[botView viewWithTag:100102];
            UIView * vv = [botView viewWithTag:100104];
            UIButton * selectPageBtn = (UIButton *)[botView viewWithTag:100103];
            selectPageBtn.enabled = YES;
            vv.hidden = YES;
            if (pageCount >= 1000) {
                huifuBtn.frame = CGRectMake(15, 12, self.view.frame.size.width - 110 -15, 30);
            }
            if (pageCount >= 100&&pageCount<1000) {
                huifuBtn.frame = CGRectMake(15, 12, self.view.frame.size.width - 90 -15, 30);
            }
            pageNum.text = [NSString stringWithFormat:@"%d/%d页",nowPage,pageCount];
            
            [self createWebView];
            
        }
    }
}
- (void)Cancel1 {
    [actView stopAnimating];
    self.secDownManger.delegate = nil;
    SAFE_CANCEL_ARC(self.secDownManger);
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
#pragma mark  创建webView
-(void)createWebView
{
    CGRect rect = self.view.window.bounds;
    pageShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    pageShowLabel.textAlignment = NSTextAlignmentCenter;
    pageShowLabel.textColor = [UIColor redColor];
    pageShowLabel.center = CGPointMake(rect.size.width/2, 75);
    pageShowLabel.hidden = YES;
    [self.view.window addSubview:pageShowLabel];
    
    mNextView = [self GetWebView:nowPage+1];
    mWebView = [self GetWebView:nowPage];
    mLastView = [self GetWebView:nowPage-1];
    mLastView.center = CGPointMake(self.view.frame.size.width/2, -self.view.frame.size.height/2);
    
    
}
#pragma mark
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView == mWebView) {
        NSString *js = @"document.documentElement.innerHTML";
        NSString *content = [mWebView stringByEvaluatingJavaScriptFromString:js];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        NSArray *tempArray = [content componentsSeparatedByString:@"http://"];
        for (NSString *str in tempArray) {
            if ([str hasPrefix:@"www."]) {
                [arr addObject:str];
            }
        }
        
        self.nowArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *tempstr in arr) {
            NSArray *temparr = [tempstr componentsSeparatedByString:@"\""];
            NSString *urlstr = [NSString stringWithFormat:@"http://%@",temparr[0]];
            if ([urlstr hasSuffix:@"jpg"]||[urlstr hasSuffix:@"png"]||[urlstr hasSuffix:@"jpeg"]||[urlstr hasSuffix:@"attach"]) {
                if ([urlstr hasPrefix:@"http://www.iwatch365.com/uploadfile"]||[urlstr hasPrefix:@"http://www.iwatch365.com/data/attachment"]) {
                    [self.nowArray addObject:urlstr];
                }
                
            }
            
        }
        
    }
    if (webView == mNextView) {
        NSString *js = @"document.documentElement.innerHTML";
        NSString *content = [mNextView stringByEvaluatingJavaScriptFromString:js];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        NSArray *tempArray = [content componentsSeparatedByString:@"http://"];
        for (NSString *str in tempArray) {
            if ([str hasPrefix:@"www."]) {
                [arr addObject:str];
            }
        }
        self.nextArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *tempstr in arr) {
            NSArray *temparr = [tempstr componentsSeparatedByString:@"\""];
            NSString *urlstr = [NSString stringWithFormat:@"http://%@",temparr[0]];
            if ([urlstr hasSuffix:@"jpg"]||[urlstr hasSuffix:@"png"]||[urlstr hasSuffix:@"jpeg"]||[urlstr hasSuffix:@"attach"]) {
                if ([urlstr hasPrefix:@"http://www.iwatch365.com/uploadfile"]||[urlstr hasPrefix:@"http://www.iwatch365.com/data/attachment"]) {
                    [self.nextArray addObject:urlstr];
                }
                
            }
            
        }
        
    }
    if (webView == mLastView) {
        NSString *js = @"document.documentElement.innerHTML";
        NSString *content = [mLastView stringByEvaluatingJavaScriptFromString:js];
        
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        NSArray *tempArray = [content componentsSeparatedByString:@"http://"];
        for (NSString *str in tempArray) {
            if ([str hasPrefix:@"www."]) {
                [arr addObject:str];
            }
        }
        self.lastArray = [NSMutableArray arrayWithCapacity:0];
        for (NSString *tempstr in arr) {
            NSArray *temparr = [tempstr componentsSeparatedByString:@"\""];
            NSString *urlstr = [NSString stringWithFormat:@"http://%@",temparr[0]];
            if ([urlstr hasSuffix:@"jpg"]||[urlstr hasSuffix:@"png"]||[urlstr hasSuffix:@"jpeg"]||[urlstr hasSuffix:@"attach"]) {
                if ([urlstr hasPrefix:@"http://www.iwatch365.com/uploadfile"]||[urlstr hasPrefix:@"http://www.iwatch365.com/data/attachment"]) {
                    [self.lastArray addObject:urlstr];
                }
                
            }
            
        }
        
    }
    
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
    
    if (navigationType == UIWebViewNavigationTypeOther)
    {
        if (self.nowArray == nil)
        {
            return YES;
        }
        if (self.nowArray.count == 0) {
            return YES;
        }
        NSString *urlString = [requestURL absoluteString];
        NSLog(@"!!!%@",urlString);
        [self loadPicSC:urlString];
    }

    
    return YES;
}
-(void)loadPicSC:(NSString *)urlToSave
{
    if ([urlToSave hasPrefix:@"click:image:iwatch_imghttp://www.iwatch365.com/uploadfile"]||[urlToSave hasPrefix:@"click:image:iwatch_imghttp://www.iwatch365.com/data/attachment"]) {
        
        NSString *substr =[urlToSave componentsSeparatedByString:@"click:image:iwatch_img"][1];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        BGView.tag =60;
        BGView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:BGView];
        BGView.userInteractionEnabled = YES;
        
        
        UIScrollView * sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BGView.frame.size.width, BGView.frame.size.height)];
        sc.pagingEnabled = YES;
        sc.tag = 70;
        sc.showsHorizontalScrollIndicator = NO;
        sc.contentSize = CGSizeMake(self.nowArray.count *BGView.frame.size.width, BGView.frame.size.height);
        [BGView addSubview:sc];
        
        for (int i = 0; i < self.nowArray.count; i++) {
            NSLog(@"urlToSave:%@",urlToSave);
            NSLog(@"%@",self.nowArray[i]);
            if ([substr isEqualToString:self.nowArray[i]]) {
                MM = i;
                NSLog(@"same");
            }
        }
        sc.contentOffset = CGPointMake(MM * BGView.frame.size.width, 0);
        
        for (int i = 0 ; i <self.nowArray.count; i++) {
            SizeImageView *sizeimageView = [[SizeImageView alloc]initWithFrame:CGRectMake(i * BGView.frame.size.width, 0, BGView.frame.size.width, BGView.frame.size.height)];
            [sizeimageView getImageFromURL:self.nowArray[i]];
            [sizeimageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeZoom)]];
            [sizeimageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [sc addSubview:sizeimageView];
            
        }
        UILabel *  pageForPic = [[UILabel alloc]initWithFrame:CGRectMake((sc.frame.size.width - 80)/2, sc.frame.size.height - 45, 80, 30)];
        pageForPic.tag = 80;
        pageForPic.textColor = [UIColor whiteColor];
        pageForPic.textAlignment = NSTextAlignmentCenter;
        pageForPic.text = [NSString stringWithFormat:@"%d/%d",MM+1,self.nowArray.count];
        [BGView addSubview:pageForPic];
        
        [sc addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIView * BGView = [self.view viewWithTag:60];
    UIScrollView *sc = (UIScrollView *)[BGView viewWithTag:70];
    UILabel *pageForPic = (UILabel *)[BGView viewWithTag:80];
    int numForPic  = sc.contentOffset.x / sc.frame.size.width;
    pageForPic.text = [NSString stringWithFormat:@"%d/%d",numForPic + 1,self.nowArray.count];
}
-(void)removeZoom
{
    
    UIView * BGView = [self.view viewWithTag:60];
    UIScrollView *sc = (UIScrollView *)[BGView viewWithTag:70];
    //    UILabel *pageForPic = (UILabel *)[BGView viewWithTag:80];
    [sc removeObserver:self forKeyPath:@"contentOffset"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    for (UIView *v in BGView.subviews) {
        [v removeFromSuperview];
    }
    [BGView removeFromSuperview];
    BGView = nil;
    
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
#pragma mark   翻页
- (UIWebView *)GetWebView:(int)page
{
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.backgroundColor = [UIColor whiteColor];
    //    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    webView.scrollView.bounces = NO;
    webView.scrollView.delegate = self;
    //    webView.opaque = NO;
    [self.view addSubview:webView];
    
    //    webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    //    webView.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if (page == nowPage) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 1, self.view.frame.size.width, 10)];
        [self.view addSubview:_progressView];
        webView.delegate = _progressProxy;
    }
    else
    {
        webView.delegate = self;
    }
    
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.iwatch365.com/json/barnr.php?fid=%@&p=%d&uid=1",self.fid,page]]]];
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(0, webView.frame.size.height, webView.frame.size.width, webView.frame.size.height)];
    shadowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    shadowView.hidden = YES;
    shadowView.userInteractionEnabled = NO;
    shadowView.tag = 1000;
    [webView addSubview:shadowView];
    
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(OnGestureRecognizer:)];
    pgr.delegate = self;
    [webView addGestureRecognizer:pgr];
    
    UIView *botView = [self.view viewWithTag:100100];
    [self.view bringSubviewToFront:botView];
    return webView;
}
- (BOOL)IsScrollTop {
    if (round(mWebView.scrollView.contentOffset.y) <= 0) {
        return YES;
    }
    return NO;
}

- (BOOL)IsScrollBottom {
    if (round(mWebView.scrollView.contentOffset.y) >= mWebView.scrollView.contentSize.height-mWebView.scrollView.frame.size.height) {
        return YES;
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([self IsScrollTop] || [self IsScrollBottom]) {
        return YES;
    }
    NSLog(@"%f", round(mWebView.scrollView.contentOffset.y));
    return NO;
}

- (void)OnGestureRecognizer:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:sender.view];
    if (![self IsScrollTop] && ![self IsScrollBottom]) {
        return;
    }
    if(nowPage-1<1 &&[self IsScrollTop] && translation.y>0)
    {
        CGRect rect = self.view.window.bounds;
        pageShowLabel.center = CGPointMake(rect.size.width/2, 75);
        pageShowLabel.text = @"没有上一页了";
        pageShowLabel.hidden=NO;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pageShowLabelHiden) userInfo:nil repeats:NO];
        return;
    }
    if (nowPage+1>pageCount&&[self IsScrollBottom] && translation.y<0) {
        CGRect rect = self.view.window.bounds;
        pageShowLabel.center = CGPointMake(rect.size.width/2, rect.size.height-60);
        pageShowLabel.text = @"没有下一页了";
        pageShowLabel.hidden=NO;
        [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(pageShowLabelHiden) userInfo:nil repeats:NO];
        return;
    }
    
    if ([self IsScrollTop] && translation.y<0) {
        NSLog(@"OnGestureRecognizer Fail:%f %f", mWebView.scrollView.contentOffset.y, translation.y);
        if (mbLastDragBegin) {
            
            [self RefreshLastView];
        }
        mWebView.scrollView.scrollEnabled = YES;
        return;
    }
    if ([self IsScrollBottom] && translation.y>0&&![self IsScrollTop]) {
        NSLog(@"OnGestureRecognizer:%f", translation.y);
        if (mbNextDragBegin) {
            
            [self RefreshmWebView];
        }
        mWebView.scrollView.scrollEnabled = YES;
        return;
    }
    NSLog(@"OnGestureRecognizer:%f", translation.y);
    if (sender.state == UIGestureRecognizerStateBegan && [sender numberOfTouches] > 0) {
        NSLog(@"UIGestureRecognizerStateBegan");
        if ([self IsScrollTop]) {
            mWebView.scrollView.scrollEnabled = NO;
            mStartPoint = CGPointMake(self.view.frame.size.width/2, -self.view.frame.size.height/2);
            mLastView.center = CGPointMake(mStartPoint.x, mStartPoint.y+translation.y);
            mShadowView = [mLastView viewWithTag:1000];
            mShadowView.alpha = 0.0;
            mbLastDragBegin = YES;
        }
        else {
            mWebView.scrollView.scrollEnabled = NO;
            mStartPoint = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
            mWebView.center = CGPointMake(mStartPoint.x, mStartPoint.y+translation.y);
            mShadowView = [mWebView viewWithTag:1000];
            mShadowView.alpha = 1.0;
            mbNextDragBegin = YES;
        }
        mShadowView.hidden = NO;
        [mShadowView.superview bringSubviewToFront:mShadowView];
        NSLog(@"%@", mShadowView.superview);
    }
    else if (sender.state == UIGestureRecognizerStateChanged && [sender numberOfTouches] > 0) {
        float fAlpha = 0.0;
        pageShowLabel.hidden = NO;
        if ([self IsScrollTop]) {
            CGRect rect = self.view.window.bounds;
            pageShowLabel.center = CGPointMake(rect.size.width/2, 75);
            pageShowLabel.text = [NSString stringWithFormat:@"下拉返回%d页",nowPage-1];
            mLastView.center = CGPointMake(mStartPoint.x, mStartPoint.y+translation.y);
            NSLog(@"%f", (mLastView.center.y-mStartPoint.y)/self.view.frame.size.height);
            fAlpha = MIN(MAX((mLastView.center.y-mStartPoint.y)/self.view.frame.size.height, 0.0), 1.0);
        }
        else {
            CGRect rect = self.view.window.bounds;
            pageShowLabel.center = CGPointMake(rect.size.width/2, rect.size.height-60);
            pageShowLabel.text =[NSString stringWithFormat:@"上拉到达%d页",nowPage+1] ;
            mWebView.center = CGPointMake(mStartPoint.x, mStartPoint.y+translation.y);
            fAlpha = 1.0-MIN(MAX((mStartPoint.y-mWebView.center.y)/self.view.frame.size.height, 0.0), 1.0);
        }
        NSLog(@"%f", fAlpha);
        mShadowView.alpha = fAlpha;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        mbLastDragBegin = NO;
        mbNextDragBegin = NO;
        NSLog(@"UIGestureRecognizerStateEnded");
        if ([self IsScrollTop]) {
            [self RefreshLastView];
        }
        else if ([self IsScrollBottom]) {
            [self RefreshmWebView];
        }
        
    }
}

- (void)RefreshLastView {
    self.view.userInteractionEnabled = NO;
    NSLog(@"RefreshLastView:%f", mLastView.center.y);
    if (mLastView.center.y<-self.view.frame.size.height/4) {
        [UIView animateWithDuration:0.3 animations:^{
            mLastView.center = mStartPoint;
            mShadowView.alpha = 0.0;
        } completion:^(BOOL finish) {
            self.view.userInteractionEnabled = YES;
            pageShowLabel.hidden =YES;
            mWebView.scrollView.scrollEnabled = YES;
            
            UIView *botView = [self.view viewWithTag:100100];
            [self.view bringSubviewToFront:botView];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            mLastView.center = CGPointMake(mStartPoint.x, self.view.frame.size.height/2);
            mShadowView.alpha = 1.0;
        } completion:^(BOOL finish) {
            mShadowView.hidden = YES;
            [mNextView removeFromSuperview];
            mNextView = mWebView;
            mWebView = mLastView;
            nowPage--;
            
            [self.nextArray removeAllObjects];
            [self.nextArray addObjectsFromArray:self.nowArray];
            [self.nowArray removeAllObjects];
            [self.nowArray addObjectsFromArray:self.lastArray];
            [self.lastArray removeAllObjects];
            
            UIView *botView = [self.view viewWithTag:100100];
            UILabel *pageNum = (UILabel *)[botView viewWithTag:100102];
            pageNum.text = [NSString stringWithFormat:@"%d/%d页",nowPage,pageCount];
            
            
            mLastView = [self GetWebView:nowPage-1];
            mLastView.center = CGPointMake(self.view.frame.size.width/2, -self.view.frame.size.height/2);
            self.view.userInteractionEnabled = YES;
            pageShowLabel.hidden =YES;
            mWebView.scrollView.scrollEnabled = YES;
            
            [self.view bringSubviewToFront:botView];
        }];
    }
}
-(void)RefreshmWebView
{
    self.view.userInteractionEnabled = NO;
    NSLog(@"UIGestureRecognizerStateEnded:%f", mWebView.center.y);
    
    if (mWebView.center.y>self.view.frame.size.height/4) {
        [UIView animateWithDuration:0.3 animations:^{
            mWebView.center = mStartPoint;
            mShadowView.alpha = 1.0;
        } completion:^(BOOL finish) {
            self.view.userInteractionEnabled = YES;
            pageShowLabel.hidden =YES;
            mWebView.scrollView.scrollEnabled = YES;
            
            UIView *botView = [self.view viewWithTag:100100];
            [self.view bringSubviewToFront:botView];
        }];
    }
    else {
        [UIView animateWithDuration:0.3 animations:^{
            mWebView.center = CGPointMake(mStartPoint.x, -mStartPoint.y);
            mShadowView.alpha = 0.0;
        } completion:^(BOOL finish) {
            mShadowView.hidden = YES;
            [mLastView removeFromSuperview];
            mLastView = mWebView;
            mWebView = mNextView;
            nowPage++;
            
            
            [self.lastArray removeAllObjects];
            [self.lastArray addObjectsFromArray:self.nowArray];
            [self.nowArray removeAllObjects];
            [self.nowArray addObjectsFromArray:self.nextArray];
            [self.nextArray removeAllObjects];
            
            UIView *botView = [self.view viewWithTag:100100];
            UILabel *pageNum = (UILabel *)[botView viewWithTag:100102];
            pageNum.text = [NSString stringWithFormat:@"%d/%d页",nowPage,pageCount];
            
            
            mNextView = [self GetWebView:nowPage+1];
            [self.view sendSubviewToBack:mNextView];
            self.view.userInteractionEnabled = YES;
            pageShowLabel.hidden =YES;
            mWebView.scrollView.scrollEnabled = YES;
            
            [self.view bringSubviewToFront:botView];
        }];
    }
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float fMaxTop = scrollView.contentSize.height-scrollView.frame.size.height;
    //NSLog(@"%f, %f", scrollView.contentOffset.y, fMaxTop);
    if (scrollView.contentOffset.y>fMaxTop) {
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    pageShowLabel.hidden =YES;
}
-(void)pageShowLabelHiden
{
    pageShowLabel.hidden=YES;
}
#pragma mark  创建bottomView
-(void)createBottomView
{
    UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    botView.tag = 100100;
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.userInteractionEnabled = YES;
    botView.backgroundColor = [UIColor colorWithRed:247.0/256 green:247.0/256 blue:247.0/256 alpha:1];
    [self.view addSubview:botView];
    [self.view bringSubviewToFront:botView];
    
    UIButton  *  huifuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    huifuBtn.tag = 100101;
    huifuBtn.frame = CGRectMake(15, 12, botView.frame.size.width - 70 -15, 30);
    [huifuBtn setTitle:@"发表回帖" forState:UIControlStateNormal];
    [huifuBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    huifuBtn.layer.borderWidth = 0.5;
    huifuBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    huifuBtn.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    [huifuBtn addTarget:self action:@selector(huifuClick) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:huifuBtn];
    
    UILabel * pageNum = [[UILabel alloc]initWithFrame:CGRectMake(botView.frame.size.width - 110, 15, 100, 20)];
    pageNum.tag = 100102;
    pageNum.textAlignment = NSTextAlignmentRight;
    pageNum.font = [UIFont systemFontOfSize:15];
    pageNum.textColor = [UIColor blackColor];
    [botView addSubview:pageNum];
    
    UIButton * selectPageBtn = [[UIButton alloc]initWithFrame:CGRectMake(botView.frame.size.width - 110, 15, 100, 20)];
    selectPageBtn.tag = 100103;
    [selectPageBtn addTarget:self action:@selector(selectPageClick) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:selectPageBtn];
    
    UIView * vv = [[UIView alloc]initWithFrame:CGRectMake(botView.frame.size.width - 70, 0, 70, 50)];
    vv.tag = 100104;
    vv.backgroundColor=[UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.00f];
    [botView addSubview:vv];
    vv.hidden = NO;
    
    actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    actView.color = [UIColor lightGrayColor];
    actView.frame = CGRectMake(vv.frame.size.width - 50, 15, 20, 20);
    actView.hidesWhenStopped = YES;
    [vv addSubview:actView];
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
-(void)tapShadow
{
    UIView *view = [self.tabBarController.view viewWithTag:111000];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    
}
-(void)selectPageClick
{
    UIView *view = [[ShadowView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64)];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow)]];
    view.tag = 111000;
    [self.tabBarController.view addSubview:view];
    
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, view.frame.size.height - 190, view.frame.size.width, 140)];
    pickerView.delegate = self;
    pickerView.userInteractionEnabled = YES;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.dataSource = self;
    [pickerView selectRow:nowPage-1 inComponent:0 animated:YES];
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
    UIView *view = [self.tabBarController.view viewWithTag:111000];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    view = nil;
}
-(void)confirmClick
{
    UIView *view = [self.tabBarController.view viewWithTag:111000];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    
    nowPage = selectPage;
    
    UIView *botView = [self.view viewWithTag:100100];
    UILabel *pageNum = (UILabel *)[botView viewWithTag:100102];
    pageNum.text = [NSString stringWithFormat:@"%d/%d页",nowPage,pageCount];
    
    MM = 0;
    [self.nowArray removeAllObjects];
    [self.nextArray removeAllObjects];
    [self.lastArray removeAllObjects];
    
    
    mNextView = [self GetWebView:nowPage+1];
    mWebView = [self GetWebView:nowPage];
    mLastView = [self GetWebView:nowPage-1];
    mLastView.center = CGPointMake(self.view.frame.size.width/2, -self.view.frame.size.height/2);
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
    
    NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 1; i < pageCount +1; i ++) {
        NSString *str =[NSString stringWithFormat:@"第%d页",i];
        [numArray addObject:str];
    }
    
    label.text = numArray[row];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor blackColor];
    
    return label;
    
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectPage = row+1;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}

#pragma mark  更多
-(void)tapShadow1
{
    UIView *view = [self.tabBarController.view viewWithTag:3000];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
}
-(void)OnShareClick
{
    UIView * view = [[ShadowView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 64)];
    view.tag = 3000;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow1)]];
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
        btn.tag = 1100 + i;
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
        wxBtn.tag = 11000;
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
        wxBtn.tag = 11001;
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
    [quxiaoBtn addTarget:self action:@selector(tapShadow1) forControlEvents:UIControlEventTouchUpInside];
    [quxiaoBtn setBackgroundColor:[UIColor colorWithRed:229.0/256 green:229.0/256 blue:229.0/256 alpha:1]];
    [bg addSubview:quxiaoBtn];
}
-(void)pClick:(UIButton *)sender
{
    [self tapShadow1];
    
    NSString *shareUrl = [NSString stringWithFormat:@"http://www.iwatch365.com/thread-%@-1-1.html",self.fid];
    [UMSocialWechatHandler setWXAppId:@"wx95d07660d567467e" appSecret:@"d8a52bb496087e06d5cb688c45054e2a" url:shareUrl];
    
    [UMSocialQQHandler setQQWithAppId:@"1103602046" appKey:@"Woj5gpCWyv8MkBXL" url:shareUrl];
    
    NSString *shareText =[NSString stringWithFormat:@"%@\n%@",self.title,shareUrl];
    UIImage *imagea = [UIImage imageNamed:@"fenxianglogo@2x.png"];
    
    int index = sender.tag;
    if (index == 1100) {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:shareText image:imagea location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    else if (index == 1101)
    {
        [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imagea socialUIDelegate:nil];     //设置分享内容和回调对象
        [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
        
    }
    else if (index == 11000)
    {
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:shareText image:imagea location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
    }
    else if (index == 11001)
    {
        
        [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:shareText image:imagea location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
            if (response.responseCode == UMSResponseCodeSuccess) {
                NSLog(@"分享成功！");
            }
        }];
        
    }
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
#pragma mark  点击进行收藏
-(void)shoucangClick
{
    UIView *view = [self.tabBarController.view viewWithTag:3000];
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
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
