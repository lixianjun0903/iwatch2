//
//  SizeImageView.m
//  Hihey
//
//  Created by hepburn X on 12-3-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SizeImageView.h"
#import "HttpDownLoadBlock.h"
#import "Reachability.h"
@implementation SizeImageView

@synthesize mbZoomEnable, mfZoomScale, mbFullSize, mbImageShow,mZoomView;;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        mImageSize = CGSizeZero;
        mbImageShow = NO;
        mbFullSize = NO;
        mbZoomEnable = YES;
        
        mScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        mScrollView.userInteractionEnabled = YES;
        mScrollView.delegate = self;
        mScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        mScrollView.maximumZoomScale = 4.0;
        mScrollView.minimumZoomScale = 1.0;
        [self addSubview:mScrollView];

        mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        mActView.frame = CGRectMake((self.frame.size.width-30)/2, (self.frame.size.height-30)/2, 30, 30);
        mActView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        mActView.hidesWhenStopped = YES;
        [self addSubview:mActView];
        
        [mActView startAnimating];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return mZoomView;
}

//实现图片在缩放过程中居中
- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    float fWidth = scrollView.bounds.size.width;
    float fHeight = scrollView.bounds.size.height;
    float fContentWidth = scrollView.contentSize.width;
    float fContentHeight = scrollView.contentSize.height;
    CGFloat offsetX = (fWidth > fContentWidth)?(fWidth - fContentWidth)/2 : 0.0;
    CGFloat offsetY = (fHeight > fContentHeight)?(fHeight - fContentHeight)/2 : 0.0;
    mZoomView.center = CGPointMake(fContentWidth/2 + offsetX, fContentHeight/2 + offsetY);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    mScrollView.zoomScale = 1.0;
    [self ResizeFrame];
}

- (void)ResizeFrame {
    UIImage *image = mZoomView.image;
    if (image) {
        int iWidth = self.frame.size.width;
        int iHeight = image.size.height*iWidth/image.size.width;
        if (iHeight>self.frame.size.height) {
            iHeight = self.frame.size.height;
            iWidth = image.size.width*iHeight/image.size.height;
        }
        mZoomView.frame = CGRectMake((self.frame.size.width-iWidth)/2, (self.frame.size.height-iHeight)/2, iWidth, iHeight);
    }
}

- (void)ShowLocalByStr:(NSString *)path {
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    [self ShowLocalImage:image];
}

- (void)ShowLocalImage:(UIImage *)image {
    NSLog(@"ShowLocalImage");
    @autoreleasepool {
        if (mZoomView) {
            [mZoomView removeFromSuperview];
            mZoomView = nil;
        }
        if (image) {
            int iWidth = self.frame.size.width;
            int iHeight = image.size.height*iWidth/image.size.width;
            if (iHeight>self.frame.size.height) {
                iHeight = self.frame.size.height;
                iWidth = image.size.width*iHeight/image.size.height;
            }
            mZoomView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-iWidth)/2, (self.frame.size.height-iHeight)/2, iWidth, iHeight)];
            mZoomView.image = image;
//            [mZoomView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
            [mScrollView addSubview:mZoomView];
            
            mbImageShow = YES;
            [mActView stopAnimating];
        }
    }
}
-(void)longPress:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIImageView *imageView = (UIImageView *)sender.view;
        tempImage = imageView.image;
        UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", nil];
        [actionsheet showInView:self];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
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
#pragma mark   检测wifi
-(BOOL)checkwifi
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"wifi"];
    if (str == nil) {
        return YES;
    }
    if ([str isEqualToString:@"WI-FI可用时"]) {
        if ([Reachability IsEnableWIFI]) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if ([str isEqualToString:@"任何网络"])
    {
        return YES;
    }
    return YES;
}

-(void)getImageFromURL:(NSString *)url
{
    @autoreleasepool {
        if (mZoomView) {
            [mZoomView removeFromSuperview];
            mZoomView = nil;
        }
        if (![self checkwifi]) {
            return;
        }
        HttpDownLoadBlock *request = [[HttpDownLoadBlock alloc]initWithStrUrl:url Block:^(BOOL isFinish, HttpDownLoadBlock *http) {
            UIImage *image = http.dataImage;
            if (image) {
                int iWidth = self.frame.size.width;
                int iHeight = image.size.height*iWidth/image.size.width;
                if (iHeight>self.frame.size.height) {
                    iHeight = self.frame.size.height;
                    iWidth = image.size.width*iHeight/image.size.height;
                }
                mZoomView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width-iWidth)/2, (self.frame.size.height-iHeight)/2, iWidth, iHeight)];
                mZoomView.image = image;
//                [mZoomView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)]];
                [mScrollView addSubview:mZoomView];
                
                mbImageShow = YES;
                [mActView stopAnimating];            }

        }];
        }

}
- (void)setMbZoomEnable:(BOOL)bEnable {
    if (bEnable) {
        mScrollView.delegate = self;
    }
    else {
        mScrollView.delegate = nil;
    }
}

- (void)setMfZoomScale:(float)fScale {
    mScrollView.zoomScale = fScale;
}

- (float)mfZoomScale {
    return mScrollView.zoomScale;
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
