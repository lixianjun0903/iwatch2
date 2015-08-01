//
//  AllWatchViewController.m
//  IWatchII
//
//  Created by mac on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AllWatchViewController.h"
#import "TypeSelectView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "SeriesDetailTableViewCell.h"
#import "WatchInfoViewController.h"
#import "SelectViewController.h"
#import "RefreshTableView.h"
#import "DealerViewController.h"
#import "BriefViewController.h"
#import "WatchDetailViewController.h"
@interface AllWatchViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>
{
    RefreshTableView *_tableView;
    int mpage;
    
    UIActivityIndicatorView *mActView;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end

@implementation AllWatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    self.dataArray = nil;
    self.mDownManager = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    mpage = 0;
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"筛选" target:self action:@selector(OnSelectClick)];
    
    [self createTableView];
    [self loadData];
    
    TypeSelectView *topView = [[TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    topView.delegate = self;
    topView.OnTypeSelect = @selector(OnTypeSelect:);
    topView.mArray = @[@"系列", @"全部表款", @"经销商", @"简介"];
    topView.miIndex = 1;
    [self.view addSubview:topView];
    [topView reloadData];
    
    [self OnTypeSelect:topView];
}
- (void)GoBack {
    self.mDownManager.delegate = nil;
    //    if (delegate && OnGoBack) {
    //        [delegate performSelector:OnGoBack withObject:self];
    //    }
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
- (void)OnSelectClick {
//    [SelectTabBar Share].hidden = YES;
    SelectViewController *ctrl = [[SelectViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];

}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=25
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=34&p=%d&fid=%@", SERVER_URL,mpage + 1,self.seriesId];
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
            if (mpage == 0) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            mpage ++;
            _tableView.mbMoreHidden = (array.count < 20);
            [_tableView FinishLoading];
            [_tableView reloadData];
        }
        else
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"没有数据";
            hud.margin = 10.f;
            hud.yOffset = 150.f;
            hud.removeFromSuperViewOnHide = YES;
            [hud hide:YES afterDelay:1.5];
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

#pragma mark - RefreshTableView

- (void)ReloadList:(RefreshTableView *)sender {
    mpage = 0;
    [self loadData];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self loadData];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !self.mDownManager;
}
-(void)createTableView
{
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height-35)];
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeriesDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[SeriesDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell showContent:dic];
    
    return cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 88;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchDetailViewController *vc = [[WatchDetailViewController alloc]init];
    NSDictionary *dic = self.dataArray[indexPath.row];
    vc.watchID =dic[@"id"];
    vc.type = 0;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)OnTypeSelect:(TypeSelectView *)sender {
    
    if (sender.miIndex == 0) {
        WatchInfoViewController *vc = [[WatchInfoViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if (sender.miIndex == 2)
    {
        DealerViewController *vc = [[DealerViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if(sender.miIndex == 3)
    {
        BriefViewController *vc = [[BriefViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
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
