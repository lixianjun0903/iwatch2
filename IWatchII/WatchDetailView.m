//
//  WatchDetailView.m
//  IWatchII
//
//  Created by mac on 14-11-13.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//
#define WIDTH self.frame.size.width
#define HEIGHT self.frame.size.height
#import "WatchDetailView.h"
#import "MyControl.h"
#import "WhereToBuyViewController.h"
#import "PicsViewController.h"
#import "SizeImageView.h"
#import "NSString+FormatNSString.h"
@implementation WatchDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)addTip
{
    UIView *v = (UIView *)[mainScroll viewWithTag:10000];
    v.frame = CGRectMake(0, 180 + 315 - 80, WIDTH, 900);
    UIView *vv = (UIView *)[mainScroll viewWithTag:10001];
    vv.frame = CGRectMake(10,315 + 180 + 900 + 10 - 80, 300, 40);
    mainScroll.contentSize = CGSizeMake(WIDTH, 2400 - 80);
}
-(void)picBtn
{
    PicsViewController *vc = [[PicsViewController alloc]init];
    vc.dataArray = self.dataArray;
    [_delegate.navigationController pushViewController:vc animated:YES];
}
-(void)addSC
{
    
    UIView *photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 85, WIDTH, 80)];
    photoView.userInteractionEnabled = YES;
    photoView.backgroundColor = [UIColor colorWithRed:220.0/256 green:220.0/256 blue:220.0/256 alpha:1];
    [bottomView addSubview:photoView];
    
    UIImageView *rightview = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 30, 30, 15, 20)];
    rightview.image = [UIImage imageNamed:@"df_29.png"];
//    [photoView addSubview:rightview];


    for (int i =0 ; i < self.dataArray.count; i ++) {
        if (i >= 4) {
            break;
        }
        NetImageView *pics = [[NetImageView alloc]initWithFrame:CGRectMake(10 + 68 * i, 10, 60, 60)];
        [pics GetImageByStr:self.dataArray[i]];
        [photoView addSubview:pics];
    }
    UIView *aaa = [[UIView alloc]initWithFrame:CGRectMake(WIDTH - 40, 25, 30, 30)];
    aaa.layer.cornerRadius = 15;
    aaa.clipsToBounds = YES;
    aaa.backgroundColor = [UIColor colorWithRed:246.0 / 256 green:246.0 / 256 blue:246.0 / 256 alpha:1];
    [photoView addSubview:aaa];
    
    picCount = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH - 40, 25, 30, 30)];
    picCount.textAlignment = NSTextAlignmentLeft;
    picCount.text = [NSString stringWithFormat:@"%d",self.dataArray.count];
    picCount.textColor = [UIColor lightGrayColor];
    picCount.textAlignment = NSTextAlignmentCenter;
    [photoView addSubview:picCount];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(0, 75, WIDTH, 80)];
    [btn addTarget:self action:@selector(picBtn) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:btn];
}
- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array1 = [dict objectForKey:@"data"];
        if (array1 && [array1 isKindOfClass:[NSArray class]] && array1.count>0) {
            self.dataArray = [NSMutableArray arrayWithArray:array1];
            [self addSC];
        }
        else
        {
            [self addTip];
        }
    }
}

- (void)OnLoadFail:(ImageDownManager *)sender {
    [self Cancel];
}
- (void)Cancel {
    SAFE_CANCEL_ARC(self.mDownManager);
}

-(void)loadData:(DetailModel*)model
{
    if (_mDownManager) {
        return;
    }
//    www.iwatch365.com/json.php?t=44&fid=AL&uid=704.048F
    NSString *urlstr = [NSString stringWithFormat:@"http://www.iwatch365.com/json.php?t=44&fid=%@&uid=%@", model.pinpaisuoxie, model.xinghao];
//    NSString *urlstr = [NSString stringWithFormat:@"http://www.iwatch365.com/json.php?t=44&fid=VC&uid=89600_000P-9878"];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}
-(void)makeUI
{
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64)];
    [self addSubview:mainScroll];
    mainScroll.showsVerticalScrollIndicator = NO;
    mainScroll.autoresizesSubviews = NO;
    if (self.TTTTT == 0) {
        mainScroll.contentSize = CGSizeMake(WIDTH, 2400);
    }
    else
    {
        mainScroll.contentSize = CGSizeMake(WIDTH, 2200);
    }
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 315)];
    topView.backgroundColor = [UIColor whiteColor];
    [mainScroll addSubview:topView];
    UIImageView *shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 275, WIDTH,20)];
    shadowImageView.image = [UIImage imageNamed:@"shadow.png"];
