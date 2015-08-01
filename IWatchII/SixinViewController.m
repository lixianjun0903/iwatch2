//
//  SixinViewController.m
//  IWatchII
//
//  Created by xll on 14/11/26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SixinViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RefreshTableView.h"
#import "SixinTableViewCell.h"
#import "SixinDetailViewController.h"
@interface SixinViewController ()<RefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    RefreshTableView * _tableView;
    int mpage;
    
    UIActivityIndicatorView *mActView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation SixinViewController

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
    self.mDownManager.delegate = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的私信";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    mpage = 0;
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self createTableView];
    [self loadData];

    // Do any additional setup after loading the view.
}
- (void)GoBack {
    self.mDownManager.delegate = nil;
//        if (delegate && OnGoBack) {
//            [delegate performSelector:OnGoBack withObject:self];
//        }
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }
}
-(void)createTableView
{
    _tableView = [[RefreshTableView alloc ]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64)];
    _tableView.delegate = self;
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
    SixinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[SixinTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SixinDetailViewController *vc = [[SixinDetailViewController alloc]init];
    vc.dataDic = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(void)loadData
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString * userID = [user objectForKey:@"userID"];
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json.php?t=201&fid=1947&p=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=201&fid=%@&p=%d", SERVER_URL,userID,mpage + 1];
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
            _tableView.mbMoreHidden = (array.count < 10);
            [_tableView FinishLoading];
            NSLog(@"%@", self.dataArray);
            if (self.dataArray.count * 50 < self.view.frame.size.height - 64) {
                _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.dataArray.count * 50);
            }
            else
            {
                _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 64);
            }
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
