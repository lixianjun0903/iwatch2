//
//  SixinDetailViewController.m
//  IWatchII
//
//  Created by xll on 14/11/26.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SixinDetailViewController.h"

@interface SixinDetailViewController ()

@end

@implementation SixinDetailViewController

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
    self.title = @"私信详情";
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self makeUI];
    [self loadData];
    // Do any additional setup after loading the view.
}
-(void)makeUI
{
    title = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/ 2 - 100, 20, 200, 30)];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:title];
    
    
    desc = [[UILabel alloc]initWithFrame:CGRectMake(10, 55, self.view.frame.size.width - 20, 60)];
    desc.font = [UIFont systemFontOfSize:12];
    desc.numberOfLines = 0;
    desc.textColor = [UIColor lightGrayColor];
    [self.view addSubview:desc];
    
    author = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width -200, 120, 190, 30)];
    author.textAlignment = NSTextAlignmentRight;
    author.textColor = [UIColor lightGrayColor];
    author.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:author];
}
-(void)loadData
{
    title.text = self.dataDic[@"subject"];
//    desc.text = self.dataDic[@"message"];
    NSString *str = self.dataDic[@"message"];
    CGSize size;

    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        size = [str boundingRectWithSize:CGSizeMake(self.view.frame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil].size;
    }else{
        size = [str sizeWithFont:[UIFont systemFontOfSize:12]constrainedToSize:CGSizeMake(self.view.frame.size.width, 1000)];
    }
    desc.frame = CGRectMake(5, 55, size.width - 10, size.height);
    desc.text = str;
    author.frame = CGRectMake(self.view.frame.size.width -200, 55 + size.height + 5, 190, 30);
    author.text = self.dataDic[@"lastauthor"];
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
