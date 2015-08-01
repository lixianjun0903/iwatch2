//
//  ArticleViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ArticleViewController.h"
#import "TypeSelectView.h"
#import "ImageDownManager.h"
#import "JSON.h"
#import "ArticleListView.h"

@interface ArticleViewController ()<UIScrollViewDelegate,UIAlertViewDelegate>
{
    TypeSelectView *mSelectView;
    int num;
    UIScrollView *sc;
    UIButton *refreshBtn;
}

@property (nonatomic, strong) NSMutableArray *mArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;

@end

@implementation ArticleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    num = 0;
    self.title = @"爱表视野";
    
    mSelectView = [[TypeSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 37)];
    mSelectView.delegate = self;
    mSelectView.OnTypeSelect = @selector(OnTypeSelect:);
    mSelectView.miLeft = 5;
    mSelectView.mUnSelectImage = nil;
    mSelectView.miIndex = 0;
    mSelectView.mArray = @[@"最新", @"新闻", @"行情", @"导购", @"报道", @"评测"];
    [self.view addSubview:mSelectView];

    
    
    sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 37, self.view.frame.size.width, self.view.frame.size.height-37)];
    sc.contentSize = CGSizeMake(self.view.frame.size.width * mSelectView.mArray.count, self.view.frame.size.height);
    sc.pagingEnabled = YES;
    sc.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:sc];
    sc.delegate = self;
    
    [mSelectView reloadData];
    [self LoadTabTypes];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isloading) name:@"isloading" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishloading) name:@"finishloading" object:nil];
}
-(void)isloading
{
    [self StartLoading];
}
-(void)finishloading
{
    [self StopLoading];
}
- (void)dealloc {
    self.mArray = nil;
}

- (void)OnTypeSelect:(TypeSelectView *)sender {
    num = sender.miIndex;
    sc.contentOffset = CGPointMake(num*sc.frame.size.width, 0);
    NSLog(@"OnTypeSelect");
    [self RefreshView];
}

- (void)RefreshView {
    @autoreleasepool {
        for (UIView *view in sc.subviews) {
            if ([view isKindOfClass:[ArticleListView class]]) {
                if (view.tag-1000>mSelectView.miIndex+1 || view.tag-1000 < mSelectView.miIndex-1) {
                    [view removeFromSuperview];
                }
            }
        }
    }
    
    
    for (int i = mSelectView.miIndex-1; i <= mSelectView.miIndex+1; i ++) {
        if (i >= 0 && i < self.mArray.count) {
            UIView *view = [sc viewWithTag:i+1000];
            if (!view) {
                NSDictionary *dict = [self.mArray objectAtIndex:i];
                ArticleListView *listView = [[ArticleListView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*i, 0, self.view.frame.size.width, self.view.frame.size.height)];
                listView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                listView.mRootCtrl = self;
                listView.tag = i+1000;
                [sc addSubview:listView];
                [listView RefreshView:[dict objectForKey:@"catid"]];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"scrollViewDidEndDecelerating");
    num = round(scrollView.contentOffset.x/scrollView.frame.size.width);
    NSLog(@"num = %d", num);
    [mSelectView SelectType:num];
    return;
}

#pragma mark - ImageDownManager

- (void)Cancel {
    [self StopLoading];
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)LoadTabTypes {
    if (_mDownManager) {
        return;
    }
     [self StartLoading];
    //www.iwatch365.com/json/iphone/json_watch.php?t=25
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=25", SERVER_URL];
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
            NSLog(@"%@", array);
            NSArray *tempArray = [NSArray arrayWithArray:array];
            
            NSMutableArray *newarray = [NSMutableArray arrayWithCapacity:10];
            NSMutableArray *tempArrayForCatId = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *tmpdict in tempArray) {
                NSString *catname = [tmpdict objectForKey:@"catname"];
                NSString *catid = [tmpdict objectForKey:@"catid"];
                if ([catid intValue] == 0) {
                    catname = @"最新";
                }
                if ([catid intValue] != 23) {
                    [newarray addObject:catname];
                    [tempArrayForCatId addObject:tmpdict];
                }
            }
            [self.mArray removeAllObjects];
            [self.mArray addObjectsFromArray:tempArrayForCatId];
            mSelectView.mArray = newarray;
            mSelectView.miIndex = num;
            [mSelectView reloadData];
            sc.contentSize = CGSizeMake(sc.frame.size.width*newarray.count, sc.frame.size.height);
            [self OnTypeSelect:mSelectView];
        }
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
        [self LoadTabTypes];
    }
    else if (buttonIndex == 0)
    {
        refreshBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        refreshBtn.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
        [refreshBtn addTarget:self action:@selector(refreshAgain) forControlEvents:UIControlEventTouchUpInside];
        [refreshBtn setTitle:@"刷新一下" forState:UIControlStateNormal];
        [refreshBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.view addSubview:refreshBtn];
    }

}
-(void)refreshAgain
{
    [refreshBtn removeFromSuperview];
    refreshBtn  = nil;
    [self Cancel];
    [self LoadTabTypes];
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
