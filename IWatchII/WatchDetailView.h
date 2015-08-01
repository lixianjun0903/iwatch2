//
//  WatchDetailView.h
//  IWatchII
//
//  Created by mac on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "DetailModel.h"
#import "WatchDetailViewController.h"

#import "ImageDownManager.h"
#import "JSON.h"
@interface WatchDetailView : UIView<UIAlertViewDelegate>
{
    UIScrollView *mainScroll;
    NetImageView *imageView;
    UILabel *watchSeries;
    UILabel *watchType;
    
    UILabel *mainLandPrice;
    UILabel *HKPrice;
    UILabel *EuropePrice;
//    UIView *picView;
    UILabel *picCount;
    UILabel *type;
    UILabel *brand;
    UILabel *series;
    UILabel *kuansi;
    UILabel *fangsui;
    UILabel *shangshijianjian;
    UILabel *xianliang;
    
    
    
    
    UILabel *material;
    
    
    UILabel *biaojing;
    UILabel *bkchaizhi;
    UILabel *bpcolor;
    UILabel *bpxingzhuang;
    UILabel *houdu;
    UILabel *bdyande;
    UILabel *bjchaizi;
    UILabel *bkleixing;
    UILabel *biaodi;
    UILabel *beimu;
    UILabel *xiangzhuan;
    UILabel *yeguang;
    
    UILabel *jixinleixing;
    UILabel *jixinType;
    UILabel *tianwentairenzheng;
    UILabel *loukong;
    UILabel *donglicb;
    UILabel *rineiwayinji;
    
    
    
    UILabel *dateShow;
    UILabel *weekShow;
    UILabel *monthShow;
    UILabel *yearShow;
    UILabel *bigRili;
    UILabel *wannianli;
    UILabel *yuexiang;
    UILabel *shuangshiqu;
    UILabel *shijieshi;
    UILabel *jishi;
    UILabel *zhuizhen;
    UILabel *donglicunchushow;
    UILabel *changdongli;
    UILabel *guifanzhen;
    UILabel *feifan;
    UILabel *fangci;
    UILabel *tuofeilun;
    UILabel *danwen;
    UILabel *shuangwen;
    UILabel *sanwen;
    UILabel *qiya;
    UILabel *gaodu;
    UILabel *luopan;
    UILabel *quanloukong;
    UILabel *others;
    
    NSArray *array;
    UIView *bottomView;
    
    DetailModel *models;
    UIImage *tempImage;
}
@property(nonatomic,copy)NSString *seriesID;
-(void)config:(DetailModel *)model;
@property(nonatomic,strong)WatchDetailViewController *delegate;


@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic)int TTTTT;
@end
