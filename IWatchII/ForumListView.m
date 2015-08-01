//
//  ForumListView.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-30.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ForumListView.h"
#import "ForumDetailViewController.h"
#import "ForumListViewCell.h"
#import "ForumListInfo.h"
#import "JSON.h"
#import "testViewController.h"
@implementation ForumListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        miPage = 0;
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        mTableView = [[RefreshTableView alloc] initWithFrame:self.bounds];
        mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mTableView.delegate = self;
        mTableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
        mTableView.backgroundColor = [UIColor whiteColor];
        [self addSubview: mTableView];
    }
    return self;
}

- (void)dealloc {
    [self Cancel];
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
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    ForumListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ForumListViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.flag = self.miType;
    ForumListInfo *info = [self.mArray objectAtIndex:indexPath.row];
    [cell LoadContent:info];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    ForumDetailViewController *ctrl = [[ForumDetailViewController alloc] init];
//    ctrl.bID = self.bID;
//     ForumListInfo *info = [self.mArray objectAtIndex:indexPath.row];
//    ctrl.fid = info.tid;
//    ctrl.title = info.subject;
//    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
    testViewController *ctrl = [[testViewController alloc] init];
    ctrl.bID = self.bID;
    ForumListInfo *info = [self.mArray objectAtIndex:indexPath.row];
    ctrl.fid = info.tid;
    ctrl.title = info.subject;
    [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadForumCount:(NSString *)fid type:(int)iType {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.net/json/iphone/json.php?t=13&fid=fid&p=pag
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=%d&fid=%@&p=%d", SERVER_URL, iType, fid, miPage+1];
    NSLog(@"%@",urlstr);
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

        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            for (NSDictionary *tmpDict in array) {
                ForumListInfo *info = [ForumListInfo CreateWithDict:tmpDict];
                [self.mArray addObject:info];
            }
        }
        miPage ++;
        mTableView.mbMoreHidden = (array.count < 20);
        [mTableView FinishLoading];
        [mTableView reloadData];
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
        miPage = 0;
        [self LoadForumCount:self.mFid type:self.miType];
    }
    else if (buttonIndex == 0)
    {
        refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        refreshBtn.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
        [refreshBtn addTarget:self action:@selector(refreshAgain) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
        [refreshBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [mTableView addSubview:refreshBtn];
    }
}
-(void)refreshAgain
{
    [refreshBtn removeFromSuperview];
    refreshBtn  = nil;
    [self Cancel];
    miPage = 0;
    [self LoadForumCount:self.mFid type:self.miType];
}

#pragma mark - RefreshTableView 

- (void)ReloadList:(RefreshTableView *)sender {
    miPage = 0;
    [self LoadForumCount:self.mFid type:self.miType];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self LoadForumCount:self.mFid type:self.miType];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !_mDownManager;
}

- (void)RefreshView:(NSString *)fid type:(int)type {
    self.mFid = fid;
    self.miType = type;
    [self ReloadList:mTableView];
}

@end
