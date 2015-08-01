//
//  PicsViewController.m
//  IWatchII
//
//  Created by mac on 14-11-21.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PicsViewController.h"
#import "NetImageView.h"
#import "ImageDisplayViewController.h"
//#import "RefreshTableView.h"
@interface PicsViewController ()
{
    
}
@end

@implementation PicsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)GoBack {
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
    self.title = @"图片展示";
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1.0];
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self makeUI];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    for (int i = 0; i < self.dataArray.count; i ++) {
        NetImageView *imageView = [[NetImageView alloc]initWithFrame:CGRectMake(10 + (i % 4) * ((self.view.frame.size.width - 10)/4), 10 + (i / 4) * ((self.view.frame.size.width - 10)/4), (self.view.frame.size.width - 10) / 4 - 10, (self.view.frame.size.width - 10) / 4 - 10)];
        imageView.backgroundColor = [UIColor whiteColor];
        imageView.mImageType = TImageType_FullFill;
        [imageView GetImageByStr:self.dataArray[i]];
        [self.view addSubview:imageView];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10 + (i % 4) * ((self.view.frame.size.width - 10)/4), 10 + (i / 4) * ((self.view.frame.size.width - 10)/4), (self.view.frame.size.width - 10) / 4 - 10, (self.view.frame.size.width - 10) / 4 - 10)];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100 + i;
        [self.view addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)btn
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    ImageDisplayViewController *vc = [[ImageDisplayViewController alloc]init];
    vc.picArray = self.dataArray;
    vc.page = btn.tag - 100;
    [vc loadPics:1];
    [self.navigationController pushViewController:vc animated:YES];
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