//    [topView addSubview:shadowImageView];
    
    imageView = [[NetImageView alloc]initWithFrame:CGRectMake((self.frame.size.width - 180)/2, 5, 180, 243)];
    imageView.mDefaultImage = [UIImage imageNamed:@"230.png"];
    imageView.mImageType = TImageType_FullFill;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    [topView addSubview:imageView];
    watchSeries = [[UILabel alloc]initWithFrame:CGRectMake(15, 260, self.frame.size.width - 30, 45)];
    watchSeries.font = [UIFont boldSystemFontOfSize:18];
    watchSeries.numberOfLines = 2;
    watchSeries.textAlignment = NSTextAlignmentLeft;
    [topView addSubview:watchSeries];

    
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 315, WIDTH, 180)];
    bottomView.backgroundColor = [UIColor colorWithRed:246.0 / 256 green:246.0 / 256 blue:246.0 / 256 alpha:1];
    [mainScroll addSubview:bottomView];
    
    mainLandPrice = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 90, 20)];
    mainLandPrice.textAlignment = NSTextAlignmentCenter ;
    mainLandPrice.textColor = [UIColor redColor];
    mainLandPrice.font = [UIFont boldSystemFontOfSize:17];
    [bottomView addSubview:mainLandPrice];
    UILabel *mainLandLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, 40, 90, 15)];
    mainLandLabel.textAlignment = NSTextAlignmentCenter;
    mainLandLabel.textColor = [UIColor lightGrayColor];
    mainLandLabel.font = [UIFont systemFontOfSize:12];
    mainLandLabel.text = @"￥中国大陆售价";
    [bottomView addSubview:mainLandLabel];
    
    HKPrice = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 3 +10, 15, 90, 20)];
    HKPrice.textAlignment = NSTextAlignmentCenter;
    HKPrice.textColor = [UIColor redColor];
    HKPrice.font = [UIFont boldSystemFontOfSize:17];
    [bottomView addSubview:HKPrice];
    
    UILabel *  HKLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 3 + 15, 40, 90, 15)];
    HKLabel.textAlignment = NSTextAlignmentCenter;
    HKLabel.textColor =[UIColor lightGrayColor];
    HKLabel.font = [UIFont systemFontOfSize:12];
    HKLabel.text = @"HK$香港售价";
    [bottomView addSubview:HKLabel];
    
    EuropePrice =[[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 3 * 2 + 10, 15, 90, 20)];
    EuropePrice.textAlignment = NSTextAlignmentCenter;
    EuropePrice.textColor = [UIColor redColor];
    EuropePrice.font = [UIFont boldSystemFontOfSize:17];
    [bottomView addSubview:EuropePrice];
    
    UILabel *  EuropeLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 3 * 2 + 15, 40, 90, 15)];
    EuropeLabel.textAlignment = NSTextAlignmentCenter;
    EuropeLabel.textColor =[UIColor lightGrayColor];
    EuropeLabel.font = [UIFont systemFontOfSize:12];
    EuropeLabel.text = @"€欧元价格";
    [bottomView addSubview:EuropeLabel];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 3, 20, 1, 35)];
    line1.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line1];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 3 * 2, 20, 1, 35)];
    line2.backgroundColor = [UIColor lightGrayColor];
    [bottomView addSubview:line2];
    
    UILabel *shuoming = [[UILabel alloc]initWithFrame:CGRectMake(15, 65, 280, 12)];
    shuoming.textAlignment = NSTextAlignmentLeft;
    shuoming.textColor =[UIColor lightGrayColor];
    shuoming.font = [UIFont systemFontOfSize:10];
    shuoming.text= @"价格为官方公价，仅供参考，成交价请参考专营店价格";
    [bottomView addSubview:shuoming];
    
    
    
    UIView *midView = [[UIView alloc]initWithFrame:CGRectMake(0, 180 + 295, WIDTH, 900)];
    midView.backgroundColor = [UIColor colorWithRed:246.0 / 256 green:246.0 / 256 blue:246.0 / 256 alpha:1];
    midView.tag = 10000;
    [mainScroll addSubview:midView];
    
    
    UIImageView *shutiao1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 3, 15)];
    shutiao1.image = [UIImage imageNamed:@"2_32.png"];
    [midView addSubview:shutiao1];
    
    UILabel *baseInfo = [[UILabel alloc]initWithFrame:CGRectMake(30, -7, 200, 30)];
    baseInfo.textAlignment = NSTextAlignmentLeft ;
    baseInfo.text = @"基本信息";
    [midView addSubview:baseInfo];
    
    UILabel * typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 215 - 180, 60, 20)];
    typeLabel.text = @"型号：";
    typeLabel.font = [UIFont systemFontOfSize:12];
    typeLabel.textColor = [UIColor lightGrayColor];
    typeLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:typeLabel];
    
    type = [[UILabel alloc]initWithFrame:CGRectMake(90, 215 - 180, 200, 20)];
    type.textAlignment = NSTextAlignmentLeft;
    [midView addSubview:type];
    type.font = [UIFont systemFontOfSize:12];
    UILabel * brandLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 240 - 180, 60, 20)];
    brandLabel.text = @"品牌：";
    brandLabel.font = [UIFont systemFontOfSize:12];
    brandLabel.textColor = [UIColor lightGrayColor];
    brandLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:brandLabel];
    
    brand = [[UILabel alloc]initWithFrame:CGRectMake(90, 240 - 180, 200, 20)];
    brand.textAlignment = NSTextAlignmentLeft;
    brand.font = [UIFont systemFontOfSize:12];
    [midView addSubview:brand];
    
    UILabel * seriesLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 265 - 180, 60, 20)];
    seriesLabel.text = @"系列：";
    seriesLabel.font = [UIFont systemFontOfSize:12];
    seriesLabel.textColor = [UIColor lightGrayColor];
    seriesLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:seriesLabel];
    
    series = [[UILabel alloc]initWithFrame:CGRectMake(90, 265 - 180, 200, 20)];
    series.textAlignment = NSTextAlignmentLeft;
    series.font = [UIFont systemFontOfSize:12];
    [midView addSubview:series];
    UILabel * kuansiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 290 - 180, 60, 20)];
    kuansiLabel.text = @"款式：";
    kuansiLabel.font = [UIFont systemFontOfSize:12];
    kuansiLabel.textColor = [UIColor lightGrayColor];
    kuansiLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:kuansiLabel];
    
    kuansi = [[UILabel alloc]initWithFrame:CGRectMake(90, 290 - 180, 150, 20)];
    kuansi.textAlignment = NSTextAlignmentLeft;
    kuansi.font = [UIFont systemFontOfSize:12];
    [midView addSubview:kuansi];
    
    
    UILabel * fangsuiLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 315 - 180, 60, 20)];
    fangsuiLabel.text = @"防水：";
    fangsuiLabel.font = [UIFont systemFontOfSize:12];
    fangsuiLabel.textColor = [UIColor lightGrayColor];
    fangsuiLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:fangsuiLabel];
    
    fangsui = [[UILabel alloc]initWithFrame:CGRectMake(90, 315 - 180, 150, 20)];
    fangsui.textAlignment = NSTextAlignmentLeft;
    fangsui.font = [UIFont systemFontOfSize:12];
    [midView addSubview:fangsui];
    
    
    UILabel * shangshishijianLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 340 - 180, 60, 20)];
    shangshishijianLabel.text = @"上市时间：";
    shangshishijianLabel.font = [UIFont systemFontOfSize:12];
    shangshishijianLabel.textColor = [UIColor lightGrayColor];
    shangshishijianLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:shangshishijianLabel];
    
    shangshijianjian = [[UILabel alloc]initWithFrame:CGRectMake(90, 340 - 180, 150, 20)];
    shangshijianjian.textAlignment = NSTextAlignmentLeft;
    shangshijianjian.font = [UIFont systemFontOfSize:12];
    [midView addSubview:shangshijianjian];
    
    
    UILabel * xianliangLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 365 - 180, 60, 20)];
    xianliangLabel.text = @"限量：";
    xianliangLabel.font = [UIFont systemFontOfSize:12];
    xianliangLabel.textColor = [UIColor lightGrayColor];
    xianliangLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:xianliangLabel];
    
    xianliang = [[UILabel alloc]initWithFrame:CGRectMake(90, 365 - 180, 150, 20)];
    xianliang.textAlignment = NSTextAlignmentLeft;
    xianliang.font = [UIFont systemFontOfSize:12];
    [midView addSubview:xianliang];
    
    
    UIView * line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 400 - 180, WIDTH, 5)];
    line3.backgroundColor = [UIColor whiteColor];
    [midView addSubview:line3];
    
    UIImageView *shutiao2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 430 - 180, 3, 15)];
    shutiao2.image = [UIImage imageNamed:@"2_32.png"];
    [midView addSubview:shutiao2];
    
    UILabel *jixinInfo = [[UILabel alloc]initWithFrame:CGRectMake(30, 423 - 180, 200, 30)];
    jixinInfo.textAlignment = NSTextAlignmentLeft ;
    jixinInfo.text = @"外观信息";
    [midView addSubview:jixinInfo];
    
    
    UILabel * biaojingLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 465 - 180, 60, 20)];
    biaojingLabel.text = @"表径：";
    biaojingLabel.font = [UIFont systemFontOfSize:12];
    biaojingLabel.textColor = [UIColor lightGrayColor];
    biaojingLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:biaojingLabel];
    biaojing = [[UILabel alloc]initWithFrame:CGRectMake(90, 465 - 180, 70, 20)];
    biaojing.textAlignment = NSTextAlignmentLeft;
    biaojing.font = [UIFont systemFontOfSize:12];
    [midView addSubview:biaojing];
    
    
    UILabel * houduLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + self.frame.size.width/2, 465 - 180, 60, 20)];
    houduLabel.text = @"厚度：";
    houduLabel.font = [UIFont systemFontOfSize:12];
    houduLabel.textColor = [UIColor lightGrayColor];
    houduLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:houduLabel];
    houdu = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 465 - 180, 70, 20)];
    houdu.textAlignment = NSTextAlignmentLeft;
    houdu.font = [UIFont systemFontOfSize:12];
    [midView addSubview:houdu];
    
    
    
    UILabel * bkchaizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 , 490 - 180, 70, 20)];
    bkchaizhiLabel.text = @"表壳材质：";
    bkchaizhiLabel.font = [UIFont systemFontOfSize:12];
    bkchaizhiLabel.textColor = [UIColor lightGrayColor];
    bkchaizhiLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:bkchaizhiLabel];
    bkchaizhi = [[UILabel alloc]initWithFrame:CGRectMake(90, 490 - 180, 70, 20)];
    bkchaizhi.textAlignment = NSTextAlignmentLeft;
    bkchaizhi.font = [UIFont systemFontOfSize:12];
    [midView addSubview:bkchaizhi];
    
    
    
    UILabel * bpcolorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+ self.frame.size.width/2, 490 - 180, 70, 20)];
    bpcolorLabel.text = @"表盘颜色：";
    bpcolorLabel.font = [UIFont systemFontOfSize:12];
    bpcolorLabel.textColor = [UIColor lightGrayColor];
    bpcolorLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:bpcolorLabel];
    bpcolor = [[UILabel alloc]initWithFrame:CGRectMake(90+ self.frame.size.width/2, 490 - 180, 70, 20)];
    bpcolor.textAlignment = NSTextAlignmentLeft;
    bpcolor.font = [UIFont systemFontOfSize:12];
    [midView addSubview:bpcolor];
    
    UILabel * bpxingzhuangLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 515 - 180, 70, 20)];
    bpxingzhuangLabel.text = @"表盘形状：";
    bpxingzhuangLabel.font = [UIFont systemFontOfSize:12];
    bpxingzhuangLabel.textColor = [UIColor lightGrayColor];
    bpxingzhuangLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:bpxingzhuangLabel];
    
    bpxingzhuang = [[UILabel alloc]initWithFrame:CGRectMake(90, 515 - 180, 70, 20)];
    bpxingzhuang.textAlignment = NSTextAlignmentLeft;
    bpxingzhuang.font = [UIFont systemFontOfSize:12];
    [midView addSubview:bpxingzhuang];
    
    UILabel * bdyanseLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + self.frame.size.width/2, 515 - 180, 70, 20)];
    bdyanseLabel.text = @"表带颜色：";
    bdyanseLabel.font = [UIFont systemFontOfSize:12];
    bdyanseLabel.textColor = [UIColor lightGrayColor];
    bdyanseLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:bdyanseLabel];
    
    bdyande = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 515 - 180, 70, 20)];
    bdyande.textAlignment = NSTextAlignmentLeft;
    bdyande.font = [UIFont systemFontOfSize:12];
    [midView addSubview:bdyande];
    
    
    UILabel * bjchaizhiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 540 - 180, 70, 20)];
    bjchaizhiLabel.text = @"表镜材质：";
    bjchaizhiLabel.font = [UIFont systemFontOfSize:12];
    bjchaizhiLabel.textColor = [UIColor lightGrayColor];
    bjchaizhiLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:bjchaizhiLabel];
    
    bjchaizi = [[UILabel alloc]initWithFrame:CGRectMake(90, 540 - 180, 80, 20)];
    bjchaizi.textAlignment = NSTextAlignmentLeft;
    bjchaizi.font = [UIFont systemFontOfSize:12];
    [midView addSubview:bjchaizi];
    
    UILabel * bkleixingLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + self.frame.size.width/2, 540 - 180, 70, 20)];
    bkleixingLabel.text = @"表扣类型：";
    bkleixingLabel.font = [UIFont systemFontOfSize:12];
    bkleixingLabel.textColor = [UIColor lightGrayColor];
    bkleixingLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:bkleixingLabel];
    
    bkleixing = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 540 - 180, 70, 20)];
    bkleixing.textAlignment = NSTextAlignmentLeft;
    bkleixing.font = [UIFont systemFontOfSize:12];
    [midView addSubview:bkleixing];
    
    
    UILabel * biaodiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 565 - 180, 70, 20)];
    biaodiLabel.text = @"表底：";
    biaodiLabel.font = [UIFont systemFontOfSize:12];
    biaodiLabel.textColor = [UIColor lightGrayColor];
    biaodiLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:biaodiLabel];
    
    biaodi = [[UILabel alloc]initWithFrame:CGRectMake(90, 565 - 180, 70, 20)];
    biaodi.textAlignment = NSTextAlignmentLeft;
    biaodi.font = [UIFont systemFontOfSize:12];
    [midView addSubview:biaodi];
    
    UILabel * beimuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + self.frame.size.width/2, 565 - 180, 70, 20)];
    beimuLabel.text = @"贝母：";
    beimuLabel.font = [UIFont systemFontOfSize:12];
    beimuLabel.textColor = [UIColor lightGrayColor];
    beimuLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:beimuLabel];
    
    beimu = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 565 - 180, 70, 20)];
    beimu.textAlignment = NSTextAlignmentLeft;
    beimu.font = [UIFont systemFontOfSize:12];
    [midView addSubview:beimu];
    
    
    UILabel * xiangzhuanLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 590 - 180, 70, 20)];
    xiangzhuanLabel.text = @"镶砖：";
    xiangzhuanLabel.font = [UIFont systemFontOfSize:12];
    xiangzhuanLabel.textColor = [UIColor lightGrayColor];
    xiangzhuanLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:xiangzhuanLabel];
    
    xiangzhuan = [[UILabel alloc]initWithFrame:CGRectMake(90, 590 - 180, 70, 20)];
    xiangzhuan.textAlignment = NSTextAlignmentLeft;
    xiangzhuan.font = [UIFont systemFontOfSize:12];
    [midView addSubview:xiangzhuan];
    
    UILabel * yeguangLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + self.frame.size.width/2, 590 - 180, 70, 20)];
    yeguangLabel.text = @"夜光：";
    yeguangLabel.font = [UIFont systemFontOfSize:12];
    yeguangLabel.textColor = [UIColor lightGrayColor];
    yeguangLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:yeguangLabel];
    
    yeguang = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 590 - 180, 70, 20)];
    yeguang.textAlignment = NSTextAlignmentLeft;
    yeguang.font = [UIFont systemFontOfSize:12];
    [midView addSubview:yeguang];
    
    
    
    
    UIView * line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 625 - 180, WIDTH, 5)];
