//
//  NetImageView.h
//  TestAppstoreRss
//
//  Created by hepburn X on 11-10-28.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    TImageType_FullFill,
    TImageType_CutFill,
    TImageType_AutoSize,
    TImageType_LeftAlign,
    TImageType_TopAlign
}TImageType;

@interface NetImageView : UIView {
    UIActivityIndicatorView *mActView;
    NSURLConnection *mConnection;
    NSMutableData *mWebData;
    TImageType mImageType;
    BOOL mbLoading;
    UIImageView *mImageView;
    long long miFileSize;
    long long miDownSize;
}

@property (nonatomic, retain) id userinfo;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnImageLoad;
@property (nonatomic, assign) SEL OnLoadProgress;
@property (nonatomic, assign) SEL OnLoadFinish;
@property (nonatomic, assign) long long miFileSize;
@property (nonatomic, assign) long long miDownSize;
@property (nonatomic, assign) BOOL mbActShow;
@property (nonatomic, assign) TImageType mImageType;
@property (nonatomic, retain) NSString *mLocalPath;
@property (nonatomic, assign) UIImageView *mImageView;
@property (nonatomic, retain) UIImage *mDefaultImage;
@property (readonly) CGPoint mImageCenter;
@property (readonly, assign) BOOL mbLoading;

- (void)GetImageByStr:(NSString *)path;
- (void)Cancel;
- (BOOL)ShowLocalImage;
- (void)ShowLocalImage:(NSString *)imagename;

+ (void)ClearLocalFile:(NSString *)urlstr;
+ (NSString *)GetLocalPathOfUrl:(NSString *)path;
+ (NSString *)MD5String:(NSString *)str;

@end
