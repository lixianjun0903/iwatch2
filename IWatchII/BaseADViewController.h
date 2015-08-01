//
//  BaseADViewController.h
//  TestDialogue
//
//  Created by Hepburn Alex on 13-2-6.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseADViewController : UIViewController {
    UILabel *mlbTitle;
    MBProgressHUD *mLoadView;
    UIImageView *mShadowView;
    id delegate;
}

@property (nonatomic, retain) NSString *mLoadMsg;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnGoBack;

//topbar
@property (nonatomic, readonly) UILabel *mlbTitle;
@property (nonatomic, assign) UIImage *mShadowImage;
@property (nonatomic, retain) UIColor *mTitleColor;
@property (nonatomic, retain) UIColor *mTopColor;
@property (nonatomic, retain) UIImage *mTopImage;
@property (nonatomic, assign) BOOL mbLightNav;
@property (nonatomic, assign) int mFontSize;


- (void)GoBack;
- (void)GoHome;
- (void)StartLoading;
- (void)StopLoading;
- (void)showMsg:(NSString *)msg;

- (void)ClearNavItem;
- (void)AddRightTextBtn:(NSString *)name target:(id)target action:(SEL)action;
- (void)AddRightImageBtn:(UIImage *)image target:(id)target action:(SEL)action;
- (void)AddLeftImageBtn:(UIImage *)image target:(id)target action:(SEL)action;

- (UIButton *)GetImageButton:(UIImage *)image target:(id)target action:(SEL)action;
- (UIBarButtonItem *)GetImageBarItem:(UIImage *)image target:(id)target action:(SEL)action;
- (void)AddRightImageBtns:(NSArray *)array;

- (void)RefreshNavColor;

- (UIView *)GetInputAccessoryView;

@end