//    line4.image = [UIImage imageNamed:@"3z_11.png"];
    line4.backgroundColor = [UIColor whiteColor];
    [midView addSubview:line4];
    
    UIImageView *shutiao3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 655 - 180, 3, 15)];
    shutiao3.image = [UIImage imageNamed:@"2_32.png"];
    [midView addSubview:shutiao3];
    
    UILabel *waiguanInfo = [[UILabel alloc]initWithFrame:CGRectMake(30, 648 - 180, 200, 30)];
    waiguanInfo.textAlignment = NSTextAlignmentLeft ;
    waiguanInfo.text = @"机芯信息";
    [midView addSubview:waiguanInfo];
    
    UILabel * jixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(10 + self.frame.size.width/2, 690 - 180, 70, 20)];
    jixinLabel.text = @"机芯型号：";
    jixinLabel.font = [UIFont systemFontOfSize:12];
    jixinLabel.textColor = [UIColor lightGrayColor];
    jixinLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:jixinLabel];
    jixinType = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 690 - 180, 70, 20)];
    jixinType.textAlignment = NSTextAlignmentLeft;
    jixinType.font = [UIFont systemFontOfSize:12];
    [midView addSubview:jixinType];

    UILabel * jixinleixingLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 690 - 180, 60, 20)];
    jixinleixingLabel.text = @"机芯类型：";
    jixinleixingLabel.font = [UIFont systemFontOfSize:12];
    jixinleixingLabel.textColor = [UIColor lightGrayColor];
    jixinleixingLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:jixinleixingLabel];
    jixinleixing = [[UILabel alloc]initWithFrame:CGRectMake(90, 690 - 180, 70, 20)];
    jixinleixing.textAlignment = NSTextAlignmentLeft;
    jixinleixing.font = [UIFont systemFontOfSize:12];
    [midView addSubview:jixinleixing];
    
    UILabel * donglicbLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 715 - 180, 70, 20)];
    donglicbLabel.text = @"动力储备：";
    donglicbLabel.font = [UIFont systemFontOfSize:12];
    donglicbLabel.textColor = [UIColor lightGrayColor];
    donglicbLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:donglicbLabel];
    donglicb = [[UILabel alloc]initWithFrame:CGRectMake(90, 715 - 180, 70, 20)];
    donglicb.textAlignment = NSTextAlignmentLeft;
    donglicb.font = [UIFont systemFontOfSize:12];
    [midView addSubview:donglicb];
    
    UILabel * tianwentairenzhengLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 + self.frame.size.width/2, 715 - 180, 80, 20)];
    tianwentairenzhengLabel.text = @"天文台认证：";
    tianwentairenzhengLabel.font = [UIFont systemFontOfSize:12];
    tianwentairenzhengLabel.textColor = [UIColor lightGrayColor];
    tianwentairenzhengLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:tianwentairenzhengLabel];
    tianwentairenzheng = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 715 - 180, 70, 20)];
    tianwentairenzheng.textAlignment = NSTextAlignmentLeft;
    tianwentairenzheng.font = [UIFont systemFontOfSize:12];
    [midView addSubview:tianwentairenzheng];
    
    UILabel * loukongLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 740 - 180, 70, 20)];
    loukongLabel.text = @"镂空：";
    loukongLabel.font = [UIFont systemFontOfSize:12];
    loukongLabel.textColor = [UIColor lightGrayColor];
    loukongLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:loukongLabel];
    loukong = [[UILabel alloc]initWithFrame:CGRectMake(90, 740 - 180, 70, 20)];
    loukong.textAlignment = NSTextAlignmentLeft;
    loukong.font = [UIFont systemFontOfSize:12];
    [midView addSubview:loukong];
    
    UILabel * rineiwayinjiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 + self.frame.size.width/2, 740 - 180, 80, 20)];
    rineiwayinjiLabel.text = @"日内瓦印记：";
    rineiwayinjiLabel.font = [UIFont systemFontOfSize:12];
    rineiwayinjiLabel.textColor = [UIColor lightGrayColor];
    rineiwayinjiLabel.textAlignment = NSTextAlignmentRight;
    [midView addSubview:rineiwayinjiLabel];
    rineiwayinji = [[UILabel alloc]initWithFrame:CGRectMake(90 + self.frame.size.width/2, 740 - 180, 70, 20)];
    rineiwayinji.textAlignment = NSTextAlignmentLeft;
    rineiwayinji.font = [UIFont systemFontOfSize:12];
    [midView addSubview:rineiwayinji];
    
    
    
    UIView * line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 775 -180, WIDTH, 5)];
    line5.backgroundColor = [UIColor whiteColor];
    [midView addSubview:line5];
    
    UIImageView *shutiao4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 805 - 180, 3, 15)];
    shutiao4.image = [UIImage imageNamed:@"2_32.png"];
    [midView addSubview:shutiao4];
    
    UILabel *gongnengInfo = [[UILabel alloc]initWithFrame:CGRectMake(30, 798 - 180, 200, 30)];
    gongnengInfo.textAlignment = NSTextAlignmentLeft ;
    gongnengInfo.text = @"功能信息";
    [midView addSubview:gongnengInfo];
    
    
    dateShow = [[UILabel alloc]init];
    weekShow = [[UILabel alloc]init];
    monthShow = [[UILabel alloc]init];
    yearShow = [[UILabel alloc]init];
    bigRili = [[UILabel alloc]init];
    wannianli = [[UILabel alloc]init];
    yuexiang = [[UILabel alloc]init];
    shuangshiqu  = [[UILabel alloc]init];
    shijieshi  = [[UILabel alloc]init];
    jishi  = [[UILabel alloc]init];
    zhuizhen  = [[UILabel alloc]init];
    donglicunchushow  = [[UILabel alloc]init];
    changdongli  = [[UILabel alloc]init];
    guifanzhen= [[UILabel alloc]init];
    feifan = [[UILabel alloc]init];
    fangci  = [[UILabel alloc]init];
    tuofeilun  = [[UILabel alloc]init];
    danwen = [[UILabel alloc]init];
    shuangwen = [[UILabel alloc]init];
    sanwen = [[UILabel alloc]init];
    qiya  = [[UILabel alloc]init];
    gaodu = [[UILabel alloc]init];
    luopan = [[UILabel alloc]init];
    quanloukong = [[UILabel alloc]init];
    array = @[dateShow,weekShow,monthShow,yearShow,bigRili,wannianli,yuexiang,shuangshiqu,shijieshi,jishi,zhuizhen,donglicunchushow,changdongli,guifanzhen,feifan,fangci,tuofeilun,danwen,shuangwen,sanwen,qiya,gaodu,luopan,quanloukong];
    NSArray *arrayTitle = @[@"日期显示",@"星期显示",@"月份显示",@"年历显示",@"大日历",@"万年历",@"月相",@"世界时",@"计时",@"动力存储显示",@"长动力",@"飞返",@"逆跳",@"防磁",@"陀飞轮",@"气压",@"海拔",@"湿度",@"全镂空",@"闹表",@"测速",@"夜光",@"防水",@"其他功能"];
    for (int i = 0 ; i < array.count; i++) {
        UILabel *label = array[i];
        label.frame =CGRectMake(10 + 75 * (i % 4), 840 + (i / 4) * 40 - 180, 70, 35);
        label.font = [UIFont systemFontOfSize:13];
        label.backgroundColor =[UIColor colorWithRed:244.0/256 green:244.0/256 blue:244.0/256 alpha:1];
        label.textColor = [UIColor lightGrayColor];
        label.layer.cornerRadius = 5;
        label.clipsToBounds = YES;
        label.text = arrayTitle[i];
        label.layer.borderWidth = 0.5;
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignmentCenter;
        [midView addSubview:label];
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(10,315 + 180 + 900 + 10, WIDTH - 20, 40)];
    bgView.layer.cornerRadius = 2;
    bgView.tag = 10001;
