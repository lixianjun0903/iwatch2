//
//  SeriesDetailViewController.m
//  IWatchII
//
//  Created by mac on 14-11-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SeriesDetailViewController.h"
#import "SeriesDetailTableViewCell.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "SelectViewController.h"
#import "RefreshTableView.h"
#import "WatchDetailViewController.h"
@interface SeriesDetailViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>
{
    RefreshTableView *_tableView;
    int mpage;
    BOOL FromHigh;
    
    UIActivityIndicatorView *mActView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation SeriesDetailViewController

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
    mpage = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"高-低" target:self action:@selector(OnSortClick)];
    
    
    [self createTableView];
    FromHigh = YES;
    [self loadData];

}
- (void)GoBack {
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
- (void)OnSortClick {
    [self Cancel];
    FromHigh = !FromHigh;
    mpage = 0;
    self.dataArray = nil;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self loadData];

}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=39&fid=99&p=1
    NSString *urlstr;
    if (FromHigh) {
        urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=39&fid=%@&p=%d&uid=price&un=desc", SERVER_URL,self.seriesID,mpage + 1];
    }
    else
    {
        urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=39&fid=%@&p=%d&uid=price&un=", SERVER_URL,self.seriesID,mpage + 1];
    }
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
            NSLog(@"%@", self.dataArray);
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
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 35)];
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
     _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeriesDetailTableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[SeriesDetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell showContent:self.dataArray[indexPath.row]];
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
