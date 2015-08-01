//
//  RecommandListViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "RecommandListViewController.h"
#import "TouchView.h"
#import "ImageDownManager.h"
#import "RecommandListCell.h"
#import "JSON.h"
#import "RecommandInfo.h"
#import "RecommandDetailViewController.h"

@interface RecommandListViewController () {
    RefreshTableView *mTableView;
    int miPage;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSMutableArray *mArray;

@end

@implementation RecommandListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        miPage = 0;
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
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
-(void)dealloc
{
    [self StopLoading];
    self.mDownManager = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"每日推荐";
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    mTableView = [[RefreshTableView alloc] initWithFrame:self.view.bounds];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mTableView.delegate = self;
    mTableView.separatorColor =  [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: mTableView];
    
    [self ReloadList:mTableView];
}

- (void)OnViewClick {
    [self GoBack];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int iCount = self.mArray.count/2;
    if (self.mArray.count%2 == 1) {
        iCount ++;
    }
    return iCount;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 155;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    RecommandListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RecommandListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.delegate = self;
        cell.OnRecommandSelect = @selector(OnRecommandSelect:);
    }
    cell.tag = indexPath.row+1000;
    RecommandInfo *info1 = nil;
    RecommandInfo *info2 = nil;
    int iCount = indexPath.row*2;
    info1 = [self.mArray objectAtIndex:iCount];
    if (iCount+1<self.mArray.count) {
        info2 = [self.mArray objectAtIndex:iCount+1];
    }
    NSLog(@"iCount:%d", iCount);
    [cell LoadContent:info1 :info2];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)OnRecommandSelect:(RecommandListCell *)sender {
    int index = (sender.tag-1000)*2+sender.miIndex;
    RecommandDetailViewController *ctrl = [[RecommandDetailViewController alloc] init];
    ctrl.mInfo = [self.mArray objectAtIndex:index];
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadRecommandList {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=23&p=%d", SERVER_URL, miPage+1];
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
        if (miPage == 0) {
            [self.mArray removeAllObjects];
        }
        int iCount = 0;
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            for (NSDictionary *tmpDict in array) {
                RecommandInfo *info = [RecommandInfo CreateWithDict:tmpDict];
                [self.mArray addObject:info];
            }
            iCount = array.count;
        }
        miPage ++;
        mTableView.mbMoreHidden = (iCount < 20);
        [mTableView FinishLoading];
        [mTableView reloadData];
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}

#pragma mark - RefreshTableView

- (void)ReloadList:(RefreshTableView *)sender {
    miPage = 0;
    [self LoadRecommandList];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self LoadRecommandList];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !_mDownManager;
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
