//
//  SelectViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SelectViewController.h"
#import "SelectSubViewController.h"
#import "SelectResultViewController.h"
#import "ShaixuanViewController.h"
@interface SelectViewController () {
    UITableView *mTableView;
}

@property (nonatomic, strong) NSMutableArray *mArray;

@end

@implementation SelectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        NSArray *array = @[@"品牌",@"价格",@"机芯类型",@"性别",@"表壳材质",@"表盘颜色",@"表盘形状",@"表盘直径",@"复杂功能"];
        for (NSString *name in array) {
            [self.mArray addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择筛选条件";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    [self AddRightTextBtn:@"确定" target:self action:@selector(OnSelectClick)];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    mTableView.dataSource = self;
    mTableView.delegate = self;
    mTableView.backgroundColor = [UIColor clearColor];
    mTableView.separatorColor = [UIColor colorWithRed:245.0/256 green:245.0/256 blue:221.0/256 alpha:1];
    [self.view addSubview: mTableView];
}

- (void)dealloc {
    self.mArray = nil;
}

- (void)OnSelectClick {
    ShaixuanViewController *ctrl = [[ShaixuanViewController alloc] init];
    ctrl.conditionArray = self.mArray;
    [self.navigationController pushViewController:ctrl animated:YES];
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    NSDictionary *dict = [self.mArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"name"];
    cell.detailTextLabel.text = [dict objectForKey:@"select"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dict = [self.mArray objectAtIndex:indexPath.row];
    
    SelectSubViewController *ctrl = [[SelectSubViewController alloc] init];
    ctrl.title = [dict objectForKey:@"name"];
    ctrl.mDict = dict;
    ctrl.miType = indexPath.row;
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mTableView reloadData];
    NSLog(@"%@", self.mArray);
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
