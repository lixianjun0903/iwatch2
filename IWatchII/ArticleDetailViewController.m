//
//  ArticleDetailViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "TouchView.h"
#import "ImageDisplayViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "AutoAlertView.h"
#import "SizeImageView.h"


#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "HttpDownLoadBlock.h"
@interface ArticleDetailViewController ()<UIGestureRecognizerDelegate,UIWebViewDelegate,UIAlertViewDelegate,UIAlertViewDelegate>
{
    UIWebView *mWebView;
    NSString *textUrl;
    
    UIView *BGView;
    float num;
    UIImageView *bottomView;
     int MM ;
    
    UILabel *pageForPic;
    UIScrollView *sc;
    UIButton *refreshBtn;
    UIImage *tempImage;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic,strong)NSMutableArray *urlArray;
@end

@implementation ArticleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)GoBack {
    
    [self StopLoading];
    self.mDownManager.delegate = nil;
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
-(void)dealloc
{
    self.mDownManager = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    MM = 1;
//    num = 100.0;
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    num = [[user objectForKey:@"num"] floatValue];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"文章详情";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeZoom) name:@"remove" object:nil];

    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    mWebView = [[UIWebView alloc] initWithFrame:CGRectMake(2, 0, self.view.frame.size.width-4, self.view.frame.size.height)];
