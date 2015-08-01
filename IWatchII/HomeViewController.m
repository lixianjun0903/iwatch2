//
//  HomeViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "HomeViewController.h"
#import "SelectWatchViewController.h"
#import "RecommandViewController.h"
#import "SettingViewController.h"
#import "ArticleViewController.h"
#import "BBSViewController.h"

@interface HomeViewController () {
    SelectTabBar *mTabView;
}

@end

@implementation HomeViewController

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
    self.tabBar.alpha = 0.95;
    RecommandViewController *ctrl1 = [[RecommandViewController alloc] init];
    UINavigationController *navCtrl1 = [[UINavigationController alloc] initWithRootViewController:ctrl1];
    ArticleViewController *ctrl2 = [[ArticleViewController alloc] init];
    UINavigationController *navCtrl2 = [[ UINavigationController alloc] initWithRootViewController:ctrl2];
    
    SelectWatchViewController *ctrl3 = [[SelectWatchViewController alloc] init];
    UINavigationController *navCtrl3 = [[ UINavigationController alloc] initWithRootViewController:ctrl3];
    
    BBSViewController *ctrl4 = [[BBSViewController alloc] init];
    UINavigationController *navCtrl4 = [[ UINavigationController alloc] initWithRootViewController:ctrl4];
    
    SettingViewController *ctrl5 = [[SettingViewController alloc] init];
    UINavigationController *navCtrl5 = [[UINavigationController alloc] initWithRootViewController:ctrl5];
    
    NSArray *array = @[navCtrl1, navCtrl2, navCtrl3, navCtrl4, navCtrl5];
    self.viewControllers = array;
    self.selectedIndex = 0;
    
    mTabView = [[SelectTabBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    mTabView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    mTabView.delegate = self;
    [self.tabBar addSubview:mTabView];
    
    NSLog(@"tabbar %@", self.tabBar);
    
    [self OnTabSelect:mTabView];
}

- (void)OnTabSelect:(SelectTabBar *)sender {
    int index = sender.miIndex;
    NSLog(@"OnTabSelect:%d", index);
    self.selectedIndex = index;
    [self.tabBar bringSubviewToFront:mTabView];
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
