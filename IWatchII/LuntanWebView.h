//
//  LuntanWebView.h
//  IWatchII
//
//  Created by xll on 15/1/2.
//  Copyright (c) 2015年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LuntanWebView : UIWebView<UIWebViewDelegate>
{
    int MM;
}
@property(nonatomic,strong)NSMutableArray *urlArray;
@property(nonatomic)UIViewController *dele;
@property(nonatomic,copy)NSString *fid;


@end
