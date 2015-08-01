//
//  SizeImageView.h
//  Hihey
//
//  Created by hepburn X on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SizeImageView : UIView<UIScrollViewDelegate> {
    UIScrollView *mScrollView;
//    UIImageView *mZoomView;
    BOOL mbZoomEnable;
    BOOL mbFullSize;
    CGSize mImageSize;
    BOOL mbImageShow;
    UIActivityIndicatorView *mActView;
    UIImage *tempImage;
}

@property (nonatomic, assign) BOOL mbZoomEnable;
@property (nonatomic, assign) BOOL mbFullSize;
@property (nonatomic, assign) float mfZoomScale;
@property (readonly, assign) BOOL mbImageShow;
@property (nonatomic,copy)NSString *mpath;
@property (nonatomic,strong)UIImageView *mZoomView;

- (void)ShowLocalByStr:(NSString *)path;
- (void)ShowLocalImage:(UIImage *)image;
-(void)getImageFromURL:(NSString *)url;
+ (NSString *)GetLocalPathOfUrl:(NSString *)path;


@end