//    mWebView.scalesPageToFit = YES;
    mWebView.opaque = NO;
    mWebView.userInteractionEnabled = YES;
    mWebView.backgroundColor = self.view.backgroundColor;
    mWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 120, 0);
    mWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    mWebView.delegate = self;
    [self.view addSubview:mWebView];
    
    UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50, self.view.frame.size.width, 50)];
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.userInteractionEnabled = YES;
    botView.image = [UIImage imageNamed:@"f_botbar"];
    [self.view addSubview:botView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(15, 0, 60, 50);
    [backBtn setImage:[UIImage imageNamed:@"f_botback"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(GoBack) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:backBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake((botView.frame.size.width-60)/2, 0, 60, 50);
    [shareBtn setImage:[UIImage imageNamed:@"f_botshare"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(OnShareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:shareBtn];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(botView.frame.size.width-80, 0, 35, 50);
    [leftBtn setImage:[UIImage imageNamed:@"f_botleft"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(LoadNextPage1) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(botView.frame.size.width-45, 0, 35, 50);
    [rightBtn setImage:[UIImage imageNamed:@"f_botright"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(LoadLastPage1) forControlEvents:UIControlEventTouchUpInside];
    [botView addSubview:rightBtn];
    
    [self LoadArticleDetail];
    [self addTapOnWebView];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {
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
    else if (alertView.tag == 100)
    {
        if (buttonIndex == 1) {
            MM = 1;
            //        num = 100.0;
            [self Cancel];
            [self LoadArticleDetail];
        }
        else if (buttonIndex == 0)
        {
            refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
            refreshBtn.center = CGPointMake(mWebView.frame.size.width / 2, mWebView.frame.size.height / 2);
            [refreshBtn addTarget:self action:@selector(refreshAgain) forControlEvents:UIControlEventTouchUpInside];
            [refreshBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
            [refreshBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [mWebView addSubview:refreshBtn];
        }

    }
}
-(void)refreshAgain
{
    [refreshBtn removeFromSuperview];
    refreshBtn  = nil;
    [self Cancel];
    MM = 1;
//    num = 100.0;
    [self LoadArticleDetail];
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestURL =[ request URL ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: requestURL];
    }
    return YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",num];
    [mWebView stringByEvaluatingJavaScriptFromString:str];
}
-(void)addTapOnWebView
{
    UITapGestureRecognizer* picTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(picTap:)];
    [mWebView addGestureRecognizer:picTap];
    picTap.delegate = self;
    picTap.cancelsTouchesInView = NO;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)picTap:(UITapGestureRecognizer *)sender
{
    if (bottomView) {
        for (UIView *view in bottomView.subviews) {
            [view removeFromSuperview];
        }
        [bottomView removeFromSuperview];
        bottomView = nil;
    }
    UIView *view = (UIView *)[self.view viewWithTag:50];
    if (view) {
        for (UIView *v in view.subviews) {
            [v removeFromSuperview];
        }
        [view removeFromSuperview];
        view = nil;
    }
    CGPoint pt = [sender locationInView:mWebView];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [mWebView stringByEvaluatingJavaScriptFromString:imgURL];
    NSLog(@"image url=%@", urlToSave);
    if ([urlToSave hasPrefix:@"http://www.iwatch365.com/uploadfile/"]) {
        
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
            if ([urlToSave isEqualToString:self.urlArray[i]]) {
                MM = i;
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
    for (UIView *view in BGView.subviews) {
        [view removeFromSuperview];
    }
    [BGView removeFromSuperview];
    BGView = nil;
    
}

- (void)OnShareBtnClick {
    
    if (bottomView) {
        return;
    }
    bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height- 80, self.view.frame.size.width - 40, 30)];
    bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    bottomView.userInteractionEnabled = YES;
    bottomView.image = [UIImage imageNamed:@"f_botbar"];
    [self.view addSubview:bottomView];
    
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(bottomView.frame.size.width - 60, 0, 50, 30);
    [shareBtn setImage:[UIImage imageNamed:@"f_botshare"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(ShareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:shareBtn];
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(bottomView.frame.size.width / 2 - 20, 0, 50, 30);
    [upBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [upBtn setTitle:@"A+" forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(upClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:upBtn];
    
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame = CGRectMake(30, 0, 50, 30);
    [downBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [downBtn setTitle:@"A-" forState:UIControlStateNormal];
    [downBtn addTarget:self action:@selector(downClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:downBtn];
}
-(void)upClick
{
    num += 10;
    if (num > 130) {
        num = 130;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",num];
    [mWebView stringByEvaluatingJavaScriptFromString:str];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%f"
                     ,num] forKey:@"num"];
    [user synchronize];
}
-(void)downClick
{
    num -= 10;
    if (num < 100) {
        num = 100;
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSString *str = [NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%f%%'",num];
    [mWebView stringByEvaluatingJavaScriptFromString:str];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:[NSString stringWithFormat:@"%f"
                     ,num] forKey:@"num"];
    [user synchronize];
}
-(void)ShareBtnClick
{
    UIView *view = (UIView *)[self.view viewWithTag:50];
    if (view) {
        return;
    }
    view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 140)];
    [self.view addSubview:view];
    view.tag = 50;
    view.userInteractionEnabled = YES;
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShadow)]];
    [UIView animateWithDuration:0.3 animations:^{
        view.frame = CGRectMake(0, self.view.frame.size.height - 140, self.view.frame.size.width, 140);
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadArticleDetail {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=29&fid=%@", SERVER_URL, self.mInfo.fid];
    textUrl = urlstr;
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
            NSLog(@"%@", array);
            NSDictionary *tmpDict = [array objectAtIndex:0];
            self.shareUrl = [tmpDict objectForKey:@"url"];
            NSString *content = [tmpDict objectForKey:@"content"];
            content = [content stringByReplacingOccurrencesOfString:@"width" withString:@"\"width1: "];
            content = [content stringByReplacingOccurrencesOfString:@"height" withString:@" height1: "];
            content = [content stringByReplacingOccurrencesOfString:@"WIDTH" withString:@"\"width1: "];
            content = [content stringByReplacingOccurrencesOfString:@"HEIGHT" withString:@" height1: "];
            content = [content stringByReplacingOccurrencesOfString:@"white-space" withString:@"white-spacedddd:"];
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
                if ([urlstr hasSuffix:@"jpg"]||[urlstr hasSuffix:@"png"]) {
                    if ([urlstr hasPrefix:@"http://www.iwatch365.com/uploadfile"]) {
                        [self.urlArray addObject:urlstr];
                    }
                    
                }
                
            }
            int time = [[tmpDict objectForKey:@"inputtime"] intValue];
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:time];
            NSDateFormatter* df = [[NSDateFormatter alloc]init];
            [df setDateFormat:@"yyyy-MM-dd"];
            NSString* str1 = [df stringFromDate:date];
            NSString *lineimage = [[NSBundle mainBundle] pathForResource:@"f_webline" ofType:@"png"];
            
            if (self.mInfo.username.length <= 5) {
                content = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">img {width: 100%%}</style></head><body><div style=\"font-size:21px;margin-top:10px\"><span style=\"font-weight:bold\">%@</span></div><div style=\"font-size:16px;color:#888888\">%@&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<span style=\"font-size:14px;color:#888888;text-align:right\">%@</span></div><div style=\"margin-top:5px\"><img src=\"file://%@\" /></div><br><div style=\"text-align:justify\"><span style=\"line-height:25px;\">%@</span></div></body></html>", self.mInfo.title, self.mInfo.username, str1,lineimage, content];
            }
            else
            {
                content = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">img {width: 100%%}</style></head><body><div style=\"font-size:21px;margin-top:10px\"><span style=\"font-weight:bold\">%@</span></div><div style=\"font-size:16px;color:#888888\">%@&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp<span style=\"font-size:14px;color:#888888;text-align:right\">%@</span></div><div style=\"margin-top:5px\"><img src=\"file://%@\" /></div><br><div style=\"text-align:justify\"><span style=\"line-height:25px;\">%@</span></div></body></html>", self.mInfo.title, self.mInfo.username, str1,lineimage, content];
            }
            
            
            NSLog(@"%@", lineimage);
            [mWebView loadHTMLString:content baseURL:nil];

        }
    }
}

- (void)LoadNextPage1 {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=28&uid=1&fid=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=27&uid=%@&fid=%@", SERVER_URL, self.mCatID, self.mInfo.fid];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadNextFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}

- (void)OnLoadNextFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        int iSuccess = [[dict objectForKey:@"success"] intValue];
        if (iSuccess == 0) {
            [AutoAlertView ShowAlert:@"提示" message:@"没有更多了"];
            return;
        }
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            NSDictionary *tmpDict = [array objectAtIndex:0];
            ArticleListInfo *info = [ArticleListInfo CreateWithDict:tmpDict];
            if (info) {
                self.mInfo = info;
                [self LoadArticleDetail];
            }
        }
    }
}

- (void)LoadLastPage1 {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=28&uid=1&fid=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=28&uid=%@&fid=%@", SERVER_URL, self.mCatID, self.mInfo.fid];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadLastFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}

- (void)OnLoadLastFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        int iSuccess = [[dict objectForKey:@"success"] intValue];
        if (iSuccess == 0) {
            [AutoAlertView ShowAlert:@"提示" message:@"没有更多了"];
            return;
        }
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            NSDictionary *tmpDict = [array objectAtIndex:0];
            ArticleListInfo *info = [ArticleListInfo CreateWithDict:tmpDict];
            if (info) {
                self.mInfo = info;
                [self LoadArticleDetail];
            }
        }
    }
}


- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新下", nil ];
    alert.tag = 100;
    [alert show];
}


#pragma mark  savepic
-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        SizeImageView *imageView = (SizeImageView *)sender.view;
        tempImage = imageView.mZoomView.image;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定保存图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.tag = 101;
        [al show];
    }
}

