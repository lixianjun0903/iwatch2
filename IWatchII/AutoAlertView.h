//
//  AutoAlertView.h
//  ManziDigest
//
//  Created by Hepburn Alex on 12-10-15.
//  Copyright (c) 2012年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutoAlertView : UIView {
    UILabel *mlbMsg;
    UIView *mBackView;
}

@property (nonatomic, assign) UIView *mBackView;
@property (nonatomic, assign) UILabel *mlbMsg;

+ (void)ShowMessage:(NSString *)message;
+ (void)ShowMessage:(NSString *)message :(int)iTop;
+ (void)ShowAlert:(NSString *)title message:(NSString *)message;

@end
