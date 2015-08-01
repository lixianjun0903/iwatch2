//
//  SelectResultViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SelectResultViewController.h"
#import "SearchResultTableViewCell.h"
#import "WatchDetailViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
@interface SelectResultViewController ()
{
    RefreshTableView *mTableView;
    
    UIActivityIndicatorView *mActView;
    int cellCount;
    int mpage;
}

@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation SelectResultViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:0];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"watchselect" ofType:@"plist"];
//        NSArray *array = [NSArray arrayWithContentsOfFile:path];
//        if (array) {
//            [self.mArray addObjectsFromArray:array];
//        }
    }
    return self;
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    mpage = 0;
    self.title = @"搜索结果";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    mTableView = [[RefreshTableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mTableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    mTableView.delegate = self;
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: mTableView];
    
    [self loadData];
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=31&fid=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=31&fid=%@&p=%d", SERVER_URL,self.keyword,mpage + 1];
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
//            [mActView stopAnimating];
            if (mpage == 0) {
                [self.mArray removeAllObjects];
            }
            [self.mArray addObjectsFromArray:array];
            mpage ++;
            mTableView.mbMoreHidden = (array.count < 20);
            [mTableView FinishLoading];
            //            [mActView stopAnimating];
            [mTableView reloadData];
        }
        else
        {
//            [mActView stopAnimating];
            [mTableView FinishLoading];
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
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)dealloc {
    self.mArray = nil;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SearchResultTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell ShowContent:[self.mArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchDetailViewController *vc = [[WatchDetailViewController alloc]init];
    NSDictionary *dic = self.mArray[indexPath.row];
    vc.watchID =dic[@"id"];
    vc.type = 1;
    [self.navigationController pushViewController:vc animated:YES];
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
