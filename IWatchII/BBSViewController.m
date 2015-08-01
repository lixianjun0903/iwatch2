//
//  BBSViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "BBSViewController.h"
#import "BBSTableViewCell.h"
#import "ForumListViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "BBSListInfo.h"

@interface BBSViewController ()<UIAlertViewDelegate>
{
    UITableView *mTableView;
      UIButton *refreshBtn;
    UILabel *tieziCount;
    UILabel *huiyuanCount;
    NSString  *fatieNum;
    NSString * huiyuanNum;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property(nonatomic,strong)ImageDownManager *secDownManager;
@property(nonatomic,strong)ImageDownManager *thirdDownManager;
@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) NSMutableDictionary *mNameDict;

@end

@implementation BBSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //NSString *path = [[NSBundle mainBundle] pathForResource:@"bbslist" ofType:@"plist"];
        self.mDict = [[NSMutableDictionary alloc] init];
        self.mNameDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title = @"爱表族论坛";
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    titleLabel.text = @"爱表族论坛";
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = UITextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:titleLabel];
    
    UIView *numView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    tieziCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 15)];
    tieziCount.text = @"发帖：";
    tieziCount.numberOfLines = 2;
    tieziCount.textAlignment = UITextAlignmentRight;
    tieziCount.font = [UIFont systemFontOfSize:10];
    tieziCount.textColor = [UIColor whiteColor];
    [numView addSubview:tieziCount];
    
    huiyuanCount = [[UILabel alloc]initWithFrame:CGRectMake(0, 15, 150, 15)];
    huiyuanCount.text = @"会员：";
    huiyuanCount.numberOfLines = 2;
    huiyuanCount.textAlignment = UITextAlignmentRight;
    huiyuanCount.font = [UIFont systemFontOfSize:10];
    huiyuanCount.textColor = [UIColor whiteColor];
    [numView addSubview:huiyuanCount];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:numView];
    
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: mTableView];
    
    [self LoadBBSList];
    [self getFatieNum];
    [self getHuiYuanNum];
}

