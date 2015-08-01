//
//  ImageDisplayViewController.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ImageDisplayViewController.h"
#import "SizeImageView.h"
#import "NetImageView.h"
#import "SizeImageView.h"
@interface ImageDisplayViewController ()<UIAlertViewDelegate>
{
    UIScrollView *sc;
    UIImage *tempImage;
}
@end

@implementation ImageDisplayViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"查看大图";
    
    [self AddLeftImageBtn:[UIImage imageNamed:@"f_btnback01"] target:self action:@selector(GoBack)];
    sc = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    sc.showsHorizontalScrollIndicator =NO;
    sc.pagingEnabled = YES;
    [self.view addSubview:sc];
}
-(void)loadPics:(int)num
{
    if (num == 1) {
        for (int i = 0; i < self.picArray.count; i++) {
            SizeImageView *imageView = [[SizeImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [imageView getImageFromURL:self.picArray[i]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
            [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [sc addSubview:imageView];
        }
        sc.contentOffset = CGPointMake(self.page *self.view.frame.size.width, 0);
        sc.contentSize = CGSizeMake(self.picArray.count *self.view.frame.size.width, self.view.frame.size.height);
    }
    else if(num == 0)
    {
        for (int i = 0; i < self.picArray.count; i++) {
            
            NSString *imagename = [NSString stringWithFormat:@"watchicon%03d.png", i%4+1];
            SizeImageView *imageView = [[SizeImageView alloc]initWithFrame:CGRectMake(i * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [imageView ShowLocalImage:[UIImage imageNamed:imagename]];
            [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
            [imageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [sc addSubview:imageView];
        }
        sc.contentOffset = CGPointMake(self.page *self.view.frame.size.width, 0);
        sc.contentSize = CGSizeMake(8 *self.view.frame.size.width, self.view.frame.size.height);
    }
    
}
-(void)tap:(UITapGestureRecognizer *)sender
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        SizeImageView *imageView = (SizeImageView *)sender.view;
        tempImage = imageView.mZoomView.image;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定保存图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [al show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else
    {
        if (tempImage != nil) {
            UIImageWriteToSavedPhotosAlbum(tempImage, nil, nil,nil);
        }
    }

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
