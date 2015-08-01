//
//  BriefViewController.m
//  IWatchII
//
//  Created by mac on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//
#define iOS7   [[UIDevice currentDevice]systemVersion].floatValue>=7.0
#import "BriefViewController.h"
#import "AllWatchViewController.h"
#import "WatchInfoViewController.h"
#import "SelectViewController.h"
#import "DealerViewController.h"
#import "ImageDownManager.h"
#import "TypeSelectView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "NetImageView.h"
@interface BriefViewController ()<UIWebViewDelegate>
{
    UILabel *titleLabel;
    UILabel *cName;
    UILabel *eName;
    UILabel *birthDay;
    UILabel *birthPlace;
    NetImageView *imageView;
    UIWebView *desc;
    UIActivityIndicatorView *mActView;
}
@property(nonatomic,strong)NSMutableDictionary *dataDic;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@end

@implementation BriefViewController

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
    self.dataDic = [[NSMutableDictionary alloc]initWithCapacity:0];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"筛选" target:self action:@selector(OnSelectClick)];
    
    [self makeUI];
    [self loadData];
    
    TypeSelectView *topView = [[TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 35)];
    topView.delegate = self;
    topView.OnTypeSelect = @selector(OnTypeSelect:);
    topView.mArray = @[@"系列", @"全部表款", @"经销商", @"简介"];
    topView.miIndex = 3;
    [self.view addSubview:topView];
    [topView reloadData];
    
    [self OnTypeSelect:topView];
}
- (void)GoBack {
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
    else if (sender.miIndex == 2)
    {
        DealerViewController *vc = [[DealerViewController alloc]init];
        vc.seriesId = self.seriesId;
        vc.title = self.title;
        [self.navigationController pushViewController:vc animated:NO];
    }

    
}
-(void)loadData
{
    if (_mDownManager) {
        return;
    }
    [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=38&fid=164
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=38&fid=%@", SERVER_URL,self.seriesId];
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
            self.dataDic = array[0];
//            [mActView stopAnimating];
            [self refreshUI];
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
-(void)refreshUI
{
    
    titleLabel.text = [NSString stringWithFormat:@"%@腕表",self.dataDic[@"4"]];
    cName.text = [NSString stringWithFormat:@"中文名称：%@",self.dataDic[@"cname"]];
    eName.text = [NSString stringWithFormat:@"英文名称：%@",self.dataDic[@"ename"]];
    birthDay.text = [NSString stringWithFormat:@"创建时间：%@年",self.dataDic[@"ctime"]];
    birthPlace.text = [NSString stringWithFormat:@"发源地：%@",self.dataDic[@"guojia"]];
    [imageView GetImageByStr:self.dataDic[@"0"]];
    NSString *content = self.dataDic[@"content"];
    content = [content stringByReplacingOccurrencesOfString:@"width" withString:@"\"width1: "];
    content = [content stringByReplacingOccurrencesOfString:@"height" withString:@" height1: "];
    
     content = [NSString stringWithFormat:@"<html><head><style type=\"text/css\">img {width: 95%%}</style></head><body><span style=\"line-height:23px\">%@</span></body></html>" ,content];
    
    
    [desc loadHTMLString:content baseURL:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    desc.scrollView.contentOffset = CGPointMake(0, -435);
}

-(void)makeUI
{
    
    desc = [[UIWebView alloc]initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height-35)];
    desc.delegate = self;
    desc.backgroundColor = [UIColor whiteColor];
    desc.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    desc.opaque = NO;
    desc.scrollView.contentInset = UIEdgeInsetsMake(435, 0, 50, 0);
    [self.view addSubview:desc];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -435, self.view.frame.size.width, 435)];
    [desc.scrollView addSubview:bgView];
    
    titleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, 240, 60)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont boldSystemFontOfSize:25];
    titleLabel.numberOfLines = 2;
    [bgView addSubview:titleLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 85 + 30, 290, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgView addSubview:line];
    
    cName = [[UILabel alloc]initWithFrame:CGRectMake(15, 135, 290, 20)];
    cName.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:cName];
    
    eName = [[UILabel alloc]initWithFrame:CGRectMake(15, 160, 290, 20)];
    eName.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:eName];
    
    birthDay = [[UILabel alloc]initWithFrame:CGRectMake(15, 185, 290, 20)];
    birthDay.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:birthDay];
    
    birthPlace = [[UILabel alloc]initWithFrame:CGRectMake(15, 210, 290, 20)];
    birthPlace.textAlignment = NSTextAlignmentLeft;
    [bgView addSubview:birthPlace];
    
    imageView = [[NetImageView alloc]initWithFrame:CGRectMake(60, 255, 200, 110)];
    imageView.mDefaultImage = [UIImage imageNamed:@"watch004.png"];
    [bgView addSubview:imageView];
    
    UILabel * descTitle = [[UILabel alloc]initWithFrame:CGRectMake(25, 405, 80, 20)];
    descTitle.textAlignment = NSTextAlignmentLeft;
    descTitle.text = @"品牌介绍";
    [bgView addSubview:descTitle];
    
    UILabel *line_desc = [[UILabel alloc]initWithFrame:CGRectMake(15, 405, 4, 20)];
    line_desc.backgroundColor = [UIColor blackColor];
    [bgView addSubview:line_desc];
    
    
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
