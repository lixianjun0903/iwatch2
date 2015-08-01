//
//  ShaixuanViewController.m
//  IWatchII
//
//  Created by mac on 14-11-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShaixuanViewController.h"
#import "SearchResultTableViewCell.h"
#import "WatchDetailViewController.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RefreshTableView.h"
@interface ShaixuanViewController ()<RefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    RefreshTableView *_tableView;
    int mpage;
    BOOL FromHigh;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation ShaixuanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    self.title = @"筛选结果";
    mpage = 0;
    FromHigh = NO;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"高-低" target:self action:@selector(OnSortClick)];
    [self createTableView];
    [self loadData];
}
- (void)OnSortClick {
    [self Cancel];
    FromHigh = !FromHigh;
    mpage = 0;

    [self.dataArray removeAllObjects];
    [self loadData];
    
}

-(void)loadData
{
    
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
//    NSLog(@"%@",self.conditionArray);
    //www.iwatch365.com/json/iphone/json_watch.php?t=32&p=1
    NSString *urlstr;
    if (FromHigh) {
         urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=32&p=%d&uid=price&un=", SERVER_URL,mpage + 1];
    }
    else
    {
         urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=32&p=%d&uid=price&un=desc", SERVER_URL,mpage + 1];
    }
   
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*path=[paths  objectAtIndex:0];
    NSString *filename = [path stringByAppendingPathComponent:@"personal.plist"];
    
    NSMutableArray *array=[[NSMutableArray alloc]initWithContentsOfFile:filename];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableString *selectStr;
    for (NSDictionary *tempDic in self.conditionArray)
    {
        
        if ([tempDic[@"name"] isEqualToString:@"品牌"]) {
            if (tempDic[@"select"] != nil&& ![tempDic[@"select"] isEqualToString:@"不限"]) {
                NSString *str = tempDic[@"select"];
                for (NSDictionary *dic in array) {
                    if ([dic[@"2"] isEqualToString:str]) {
                        NSString *s = [NSString stringWithFormat:@"pinpaiid = %@",dic[@"id"]];
                        selectStr = [NSMutableString stringWithFormat:@"%@ and %@",selectStr,s];
                    }
                }
            }
        }

        if ([tempDic[@"name"] isEqualToString:@"价格"]) {
            if (tempDic[@"select"] != nil &&![tempDic[@"select"] isEqualToString:@"不限"]) {
                NSString *name = [NSString stringWithFormat:@"selecttype02.plist"];
                NSString *path = [[NSBundle mainBundle] resourcePath];
                path = [path stringByAppendingPathComponent:name];
                NSArray *array = [NSArray arrayWithContentsOfFile:path];
                for (int i = 0; i < array.count; i++) {
                    if ([array[i] isEqualToString:tempDic[@"select"]]) {
                        NSString *name1 = [NSString stringWithFormat:@"price.plist"];
                        NSString *path1 = [[NSBundle mainBundle] resourcePath];
                        path1 = [path1 stringByAppendingPathComponent:name1];
                        NSArray *array1 = [NSArray arrayWithContentsOfFile:path1];
                        NSString *str = array1[i];
                        selectStr = [NSMutableString stringWithFormat:@"%@ and %@",selectStr,str];
                    }
                }
            }
        }
        if ([tempDic[@"name"] isEqualToString:@"机型类型"]) {
            if (tempDic[@"select"] != nil&&![tempDic[@"select"] isEqualToString:@"不限"]) {
                selectStr = [NSMutableString stringWithFormat:@"%@ and jxleixing = '%@'",selectStr,tempDic[@"select"]];
            }
        }
        if ([tempDic[@"name"] isEqualToString:@"性别"]) {
            if (tempDic[@"select"] != nil&&![tempDic[@"select"] isEqualToString:@"不限"]) {
                selectStr = [NSMutableString stringWithFormat:@"%@ and kuanshiid = '%@'",selectStr,tempDic[@"select"]];
            }
        }
        if ([tempDic[@"name"] isEqualToString:@"表壳材质"]) {
            if (tempDic[@"select"] != nil&&![tempDic[@"select"] isEqualToString:@"不限"]) {
                selectStr = [NSMutableString stringWithFormat:@"%@ and bkcaizhi = '%@'",selectStr,tempDic[@"select"]];
            }
        }
        if ([tempDic[@"name"] isEqualToString:@"表盘颜色"]) {
            if (tempDic[@"select"] != nil&&![tempDic[@"select"] isEqualToString:@"不限"]) {
                selectStr = [NSMutableString stringWithFormat:@"%@ and bpyanse = '%@'",selectStr,tempDic[@"select"]];
            }
        }
        if ([tempDic[@"name"] isEqualToString:@"表盘形状"]) {
            if (tempDic[@"select"] != nil&&![tempDic[@"select"] isEqualToString:@"不限"]) {
                selectStr = [NSMutableString stringWithFormat:@"%@ and bpxingzhuang = '%@'",selectStr,tempDic[@"select"]];
            }
        }
        if ([tempDic[@"name"] isEqualToString:@"表盘直径"]) {
            if (tempDic[@"select"] != nil&&![tempDic[@"select"] isEqualToString:@"不限"]) {
                NSString *name = [NSString stringWithFormat:@"selecttype08.plist"];
                NSString *path = [[NSBundle mainBundle] resourcePath];
                path = [path stringByAppendingPathComponent:name];
                NSArray *array = [NSArray arrayWithContentsOfFile:path];
                for (int i = 0; i < array.count; i++) {
                    if ([array[i] isEqualToString:tempDic[@"select"]]) {
                        NSString *name1 = [NSString stringWithFormat:@"biaojing.plist"];
                        NSString *path1 = [[NSBundle mainBundle] resourcePath];
                        path1 = [path1 stringByAppendingPathComponent:name1];
                        NSArray *array1 = [NSArray arrayWithContentsOfFile:path1];
                        NSString *str = array1[i];
                        selectStr = [NSMutableString stringWithFormat:@"%@ and %@",selectStr,str];
                    }
                }

            }
        }
        if ([tempDic[@"name"] isEqualToString:@"复杂功能"]) {
            if (tempDic[@"select"] != nil &&![tempDic[@"select"] isEqualToString:@"不限"]) {
                NSString *name = [NSString stringWithFormat:@"selecttype09.plist"];
                NSString *path = [[NSBundle mainBundle] resourcePath];
                path = [path stringByAppendingPathComponent:name];
                NSArray *array = [NSArray arrayWithContentsOfFile:path];
                for (int i = 0; i < array.count; i++) {
                    if ([array[i] isEqualToString:tempDic[@"select"]]) {
                        NSString *name1 = [NSString stringWithFormat:@"gongneng.plist"];
                        NSString *path1 = [[NSBundle mainBundle] resourcePath];
                        path1 = [path1 stringByAppendingPathComponent:name1];
                        NSArray *array1 = [NSArray arrayWithContentsOfFile:path1];
                        NSString *str = array1[i];
                        selectStr = [NSMutableString stringWithFormat:@"%@ and %@",selectStr,str];
                    }
                }
            }
        }
    }
    NSLog(@"%@",selectStr);
    if ([selectStr hasPrefix:@"(null) and"]) {
        NSLog(@"有接头");
    }
    NSArray *aaaa = [selectStr componentsSeparatedByString:@"(null) and"];
    if (aaaa.count == 0) {
        selectStr = [NSMutableString stringWithString:@"1"];
    }
    else
    { selectStr = [aaaa lastObject];
        
    }
   
    [dic setObject:selectStr forKey:@"fid"];
    [_mDownManager PostHttpRequest:urlstr :dic];
    
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
            [_tableView reloadData];
        }
        else
        {
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

- (void)dealloc {
    self.dataArray = nil;
}
-(void)createTableView
{
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _tableView.delegate = self;
    _tableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}
#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
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
    [cell ShowContent:[self.dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WatchDetailViewController *vc = [[WatchDetailViewController alloc]init];
    NSDictionary *dic = self.dataArray[indexPath.row];
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
