//
//  SelectWatchViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SelectWatchViewController.h"
#import "SelectWatchTableViewCell.h"
#import "SelectViewController.h"
#import "SelectTabBar.h"
#import "WatchInfoViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "pinyin.h"
#import "SelectResultViewController.h"
@interface SelectWatchViewController ()<UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITableView *mTableView;
    UISearchBar *_searchBar;
    UIButton *refreshBtn;
}

@property (nonatomic, strong) NSMutableDictionary *mDict;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation SelectWatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=25
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=30", SERVER_URL];
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
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            NSLog(@"%@", array);
            [tempArray removeAllObjects];
            [tempArray addObjectsFromArray:array];
            [self letterArray:tempArray];
            [mTableView reloadData];
            

            NSMutableArray *writefileArray = [NSMutableArray arrayWithCapacity:0];
            NSArray *keys = [self GetSortKeys:self.mDict];
            for (int i =0; i< keys.count; i++) {
                NSString *key = [keys objectAtIndex:i];
                NSArray *array = [self.mDict objectForKey:key];
                [writefileArray addObjectsFromArray:array];
            }
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString*path1=[paths objectAtIndex:0];
            NSString *filename =[path1 stringByAppendingPathComponent:@"personal.plist"];
            [writefileArray writeToFile:filename  atomically:YES];
            
            NSString *name = [NSString stringWithFormat:@"selecttype01.plist"];
            NSString *path = [[NSBundle mainBundle] resourcePath];
            path = [path stringByAppendingPathComponent:name];
            NSMutableArray *ttarray = [NSMutableArray arrayWithCapacity:0];
            [ttarray addObject:@"不限"];
            for (NSDictionary *dic in writefileArray) {
                [ttarray addObject:dic[@"2"]];
            }
            [ttarray writeToFile:path atomically:YES];
       
        }
    }
}

-(void)letterArray:(NSArray *)array
{
    
    NSMutableDictionary *letterDic = [[NSMutableDictionary alloc]init];
    NSMutableArray *letterArray = [NSMutableArray arrayWithCapacity:26];
    for (NSDictionary *dic in array) {
        NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"2"]]];
        if (letterArray == nil) {
            [letterArray addObject:letter];
        }
        else
        {
            int count = 0;
            for (NSString *str in letterArray) {
                if (![str isEqualToString:letter]) {
                    count ++;
                }
            }
            if (count == letterArray.count) {
                [letterArray addObject:letter];
            }
        }
    }
    self.titleArray = [self sort:letterArray];
    for (NSString *str in letterArray) {
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in array) {
            NSString *letter =  [NSString stringWithFormat:@"%c",[ChinesePinyin GetFirstLetter:dic[@"2"]]];
            if ([letter isEqualToString:str]) {
                [tempArray addObject:dic];
            }
        }
        [letterDic setObject:tempArray forKey:str];
    }
    self.mDict = [NSMutableDictionary dictionaryWithDictionary:letterDic];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"网络不给力。。。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"刷新下", nil ];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self loadData];
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
    [self loadData];
}
- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager); 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"腕表品牌大全";

    [self AddRightTextBtn:@"筛选" target:self action:@selector(OnSelectClick)];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _searchBar.delegate = self;
    _searchBar.showsCancelButton = YES;
    _searchBar.inputAccessoryView = [self GetInputAccessoryView];
    _searchBar.placeholder = @"搜索腕表系列、型号…";
    [self.view addSubview:_searchBar];
    
    for(UIView *view in  [[[_searchBar subviews] objectAtIndex:0] subviews]) {
        
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel  setTintColor:[UIColor blackColor]];
            [cancel.titleLabel setTextColor:[UIColor blackColor]];
        }
    }
    
    
    mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-50) style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: mTableView];
    
    
    [self loadData];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    SelectResultViewController *vc = [[SelectResultViewController alloc]init];
    vc.keyword = searchBar.text;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    [_searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
}
- (void)dealloc {
    self.mDict = nil;
}

- (void)OnSelectClick {
    [SelectTabBar Share].hidden = YES;
    SelectViewController *ctrl = [[SelectViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    NSArray *array = [self.mDict objectForKey:key];
    return array.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mDict.count;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.titleArray;
}
-(NSMutableArray *)sort:(NSMutableArray *)marr
{
    for(int i = 0; i < marr.count - 1; i++)
    {
        for( int j = 0 ; j < marr.count - 1 - i; j++ )
        {
            int prev = j;
            int next = j + 1;
            NSString * str_prev = marr[prev];
            NSString * str_next = marr[next];
            if([str_prev compare:str_next] == NSOrderedDescending)
            {
                [marr exchangeObjectAtIndex:prev withObjectAtIndex:next];
            }
        }
    }
        return marr;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:section];
    return key;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    SelectWatchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SelectWatchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
    
    [cell ShowContent:[array objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_searchBar resignFirstResponder];
    
    NSArray *keys = [self GetSortKeys:self.mDict];
    NSString *key = [keys objectAtIndex:indexPath.section];
    NSArray *array = [self.mDict objectForKey:key];
    NSDictionary *dict = [array objectAtIndex:indexPath.row];
    
    WatchInfoViewController *ctrl = [[WatchInfoViewController alloc] init];
    ctrl.seriesId = dict[@"id"];
    ctrl.hidesBottomBarWhenPushed = YES;
    ctrl.title = [dict objectForKey:@"cname"];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (NSArray *)GetSortKeys:(NSDictionary *)dict {
    return [dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
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
