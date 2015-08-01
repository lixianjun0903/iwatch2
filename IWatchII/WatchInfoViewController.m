//
//  WatchInfoViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "WatchInfoViewController.h"
#import "TypeSelectView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "SeriesTableViewCell.h"
#import "SeriesDetailViewController.h"
#import "AllWatchViewController.h"
#import "SelectViewController.h"
#import "DealerViewController.h"
#import "BriefViewController.h"
@interface WatchInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation WatchInfoViewController

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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"筛选" target:self action:@selector(OnSelectClick)];

    [self createTableView];

    
    [self loadData];
    
    TypeSelectView *topView = [[TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    topView.delegate = self;
    topView.OnTypeSelect = @selector(OnTypeSelect:);
    topView.mArray = @[@"系列", @"全部表款", @"经销商", @"简介"];
    topView.miIndex = 0;
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

-(void)dealloc
{
    self.dataArray = nil;
    self.mDownManager = nil;
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=25
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=33&fid=%@", SERVER_URL,self.seriesId];
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
            
            self.dataArray = [NSMutableArray arrayWithCapacity:0];
            [self.dataArray addObjectsFromArray:array];
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
-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-35) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeriesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    if (cell == nil) {
        cell = [[SeriesTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellIdentifier"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    [cell ShowContent:dic];

    return cell;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SeriesDetailViewController *vc = [[SeriesDetailViewController alloc]init];
    vc.seriesID = self.dataArray[indexPath.row][@"id"];
    vc.title = self.dataArray[indexPath.row][@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)OnSelectClick {
    SelectViewController *ctrl = [[SelectViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];

}

- (void)OnTypeSelect:(TypeSelectView *)sender {

    if (sender.miIndex == 1) {
        AllWatchViewController *vc = [[AllWatchViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if(sender.miIndex == 2)
    {
        DealerViewController *vc = [[DealerViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if (sender.miIndex == 3)
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