//    bgView.backgroundColor = [UIColor colorWithRed:201.0/256 green:22.0/256 blue:37.0/256 alpha:1];
    [mainScroll addSubview:bgView];
    UIImageView *aaa = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, WIDTH - 20, 40)];
    aaa.image = [UIImage imageNamed:@"beijing@12x.png"];
    [bgView addSubview:aaa];
    UILabel *whereToBuy = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
    whereToBuy.text = @"在哪里能买这块表";
    whereToBuy.font = [UIFont systemFontOfSize:17];
    whereToBuy.textColor = [UIColor whiteColor];
    [bgView addSubview:whereToBuy];
//    UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH - 50, 12, 10, 16)];
//    rightView.image = [UIImage imageNamed:@"76_05.png"];
//    [bgView addSubview:rightView];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, WIDTH - 20, 40)];
    [btn addTarget:self action:@selector(buyClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];

}

-(void)buyClick
{
    WhereToBuyViewController *vc =[[WhereToBuyViewController alloc]init];
    vc.seriesId = self.seriesID;
    [_delegate.navigationController pushViewController:vc animated:YES];
}
-(void)config:(DetailModel *)model
{
    models = model;
    if (self.TTTTT == 0) {
        mainScroll.contentSize = CGSizeMake(WIDTH, 2400 + 20);
    }
    else
    {
        mainScroll.contentSize = CGSizeMake(WIDTH, 2200 + 20);
    }
    [self loadData:model];
    self.seriesID = model.pinpaiid;
    [imageView GetImageByStr:model.thumb];
    watchSeries.text = model.title;
//    watchType.text = model.xinghao;
    if ([model.guoneijia isEqualToString:@""]|| [model.guoneijia isEqualToString:@"0"]) {
        mainLandPrice.text = @"暂无";
        mainLandPrice.textColor = [UIColor lightGrayColor];
    }
    else
    {
        mainLandPrice.text = [model.guoneijia toFormatNumberString];
    }
    if ([model.xianggangjia isEqualToString:@""]|| [model.xianggangjia isEqualToString:@"0"]) {
        HKPrice.text = @"暂无";
        HKPrice.textColor = [UIColor lightGrayColor];
    }
    else
    {
        HKPrice.text = [model.xianggangjia toFormatNumberString];
    }
    if ([model.ouzhoujiage isEqualToString:@""]|| [model.ouzhoujiage isEqualToString:@"0"]) {
        EuropePrice.text = @"暂无";
        EuropePrice.textColor = [UIColor lightGrayColor];
    }
    else
    {
        EuropePrice.text = [model.ouzhoujiage toFormatNumberString];
    }
    type.text = model.xinghao;
    brand.text = model.cname;
    series.text = model.xiliename;
    kuansi.text = model.kuanshiid;
//    material.text = model.biaocaizhiid;
    if (![model.jxxinghao isEqualToString:@"—"]) {
        jixinType.text = model.jxxinghao;
    }
    if (![model.biaojing isEqualToString:@"—"]) {
        biaojing.text = [NSString stringWithFormat:@"%@毫米",model.biaojing];
    }
    if (![model.biaocaizhiid isEqualToString:@"—"]) {
        bkchaizhi.text = model.biaocaizhiid;
    }
    if (![model.bpyanse isEqualToString:@"—"]) {
        bpcolor.text = model.bpyanse;
    }
    if (![model.bpxingzhuang isEqualToString:@"—"]) {
        bpxingzhuang.text = model.bpxingzhuang;
    }
    if (![model.fangshui isEqualToString:@"—"]) {
        fangsui.text = [NSString stringWithFormat:@"%@米",model.fangshui];
    }
    if (![model.ssnianfen isEqualToString:@"0"]) {
        shangshijianjian.text = model.ssnianfen;
    }
    if (![model.xianliang isEqualToString:@"—"]) {
        xianliang.text = model.xianliang;
    }
    if (![model.houdu isEqualToString:@"—"]) {
        float a = [model.houdu floatValue];
        houdu.text = [NSString stringWithFormat:@"%.2f毫米",a];
    }
    if (![model.toudi isEqualToString:@"—"]) {
        biaodi.text = model.toudi;
    }
    if (![model.bdyanse isEqualToString:@"—"]) {
        bdyande.text = model.bdyanse;
    }
    if (![model.bkleixing isEqualToString:@"—"]) {
        bkleixing.text = model.bkleixing;
    }
    if (![model.beimu isEqualToString:@"—"]) {
        beimu.text = model.beimu;
    }
    if (![model.xiangzhuan isEqualToString:@"—"]) {
        xiangzhuan.text = model.xiangzhuan;
    }
    if (![model.yeguang isEqualToString:@"—"]) {
        yeguang.text = model.yeguang;
    }
    if (![model.jxleixing isEqualToString:@"—"]) {
        jixinleixing.text = model.jxleixing;
    }
    if (![model.dlchubei isEqualToString:@"—"]) {
        donglicb.text = [NSString stringWithFormat:@"%@小时",model.dlchubei];
    }
    if (![model.twrenzheng isEqualToString:@"—"]) {
        tianwentairenzheng.text = model.twrenzheng;
    }if (![model.loukong isEqualToString:@"—"]) {
        loukong.text = model.loukong;
    }if (![model.rnwyinji isEqualToString:@"—"]) {
        rineiwayinji.text = model.rnwyinji;
    }if (![model.bjcaizhi isEqualToString:@"—"]) {
        bjchaizi.text = model.bjcaizhi;
    }
    NSArray *modelArray = @[model.rqxianshi,model.xqxianshi,model.yfxianshi,model.nianli,model.darili,model.wannianli,model.yuexiang,model.shijieshi,model.jishi,model.dlcbxianshi,model.cdongli,model.feifan,model.nitiao,model.fangci,model.tuofeilun,model.qiya,model.haiba,model.shidu,model.loukong,model.naobiao,model.cesu,model.yeguang,model.fangshui,model.qita];
    for (int i = 0; i < modelArray.count; i ++) {
        NSString *str = modelArray[i];
        if ([str isEqualToString:@"是"]) {
            UILabel *label = array[i];
            label.backgroundColor = [UIColor colorWithRed:35.0/256 green:41.0/256 blue:46.0/256 alpha:1];
            label.textColor = [UIColor whiteColor];
        }
    }
}
-(void)tap
{
    [self.delegate.navigationController setNavigationBarHidden:YES];
    
    UIView *   BGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    BGView.tag = 100000;
    BGView.backgroundColor = [UIColor blackColor];
    [self addSubview:BGView];
    BGView.userInteractionEnabled = YES;
    
    SizeImageView *sizeImageView = [[SizeImageView alloc]initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [sizeImageView getImageFromURL:models.thumb];
    [sizeImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapForRemove)]];
    [sizeImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
    [BGView addSubview:sizeImageView];
}
-(void)tapForRemove
{
    [self.delegate.navigationController setNavigationBarHidden:NO];
    UIView *view = (UIView *)[self viewWithTag:100000];
    for (UIView *v in view.subviews) {
        [v removeFromSuperview];
    }
    [view removeFromSuperview];
    view = nil;
}
#pragma mark  savepic
-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        SizeImageView *vv = (SizeImageView *)sender.view;
        tempImage = vv.mZoomView.image;
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定保存图片吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        al.tag = 101;
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
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