#pragma mark  fenxiang 
-(void)pClick:(UIButton *)sender
{
    [self tapShadow];
    NSString *shareText =[NSString stringWithFormat:@"%@%@",self.mInfo.title,self.shareUrl];             //分享内嵌文字
    //分享内嵌图片
//    UIImage *imagea = [UIImage imageNamed:@"fenxianglogo@2x.png"];
    //如果得到分享完成回调，需要设置delegate为self
 
    [UMSocialWechatHandler setWXAppId:@"wx95d07660d567467e" appSecret:@"d8a52bb496087e06d5cb688c45054e2a" url:self.shareUrl];
    
    [UMSocialQQHandler setQQWithAppId:@"1103602046" appKey:@"Woj5gpCWyv8MkBXL" url:self.shareUrl];
    
    HttpDownLoadBlock *request =[[HttpDownLoadBlock alloc]initWithStrUrl:self.mInfo.thumb Block:^(BOOL isFinish, HttpDownLoadBlock *http) {
        if (isFinish) {
            UIImage *imagea  = http.dataImage;
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
                
                [[UMSocialControllerService defaultControllerService] setShareText:shareText shareImage:imagea socialUIDelegate:nil];     //设置分享内容和回调对象
                [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(self,[UMSocialControllerService defaultControllerService],YES);
                
                
            }

        }
        else
        {
            [self showMsg:@"分享出现问题，分享图片无法加载"];
        }
    }];
}
-(void)tapShadow
{
    UIView *view = (UIView *)[self.view viewWithTag:50];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
}
-(void)dddd
{
    UIView *view = (UIView *)[self.view viewWithTag:50];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    view = nil;
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
