//
//  WatchDetailViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "WatchDetailViewController.h"
#import "WatchDetailView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "DetailModel.h"

@interface WatchDetailViewController ()
{
    UIActivityIndicatorView *mActView;
}
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property(nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation WatchDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    self.title = @"腕表详情";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    
    [self loadData];
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
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=40&fid=41382
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=40&fid=%@", SERVER_URL,self.watchID];
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
            for (NSDictionary *dic in array) {
                DetailModel *model = [[DetailModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [self.dataArray addObject:model];
            }
//            [mActView stopAnimating];
            [self makeUI];
        }
        else
        {
//            [mActView stopAnimating];
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


-(void)makeUI
{
    WatchDetailView *detailView = [[WatchDetailView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 3)];
    DetailModel *model = self.dataArray[0];
    detailView.delegate = self;
    [detailView config:model];
    detailView.TTTTT = self.type;
    [self.view addSubview:detailView];
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
