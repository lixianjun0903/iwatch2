//
//  ArticleListView.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-11-1.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ArticleListView.h"
#import "ArticleListViewCell.h"
#import "ArticleScrollViewCell.h"
#import "ArticleDetailViewController.h"
#import "JSON.h"
#import "ArticleListInfo.h"

@implementation ArticleListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mbReload = YES;
        miPage = 0;
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        
        mTableView = [[RefreshTableView alloc] initWithFrame:self.bounds];
        mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        mTableView.backgroundColor = [UIColor whiteColor];
        mTableView.delegate = self;
        mTableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
        mTableView.backgroundColor = [UIColor whiteColor];
        [self addSubview: mTableView];
    }
    return self;
}
-(void)dealloc
{
     self.mDownManager.delegate = nil;
    [self StopLoading];
    self.mDownManager = nil;
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else {
        return self.mArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 180;
    }
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"CellIdentifier%d", indexPath.section];
    if (indexPath.section == 0) {
        ArticleScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ArticleScrollViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self.mRootCtrl;
//            [cell loadData:self.mCatID];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        NSLog(@"mbReload = %d", mbReload);
        [cell loadData:self.mCatID refresh:mbReload];
        return cell;
    }
    else {
        ArticleListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ArticleListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        ArticleListInfo *info = [self.mArray objectAtIndex:indexPath.row];
        [cell LoadContent:info];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        
    }
    else {
        ArticleDetailViewController *ctrl = [[ArticleDetailViewController alloc] init];
        ctrl.hidesBottomBarWhenPushed = YES;
        ctrl.mInfo = [self.mArray objectAtIndex:indexPath.row];
        ctrl.mCatID = self.mCatID;
        [self.mRootCtrl.navigationController pushViewController:ctrl animated:YES];
    }
}


#pragma mark - ImageDownManager

- (void)Cancel {
//    [self StopLoading];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"finishloading" object:nil];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadArticleList {
    if (_mDownManager) {
        return;
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"isloading" object:nil];
//    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=26&uid=1&p=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=26&uid=%@&p=%d", SERVER_URL, self.mCatID, miPage+1];
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
        if (array && [array isKindOfClass:[NSArray class]]) {
            NSLog(@"%@", array);
            if (miPage == 0) {
                [self.mArray removeAllObjects];
            }
            for (NSDictionary *tmpdict in array) {
                ArticleListInfo *info = [ArticleListInfo CreateWithDict:tmpdict];
                [self.mArray addObject:info];
            }
            miPage ++;
            mTableView.mbMoreHidden = (array.count < 10);
            [mTableView FinishLoading];
            [mTableView reloadData];
            
            [self performSelector:@selector(SetReloadDelay) withObject:nil afterDelay:0.5];
        }
    }
}

- (void)SetReloadDelay {
    NSLog(@"mbReload = NO");
    mbReload = NO;
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}


#pragma mark - RefreshTableView

- (void)ReloadList:(RefreshTableView *)sender {
    miPage = 0;
    mbReload = YES;
    [self LoadArticleList];
}

- (void)LoadMoreList:(RefreshTableView *)sender {
    [self LoadArticleList];
}

- (BOOL)CanRefreshTableView:(RefreshTableView *)sender {
    return !self.mDownManager;
}

- (void)RefreshView:(NSString *)catid {
    self.mCatID = catid;
    [self ReloadList:mTableView];
}

@end
