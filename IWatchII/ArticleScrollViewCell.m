//
//  ArticleScrollViewCell.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ArticleScrollViewCell.h"
#import "TouchView.h"
#import "NetImageView.h"
#import "BannerDetalViewController.h"
@implementation ArticleScrollViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 160 + 20)];
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:scrollView];
    
//    for (int i = 0; i < self.dataArray.count; i ++) {
//        NetImageView *imageview = [[NetImageView alloc]initWithFrame:CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height - 20)];
//        imageview.mImageType = TImageType_FullFill;
//        imageview.mDefaultImage = [UIImage imageNamed:@"320_160@2x"];
//        [imageview GetImageByStr:self.dataArray[i][@"thumb"]];
//        imageview.tag = 100 + i;
//        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
//        [scrollView addSubview:imageview];
//        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*scrollView.frame.size.width, 160, scrollView.frame.size.width, 20)];
//        nameLabel.text =
//        [NSString stringWithFormat:@"  %@",self.dataArray[i][@"title"]];
//        nameLabel.font = [UIFont systemFontOfSize:13];
//        nameLabel.textColor = [UIColor blackColor];
//        nameLabel.textAlignment = NSTextAlignmentLeft;
//        [scrollView addSubview:nameLabel];
//
//    }
//    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.dataArray.count, scrollView.frame.size.height);
    
    mPageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, scrollView.frame.size.height-40, scrollView.frame.size.width, 20)];
//    mPageCtrl.numberOfPages = self.dataArray.count;
    mPageCtrl.currentPage = 0;
    [self.contentView addSubview:mPageCtrl];

}
-(void)config
{
    
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < self.dataArray.count; i ++) {
        NetImageView *imageview = [[NetImageView alloc]initWithFrame:CGRectMake(i*scrollView.frame.size.width, 0, scrollView.frame.size.width, scrollView.frame.size.height - 20)];
        imageview.mImageType = TImageType_FullFill;
        imageview.mDefaultImage = [UIImage imageNamed:@"320_160@2x"];
        [imageview GetImageByStr:self.dataArray[i][@"thumb"]];
        imageview.tag = 100 + i;
        [imageview addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)]];
        [scrollView addSubview:imageview];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(i*scrollView.frame.size.width, 160, scrollView.frame.size.width, 20)];
        nameLabel.text =
        [NSString stringWithFormat:@"  %@",self.dataArray[i][@"title"]];
        nameLabel.font = [UIFont systemFontOfSize:13];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [scrollView addSubview:nameLabel];
    }
     scrollView.contentSize = CGSizeMake(scrollView.frame.size.width*self.dataArray.count, scrollView.frame.size.height);
     mPageCtrl.numberOfPages = self.dataArray.count;
}
-(void)loadData:(NSString *)catid refresh:(BOOL)bRefresh
{
//    [self Cancel];
    if (self.mCatID && [self.mCatID isEqualToString:catid] && !bRefresh) {
        return;
    }
    self.mCatID = catid;
    if (_mDownManager) {
        return;
    }
    //www.iwatch365.com/json/iphone/json_watch.php?t=45&fid=0
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=45&fid=%@", SERVER_URL,catid];
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
            self.dataArray = [NSMutableArray arrayWithArray:array];
            [self config];
        }
    }
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    mPageCtrl.currentPage = scrollView.contentOffset.x/scrollView.frame.size.width;
}

- (void)tap:(UITapGestureRecognizer *)sender
{
    BannerDetalViewController *vc = [[BannerDetalViewController alloc]init];
    vc.dataArray = self.dataArray;
    vc.page = sender.view.tag - 100;
    vc.hidesBottomBarWhenPushed = YES;
    [_delegate.navigationController pushViewController:vc animated:YES];

}
-(void)dealloc
{
    _mDownManager.delegate = nil;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
