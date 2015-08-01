//
//  SelectTabBar.m
//  TestRedCollar
//
//  Created by iHope on 14-1-23.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "SelectTabBar.h"

static SelectTabBar *gTabBar = nil;

@implementation SelectTabBar

@synthesize miIndex, delegate;

+ (SelectTabBar *)Share {
    return gTabBar;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        gTabBar = self;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];

        NSArray *array = [NSArray arrayWithObjects:@"每日爱表0", @"原创0", @"手表价格0", @"论坛0", @"设置0", nil];
        NSArray *array1 = [NSArray arrayWithObjects:@"每日爱表1", @"原创1", @"手表价格1", @"论坛1", @"设置1", nil];
        int width = self.frame.size.width/array.count;
        int x = 0;
        for (int i = 0; i<array.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, (self.frame.size.height-44)/2, width, 44);
            button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            button.backgroundColor = self.backgroundColor;
            
            [button setImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:[array1 objectAtIndex:i]]  forState:UIControlStateSelected];
            [button addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.tag = i+1500;
            [self addSubview:button];
            
            if (i > 0) {
                UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(x-3, 11, 6, 21)];
                lineView.image = [UIImage imageNamed:@"f_tab_div"];
//                [self addSubview:lineView];
            }
            
            x += width;
        }
        
//        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
//        lineView.image = [UIImage imageNamed:@"f_tab_line"];
//        [self addSubview:lineView];
        
        mLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, width-16, 1)];
        mLineView.backgroundColor = Default_Color;
        [self addSubview:mLineView];
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(8, 0);
        mLineView.transform = transform;
        
        [self RefreshView];
    }
    return self;
}

- (void)OnBtnClick:(UIButton *)sender {
    int index = sender.tag-1500;
    if (delegate && [delegate respondsToSelector:@selector(CanSelectTab::)]) {
        if (![delegate CanSelectTab:self :index]) {
            return;
        }
    }
    [UIView animateWithDuration:0.2 animations:^{
        CGAffineTransform transform = CGAffineTransformMakeTranslation(sender.frame.origin.x+8, 0);
        mLineView.transform = transform;
    }];
    self.miIndex = index;
 
    if (delegate && [delegate respondsToSelector:@selector(OnTabSelect:)]) {
        [delegate OnTabSelect:self];
    }
}

- (void)RefreshView {
    for (int i = 0; i < 5; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+1500];
        if (button) {
            button.selected = (i == miIndex);
        }
    }
}

- (void)setMiIndex:(int)index {
    miIndex = index;
    [self RefreshView];
}

@end