- (void)dealloc {
    self.mNameDict = nil;
    self.mDict = nil;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSArray *keys = [self GetSortKeys:self.mDict];
    NSArray *keys = [self.mDict allKeys];
    NSMutableArray *finalarray = [NSMutableArray arrayWithCapacity:0];
    finalarray = [NSMutableArray arrayWithArray:[self sort:keys]];
    
    NSString *key = [finalarray objectAtIndex:section];
    NSArray *array = [self.mDict objectForKey:key];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mDict.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    NSArray *keys = [self GetSortKeys:self.mDict];
    NSArray *keys = [self.mDict allKeys];
    NSMutableArray *finalarray = [NSMutableArray arrayWithCapacity:0];
    finalarray = [NSMutableArray arrayWithArray:[self sort:keys]];

    NSString *key = [finalarray objectAtIndex:section];
    
    BBSListInfo *info = [self.mNameDict objectForKey:key];
    return info.name;
}
-(NSMutableArray *)sort:(NSArray *)arr
{
    NSMutableArray *tttt = [NSMutableArray arrayWithArray:arr];
    for (int i = arr.count - 1; i > -1; i--) {
        NSString *key = arr[i];
        BBSListInfo *info = [self.mNameDict objectForKey:key];
        if ([info.name hasPrefix:@"顶级"]) {
            NSString *str = arr[i];
            [tttt removeObject:arr[i]];
            [tttt insertObject:str atIndex:0];
//            [tttt addObject:arr[i]];
            continue;
        }
        else if([info.name hasPrefix:@"经典奢华"])
        {
            NSString *str = arr[i];
            [tttt removeObject:arr[i]];
            [tttt insertObject:str atIndex:1];
//            [tttt addObject:arr[i]];
            continue;
        }
        else if([info.name hasPrefix:@"经典豪华"])
        {
            NSString *str = arr[i];
            [tttt removeObject:arr[i]];
            [tttt insertObject:str atIndex:2];//            [tttt addObject:arr[i]];
            continue;
        }
        else if([info.name hasPrefix:@"平易近人"])
        {
            NSString *str = arr[i];
            [tttt removeObject:arr[i]];
            [tttt insertObject:str atIndex:3];
//            [tttt addObject:arr[i]];
            continue;
        }
        else if([info.name hasPrefix:@"爱表族"])
        {
            NSString *str = arr[i];
            [tttt removeObject:arr[i]];
            [tttt insertObject:str atIndex:4];
//            [tttt addObject:arr[i]];
            continue;
        }
        
    }
    return tttt;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    BBSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[BBSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
//    NSArray *keys = [self GetSortKeys:self.mDict];
    NSArray *keys = [self.mDict allKeys];
    NSMutableArray *finalarray = [NSMutableArray arrayWithCapacity:0];
    finalarray = [NSMutableArray arrayWithArray:[self sort:keys]];
    NSString *key = [finalarray objectAtIndex:indexPath.section];
    
    NSArray *array = [self.mDict objectForKey:key];
    [cell ShowContent:[array objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSArray *keys = [self GetSortKeys:self.mDict];
    NSArray *keys = [self.mDict allKeys];
    NSMutableArray *finalarray = [NSMutableArray arrayWithCapacity:0];
    finalarray = [NSMutableArray arrayWithArray:[self sort:keys]];
    
    NSString *key = [finalarray objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
    BBSListInfo *info = [array objectAtIndex:indexPath.row];
    
    ForumListViewController *ctrl = [[ForumListViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.mInfo = info;
    ctrl.bID = key;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (NSArray *)GetSortKeys:(NSDictionary *)dict {
    return [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadBBSList {
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=1", SERVER_URL];
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
        [self.mNameDict removeAllObjects];
        [self.mDict removeAllObjects];
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]]) {

            NSMutableArray *newarray = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *tmpdict in array) {
                if (![tmpdict[@"name"] isEqualToString:@"各地网友分会"]&&![tmpdict[@"name"] isEqualToString:@"表友交流区"]) {
                    [newarray addObject:[BBSListInfo CreateWithDict:tmpdict]];
                }
            }
            for (BBSListInfo *info in newarray) {
                if ([info.fup intValue] == 0) {
                    [self.mDict setObject:[NSMutableArray arrayWithCapacity:10] forKey:info.fid];
                    [self.mNameDict setObject:info forKey:info.fid];
                }
            }
            for (BBSListInfo *info in newarray) {
                if ([info.fup intValue] != 0 &&[info.fid intValue] != 217&&[info.fid intValue] != 110&&[info.fid intValue] != 201) {
                    NSMutableArray *subarray = [self.mDict objectForKey:info.fup];
                    [subarray addObject:info];
                }
            }
            [mTableView reloadData];
        }
    }

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self LoadBBSList];
    }
    else if (buttonIndex == 0)
    {
        refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        refreshBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
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
    self.mDict = [[NSMutableDictionary alloc] init];
    self.mNameDict = [[NSMutableDictionary alloc] init];
    [self LoadBBSList];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新下", nil ];
    [alert show];
}


#pragma mark    每日发帖数目

-(void)getFatieNum
{
    if (_secDownManager) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=15", SERVER_URL];
    self.secDownManager = [[ImageDownManager alloc] init];
    _secDownManager.delegate = self;
    _secDownManager.OnImageDown = @selector(OnLoadFinish1:);
    _secDownManager.OnImageFail = @selector(OnLoadFail1:);
    [_secDownManager GetImageByStr:urlstr];
}

- (void)OnLoadFinish1:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel1];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            fatieNum = array[0][@"num"];
            [self updateFatieNum];
        }
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    self.secDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.secDownManager);
}
-(void)getHuiYuanNum
{
    if (_thirdDownManager) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@json.php?t=16", SERVER_URL];
    self.thirdDownManager = [[ImageDownManager alloc] init];
    _thirdDownManager.delegate = self;
    _thirdDownManager.OnImageDown = @selector(OnLoadFinish2:);
    _thirdDownManager.OnImageFail = @selector(OnLoadFail2:);
    [_thirdDownManager GetImageByStr:urlstr];
}
- (void)OnLoadFinish2:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel2];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            huiyuanNum = array[0][@"num"];
            [self updateHuiyuanNum];
        }
    }
}
- (void)OnLoadFail2:(ImageDownManager *)sender {
    [self Cancel2];
}
- (void)Cancel2 {
    self.thirdDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.thirdDownManager);
}
-(void)updateFatieNum
{
    tieziCount.text = [NSString stringWithFormat:@"发帖：%@",fatieNum];
}
-(void)updateHuiyuanNum
{
    huiyuanCount.text = [NSString stringWithFormat:@"会员：%@",huiyuanNum];
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
