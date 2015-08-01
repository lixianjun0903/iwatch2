//
//  DealerViewController.m
//  IWatchII
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "DealerViewController.h"
#import "ImageDownManager.h"
#import "TypeSelectView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "RefreshTableView.h"
#import "DealerTableViewCell.h"
#import "AllWatchViewController.h"
#import "WatchInfoViewController.h"
#import "BriefViewController.h"
#import "SelectViewController.h"
@interface DealerViewController ()<UITableViewDataSource,UITableViewDelegate,RefreshTableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    RefreshTableView *_tableView;
     int mpage;
    int mId;
    UILabel *placeLabel;
    UILabel *cityLabel;
    UIPickerView *sealPlacePickerView;
    UIPickerView *cityPickView;
    UIView *btnBgView;
    NSString *uid;
    NSString *un;
    
    UIActivityIndicatorView *mActView;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic, strong) ImageDownManager *secDownManager;
@property (nonatomic, strong)NSArray *sealPlaceArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
@end

@implementation DealerViewController

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
    self.cityArray = nil;
    self.mDownManager = nil;
    self.secDownManager = nil;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    un= @"0";
    uid = @"0";
    self.cityArray = [NSMutableArray arrayWithCapacity:0];
    NSDictionary *dic = @{@"id": @"0",@"title":@"不限城市"};
    [self.cityArray addObject:dic];
    
    self.sealPlaceArray = @[@"销售点",@"专卖店",@"专柜",@"维修服务"];
    mId = -1;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    mpage = 0;
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"筛选" target:self action:@selector(OnSelectClick)];
    
    [self createChosenView];
    
    [self createTableView];
    [self loadData];
    [self loadCityData];
    
    TypeSelectView *topView = [[TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    topView.delegate = self;
    topView.OnTypeSelect = @selector(OnTypeSelect:);
    topView.mArray = @[@"系列", @"全部表款", @"经销商", @"简介"];
    topView.miIndex = 2;
    [self.view addSubview:topView];
    [topView reloadData];
    
    [self OnTypeSelect:topView];
    
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

-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //ttp://www.iwatch365.com/json/iphone/json_watch.php?t=35&fid=99&p=1
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=35&fid=%@&p=%d&un=%@&uid=%@", SERVER_URL,self.seriesId,mpage + 1,un,uid];
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
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, self.view.frame.size.height - 80)];
    _tableView.delegate =self;
    _tableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}
