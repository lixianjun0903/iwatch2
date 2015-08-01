//
//  HuifuViewController.m
//  IWatchII
//
//  Created by mac on 14-11-14.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HuifuViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RefreshTableView.h"
#import "TieZiTableViewCell.h"
#import "testViewController.h"
#import "TieziViewController.h"
@interface HuifuViewController ()<RefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    RefreshTableView * _tableView;
    int mpage;
    
    UIButton *fabiaoBtn;
    UIButton *huifuBtn;
    UIView *line;
    
    UIActivityIndicatorView *mActView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation HuifuViewController

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
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    mpage = 0;
    
    
    
    UIView *chosenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 30)];
    
    fabiaoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, 30)];
    [fabiaoBtn setTitle:@"我发表的" forState:UIControlStateNormal];
    [fabiaoBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    fabiaoBtn.selected = NO;
    [fabiaoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [fabiaoBtn addTarget:self action:@selector(fabiaoClick) forControlEvents:UIControlEventTouchUpInside];
    [chosenView addSubview:fabiaoBtn];
    line = [[UIView alloc]initWithFrame:CGRectMake(chosenView.frame.size.width/2, 5, 1, 20)];
    line.backgroundColor = [UIColor whiteColor];
    [chosenView addSubview:line];
    
    huifuBtn = [[UIButton alloc]initWithFrame:CGRectMake(80, 0, 80, 30)];
    [huifuBtn addTarget:self action:@selector(huifuClick) forControlEvents:UIControlEventTouchUpInside];
    [huifuBtn setTitle:@"我回复的" forState:UIControlStateNormal];
    [huifuBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    huifuBtn.selected = YES;
    [huifuBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [chosenView addSubview:huifuBtn];
    self.navigationItem.titleView = chosenView;
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self createTableView];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)fabiaoClick
{
    fabiaoBtn.selected = YES;
    huifuBtn.selected = NO;
    TieziViewController *vc = [[TieziViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
}
-(void)huifuClick
{
    fabiaoBtn.selected = NO;
    huifuBtn.selected = YES;
    
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
    TieZiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[TieZiTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    [cell config:self.dataArray[indexPath.row]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    testViewController *vc = [[testViewController alloc]init];
    vc.fid = self.dataArray[indexPath.row][@"tid"];
    [self.navigationController pushViewController:vc animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}
-(void)loadData
{
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString * userID = [user objectForKey:@"userID"];
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.net/json/iphone/json.php?t=5&fid=fid&p=page
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=6&fid=%@&p=%d", SERVER_URL,userID,mpage + 1];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
//    mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    mActView.color = [UIColor blackColor];
//    mActView.frame = CGRectMake((self.view.frame.size.width-30)/2, (self.view.frame.size.height-30)/2, 30, 30);
//    mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
//    mActView.hidesWhenStopped = YES;
//    [mActView startAnimating];
//    [self.view addSubview:mActView];

    
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
//            [mActView stopAnimating];
            [_tableView reloadData];
        }
        else
        {
//            [mActView stopAnimating];
             [_tableView FinishLoading];
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
