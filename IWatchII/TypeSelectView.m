//
//  TypeSelectView.m
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "TypeSelectView.h"
#import "TouchView.h"

@implementation TypeSelectView

@synthesize mArray, miIndex, delegate, OnTypeSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.miLeft = 12;
        self.miTop = 4;
        self.mSelectImage = [UIImage imageNamed:@"f_selectbtn02"];
        self.mUnSelectImage = [UIImage imageNamed:@"f_selectbtn01"];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)dealloc {
    self.mArray = nil;
    self.mSelectImage = nil;
    self.mUnSelectImage = nil;
}

- (void)reloadData {
    @autoreleasepool {
        for (UIView *view in self.subviews) {
            [view removeFromSuperview];
        }
    }
    int iOffset = self.miLeft/2;
    if (mArray && mArray.count>0) {
        int iCount = mArray.count;
        int iWidth = (self.frame.size.width-_miLeft*2-iOffset*(iCount-1))/iCount;

        for (int i = 0; i < mArray.count; i ++) {
            TouchView *touchView = [[TouchView alloc] initWithFrame:CGRectMake(_miLeft+(iWidth+iOffset)*i, _miTop, iWidth, self.frame.size.height-_miTop*2)];
            touchView.delegate = self;
            touchView.tag = i+100;
            touchView.OnViewClick = @selector(OnBtnSelect:);
            [self addSubview:touchView];
            
            UILabel *lbText = [[UILabel alloc] initWithFrame:touchView.bounds];
            lbText.backgroundColor = [UIColor clearColor];
            lbText.font = [UIFont systemFontOfSize:14];
            lbText.textAlignment = UITextAlignmentCenter;
            lbText.textColor = [UIColor blackColor];
            lbText.text = [mArray objectAtIndex:i];
            lbText.tag = 1400;
            [touchView addSubview:lbText];
        }
        self.contentSize = CGSizeMake(iWidth*mArray.count, self.frame.size.height);

        [self RefreshView:miIndex];
    }
}

- (void)OnBtnSelect:(TouchView *)sender
{
    miIndex = sender.tag-100;
    
    [self RefreshView:miIndex];
    if (delegate && OnTypeSelect) {
        SafePerformSelector(
                            [delegate performSelector:OnTypeSelect withObject:self];
                            );
    }
}

- (void)SelectType:(int)index {
    TouchView *touchView = (TouchView *)[self viewWithTag:index+100];
    if (touchView) {
        [self OnBtnSelect:touchView];
    }
}

- (void)RefreshView:(int)index {
    for (TouchView *view in self.subviews) {
        if ([view isKindOfClass:[TouchView class]]) {
            UILabel *lbText = (UILabel *)[view viewWithTag:1400];
            if (lbText) {
                lbText.textColor = (view.tag == index+100)?[UIColor whiteColor]:[UIColor grayColor];
            }
            if ((view.tag == index+100)) {
                if (delegate && [delegate respondsToSelector:@selector(TypeSelectImage::)]) {
                    view.image = [delegate TypeSelectImage:self :view.tag-100];
                }
                else {
                    view.image = self.mSelectImage;
                }
            }
            else {
                if (delegate && [delegate respondsToSelector:@selector(TypeUnSelectImage::)]) {
                    view.image = [delegate TypeUnSelectImage:self :view.tag-100];
                }
                else {
                    view.image = self.mUnSelectImage;
                }
            }
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
