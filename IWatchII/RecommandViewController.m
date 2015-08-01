//
//  RecommandViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecommandViewController.h"
#import "RecommandInfoView.h"
#import "RecommandListViewController.h"
#import "RecommandDetailViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"

@interface RecommandViewController ()<UIAlertViewDelegate>
{
    UIScrollView *mScrollView;
    UIButton *refreshBtn;
}

@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end

@implementation RecommandViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"每日爱表";
    
    [self AddRightImageBtn:[UIImage imageNamed:@"f_btnlist"] target:self action:@selector(OnRightClick)];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    int iHeight = window.frame.size.height-44-64;
    
    mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, iHeight)];
    mScrollView.delegate = self;
    mScrollView.pagingEnabled = YES;
    mScrollView.showsHorizontalScrollIndicator = NO;
    mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mScrollView];

    mScrollView.contentSize = mScrollView.frame.size;
    [self LoadFirstPage];
}

- (void)CreateRecommandView:(int)index {
    RecommandInfoView *infoView = (RecommandInfoView *)[mScrollView viewWithTag:index+1000];
    if (!infoView) {
        infoView = [[RecommandInfoView alloc] initWithFrame:CGRectMake(index*mScrollView.frame.size.width, 0, mScrollView.frame.size.width, mScrollView.frame.size.height)];
        infoView.tag = index+1000;
        infoView.delegate = self;
        infoView.OnRecommandSelect = @selector(OnRecommandSelect:);
        [mScrollView addSubview:infoView];
        
        RecommandInfo *info = [self.mArray objectAtIndex:index];
        [infoView LoadContent:info];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = round(scrollView.contentOffset.x/scrollView.frame.size.width);
    int iCount = round(scrollView.contentSize.width/scrollView.frame.size.width);
    if (index >= iCount-1) {
        [self LoadNextPage];
    }
}

- (void)OnRecommandSelect:(RecommandInfoView *)infoView {
    int index = infoView.tag-1000;
    RecommandDetailViewController *ctrl = [[RecommandDetailViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.mInfo = [self.mArray objectAtIndex:index];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)OnRightClick {
    RecommandListViewController *ctrl = [[RecommandListViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadFirstPage {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=20", SERVER_URL];
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
        [self.mArray removeAllObjects];
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            NSDictionary *tmpDict = [array objectAtIndex:0];
            RecommandInfo *info = [RecommandInfo CreateWithDict:tmpDict];
            [self.mArray addObject:info];
            [self CreateRecommandView:0];
            [self LoadNextPage];
        }
    }
}

- (void)LoadNextPage {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    RecommandInfo *info = [self.mArray lastObject];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=22&fid=%@", SERVER_URL, info.fid];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}

- (void)OnLoadFinish2:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            NSDictionary *tmpDict = [array objectAtIndex:0];
            RecommandInfo *info = [RecommandInfo CreateWithDict:tmpDict];
            [self.mArray addObject:info];
            mScrollView.contentSize = CGSizeMake(self.mArray.count*mScrollView.frame.size.width, mScrollView.frame.size.height);
            [self CreateRecommandView:self.mArray.count-1];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新下", nil ];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self LoadFirstPage];
    }
    else if (buttonIndex == 0)
    {
        refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        refreshBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [refreshBtn addTarget:self action:@selector(refreshAgain) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
        [refreshBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:refreshBtn];
    }

}
-(void)refreshAgain
{
    [refreshBtn removeFromSuperview];
    refreshBtn  = nil;
    [self Cancel];
    self.mArray = [NSMutableArray arrayWithCapacity:10];
    [self LoadFirstPage];
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