-(void)tap
{
    [self cancelClick];
    [self cancelClick1];
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
    cell.contentView.userInteractionEnabled = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell showContent:self.dataArray[indexPath.row]];
    [cell sendTitle:self.title];
    cell.delegate = self;
    cell.bottomView.hidden = (indexPath.row != mId);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == mId) {
        return 64 + 122;
    }
    return 64;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self tableView:tableView didDeselectRowAtIndexPath:indexPath];
    [self cancelClickaaa];
    [self cancelClick1aaa];
    if (mId == indexPath.row) {
        mId = indexPath.row;
        
    }
    else
    {
        mId = indexPath.row;
        [tableView reloadData];
    }
    
}
-(void)createChosenView
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.frame.size.width, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.userInteractionEnabled = YES;
    [self.view addSubview:bgView];
    cityLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
    cityLabel.text = @"不限城市";
    cityLabel.font = [UIFont systemFontOfSize:12];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:cityLabel];
    
    placeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2 + 30, 10, 100, 20)];
    placeLabel.text = @"销售点";
    placeLabel.font= [UIFont systemFontOfSize:12];
    placeLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:placeLabel];
    
    
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(110, 10, 30, 20)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"5_06.png"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(cityClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:leftBtn];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(270, 10, 30, 20)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"5_06.png"] forState:UIControlStateNormal];
     [rightBtn addTarget:self action:@selector(placeClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:rightBtn];
    UILabel *line = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width / 2, 10, 1, 20)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line];
    
}
-(void)placeClick
{
    if (cityPickView) {
        [cityPickView removeFromSuperview];
        cityPickView = nil;
        [btnBgView removeFromSuperview];

    }
    btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 40)];
    btnBgView.backgroundColor = [UIColor colorWithRed:241.0/256 green:241.0/256 blue:241.0/256 alpha:1];
    [self.view addSubview:btnBgView];
    
    sealPlacePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    sealPlacePickerView.tag = 1000;
    sealPlacePickerView.userInteractionEnabled = YES;
    sealPlacePickerView.backgroundColor = [UIColor whiteColor];
    sealPlacePickerView.delegate = self;
    sealPlacePickerView.dataSource = self;
    [self.view addSubview:sealPlacePickerView];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnBgView.frame.size.width - 40, 5, 40, 30)];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:confirmBtn];
    
    UIButton *canelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 40, 30)];
    [canelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:canelBtn];
    
}
-(void)confirmClick
{
    [sealPlacePickerView removeFromSuperview];
        sealPlacePickerView = nil;
    [btnBgView removeFromSuperview];
    mpage = 0;
    [self loadData];
    
}
-(void)cancelClick
{
    uid = @"0";
    [sealPlacePickerView removeFromSuperview];
    sealPlacePickerView = nil;
    placeLabel.text = @"销售点";
    [btnBgView removeFromSuperview];
}
-(void)cityClick
{
    if (sealPlacePickerView) {
        [sealPlacePickerView removeFromSuperview];
        sealPlacePickerView = nil;
        [btnBgView removeFromSuperview];
    }
    btnBgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 190, self.view.frame.size.width, 40)];
    btnBgView.backgroundColor = [UIColor colorWithRed:241.0/256 green:241.0/256 blue:241.0/256 alpha:1];
    [self.view addSubview:btnBgView];
    
    cityPickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150)];
    cityPickView.tag = 1001;
    cityPickView.userInteractionEnabled = YES;
    cityPickView.backgroundColor = [UIColor whiteColor];
    cityPickView.delegate = self;
    cityPickView.dataSource = self;
    [self.view addSubview:cityPickView];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(btnBgView.frame.size.width - 40, 5, 40, 30)];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [confirmBtn setTitle:@"完成" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmClick1) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:confirmBtn];
    
    UIButton *canelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 5, 40, 30)];
    [canelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [canelBtn addTarget:self action:@selector(cancelClick1) forControlEvents:UIControlEventTouchUpInside];
    [btnBgView addSubview:canelBtn];

}
-(void)confirmClick1
{
    uid = @"0";
    [cityPickView removeFromSuperview];
    cityPickView = nil;
    [btnBgView removeFromSuperview];
    mpage = 0;
    [self loadData];
}
-(void)cancelClick1
{
    un= @"0";
    [cityPickView removeFromSuperview];
    cityPickView = nil;
    cityLabel.text = @"不限城市";
    [btnBgView removeFromSuperview];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
        return self.sealPlaceArray.count;
    }
    else if(pickerView.tag == 1001)
    {
        return self.cityArray.count;
    }
    return 1;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
        return self.sealPlaceArray[row];
    }
    else if(pickerView.tag == 1001)
    {
        return self.cityArray[row][@"title"];
    }
    return  self.sealPlaceArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 1000) {
        placeLabel.text = self.sealPlaceArray[row];
        uid = [NSString stringWithFormat:@"%d",row];
    }
    else if(pickerView.tag == 1001)
    {
        cityLabel.text = self.cityArray[row][@"title"];
        un = self.cityArray[row][@"id"];
    }
    
}
- (void)OnSelectClick {
   
    SelectViewController *ctrl = [[SelectViewController alloc] init];
    ctrl.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)OnTypeSelect:(TypeSelectView *)sender {

    if (sender.miIndex == 0) {
        WatchInfoViewController *vc = [[WatchInfoViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if (sender.miIndex == 1)
    {
        AllWatchViewController *vc = [[AllWatchViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    else if(sender.miIndex == 3)
    {
        BriefViewController *vc = [[BriefViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }
    
}
-(void)loadCityData
{
    if (_secDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=43
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=43", SERVER_URL];
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
        if (array && [array isKindOfClass:[NSArray class]] && array.count>0) {
            [self.cityArray addObjectsFromArray:array];
        }
    }
}
- (void)OnLoadFail1:(ImageDownManager *)sender {
    [self Cancel1];
}
- (void)Cancel1 {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.secDownManager);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)cancelClickaaa
{
    uid = @"0";
    [sealPlacePickerView removeFromSuperview];
    sealPlacePickerView = nil;
//    placeLabel.text = @"销售点";
    [btnBgView removeFromSuperview];
}
-(void)cancelClick1aaa
{
    un= @"0";
    [cityPickView removeFromSuperview];
    cityPickView = nil;
//    cityLabel.text = @"不限城市";
    [btnBgView removeFromSuperview];
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
