//
//  WhereToBuyViewController.m
//  IWatchII
//
//  Created by mac on 14-11-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "WhereToBuyViewController.h"
#import "ImageDownManager.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RefreshTableView.h"
#import "DealerTableViewCell.h"
#import "SelectViewController.h"
#import "DealerTableViewCell.h"
@interface WhereToBuyViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate>
{
    RefreshTableView *_tableView;
    int mpage;
    BOOL isOpen;
    int mId;
    
    UIActivityIndicatorView *mActView;

}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation WhereToBuyViewController

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
- (void)OnSelectClick {
    
    SelectViewController *ctrl = [[SelectViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"经销商列表";
    isOpen = NO;
    mId = -1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    mpage = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"筛选" target:self action:@selector(OnSelectClick)];
    [self createTableView];
    [self loadData];
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //ttp://www.iwatch365.com/json/iphone/json_watch.php?t=35&fid=99&p=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=35&fid=%@&p=%d&un=%@&uid=%@", SERVER_URL,self.seriesId,mpage + 1,@"0",@"0"];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    mActView.color = [UIColor blackColor];
    mActView.frame = CGRectMake((self.view.frame.size.width-30)/2, (self.view.frame.size.height-30)/2, 30, 30);
    mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    mActView.hidesWhenStopped = YES;
    [mActView startAnimating];
    [self.view addSubview:mActView];
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
            [mActView stopAnimating];
            [_tableView reloadData];
        }
        else
        {
            [mActView stopAnimating];
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
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height )];
    _tableView.delegate =self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
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
    DealerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[DealerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    [cell showContent:self.dataArray[indexPath.row]];
    [cell sendTitle:self.title];
    cell.delegate = self;
    cell.bottomView.hidden = (indexPath.row != mId);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == mId&&isOpen == NO) {
        return 64 + 122;
    }
    return 64;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    isOpen =YES;
    if (mId != indexPath.row) {
        isOpen = NO;
    }
    mId = indexPath.row;
    [tableView reloadData];
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
