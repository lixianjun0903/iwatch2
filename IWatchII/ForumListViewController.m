//
//  ForumListViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ForumListViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "ForumListView.h"
#import "FatieViewController.h"
#import "LoginViewController.h"
@interface ForumListViewController () {
    TypeSelectView *mSelectView;
    ForumListView *mListView;
    UILabel *mlbCount;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;

@end

@implementation ForumListViewController

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
    [self Cancel];
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
    [self StopLoading];
    self.mDownManager = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = [NSString stringWithFormat:@"%@论坛",self.mInfo.name];
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    mSelectView = [[TypeSelectView alloc] initWithFrame:CGRectMake(5, 8, self.view.frame.size.width-10, 34)];
    mSelectView.delegate = self;
    mSelectView.OnTypeSelect = @selector(OnTypeSelect:);
    mSelectView.miLeft = 0;
    mSelectView.miTop = 0;
    mSelectView.miIndex = 0;
    mSelectView.mArray = @[@"最后回复", @"最新发布", @"精华帖"];
    [self.view addSubview:mSelectView];
    [mSelectView reloadData];
    
    UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-48, self.view.frame.size.width, 48)];
    botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    botView.image = [UIImage imageNamed:@"q_16.png"];
    botView.userInteractionEnabled = YES;
    [self.view addSubview:botView];
    
    
    
    
    mlbCount = [[UILabel alloc] initWithFrame:CGRectMake((botView.frame.size.width-120)/2, 5, 120, botView.frame.size.height-5)];
    mlbCount.backgroundColor = [UIColor clearColor];
    mlbCount.textAlignment = UITextAlignmentCenter;
    mlbCount.font = [UIFont systemFontOfSize:12];
    mlbCount.textColor = [UIColor grayColor];
    [botView addSubview:mlbCount];
    
    
    UIButton *fatieBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 50, 9, 40, 30)];
    [fatieBtn setBackgroundImage:[UIImage imageNamed:@"q_21.png"] forState:UIControlStateNormal];
    [fatieBtn addTarget:self action:@selector(fatieClick) forControlEvents:UIControlEventTouchDown];
    [botView addSubview:fatieBtn];
    
    [self OnTypeSelect:mSelectView];
    [self LoadForumCount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fatietip) name:@"fatietip" object:nil];
}
-(void)fatieClick
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
        FatieViewController *vc = [[FatieViewController alloc]init];
        vc.bID = self.mInfo.fid;
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(void)fatietip
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"发帖成功";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}
- (UIImage *)TypeUnSelectImage:(TypeSelectView *)selectView :(int)index {
    NSString *imagename = [NSString stringWithFormat:@"f_tabselect0%d", index+1];
    return [UIImage imageNamed:imagename];
}

- (UIImage *)TypeSelectImage:(TypeSelectView *)selectView :(int)index {
    NSString *imagename = [NSString stringWithFormat:@"f_tabselect1%d", index+1];
    return [UIImage imageNamed:imagename];
}

- (void)OnTypeSelect:(TypeSelectView *)sender {
    if (mListView) {
        [mListView removeFromSuperview];
        mListView = nil;
    }
    mListView = [[ForumListView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-98)];
    mListView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mListView.backgroundColor = [UIColor clearColor];
    mListView.mRootCtrl = self;
    mListView.bID = self.bID;
    [self.view addSubview: mListView];
    int iType = 7;
    if (sender.miIndex == 1) {
        iType = 18;
    }
    if (sender.miIndex == 2) {
        iType = 13;
    }
    [mListView RefreshView:self.mInfo.fid type:iType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ImageDownManager

- (void)Cancel {
    self.mDownManager.delegate = nil;
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadForumCount {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=11&fid=%@", SERVER_URL, self.mInfo.fid];
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
            NSDictionary *dict1 = [array objectAtIndex:0];
            int iNum = [[dict1 objectForKey:@"num"] intValue];
            mlbCount.text = [NSString stringWithFormat:@"共%d贴", iNum];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
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
