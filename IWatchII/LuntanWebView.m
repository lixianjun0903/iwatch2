//
//  LuntanWebView.m
//  IWatchII
//
//  Created by xll on 15/1/2.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import "LuntanWebView.h"
#import "LoginViewController.h"
#import "huitieViewController.h"
#import "SizeImageView.h"
@implementation LuntanWebView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
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
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL =[request URL];
    NSLog(@"%@",requestURL);
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *scheme = [requestURL scheme];
        if ([scheme isEqualToString:@"ref"]) {
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            NSString *userID = [user objectForKey:@"userID"];
            if (userID == nil) {
                LoginViewController *vc = [[LoginViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.dele.navigationController pushViewController:vc animated:YES];
            }
            else{
                NSArray * array = [[requestURL absoluteString] componentsSeparatedByString:@"ref:"];
                NSString *str = array[1];
                huitieViewController *vc = [[huitieViewController alloc]init];
                vc.louzhuContent = str;
                vc.fid = self.fid;
                [self.dele.navigationController pushViewController:vc animated:YES];
            }
        }

    }
    else if (navigationType == UIWebViewNavigationTypeOther)
    {
        NSString *urlString = [requestURL absoluteString];
        NSLog(@"!!!%@",urlString);
        [self loadPicSC:urlString];
    }
    
    
    return YES;
}
-(void)loadPicSC:(NSString *)urlToSave
{
    if ([urlToSave hasPrefix:@"click:image:iwatch_imghttp://www.iwatch365.com/uploadfile"]||[urlToSave hasPrefix:@"click:image:iwatch_imghttp://www.iwatch365.com/data/attachment"]) {
        
        CGRect rect = self.window.bounds;
        
        
        [self.dele.navigationController setNavigationBarHidden:YES animated:YES];
        UIView *BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        BGView.backgroundColor = [UIColor blackColor];
        [self.window addSubview:BGView];
        BGView.userInteractionEnabled = YES;
        
        
        UIScrollView * sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, BGView.frame.size.width, BGView.frame.size.height)];
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
        UILabel *  pageForPic = [[UILabel alloc]initWithFrame:CGRectMake((sc.frame.size.width - 80)/2, sc.frame.size.height - 45, 80, 30)];
        pageForPic.textColor = [UIColor whiteColor];
        pageForPic.textAlignment = NSTextAlignmentCenter;
        pageForPic.text = [NSString stringWithFormat:@"%d/%d",MM+1,self.urlArray.count];
        [BGView addSubview:pageForPic];
        
        [sc addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    }
}
@end
