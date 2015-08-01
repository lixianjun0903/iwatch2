//
//  TypeSelectView.h
//  TestHebei
//
//  Created by Hepburn Alex on 14-6-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TypeSelectView;

@protocol TypeSelectViewDelegate <NSObject>

@optional

- (UIImage *)TypeSelectImage:(TypeSelectView *)selectView :(int)index;
- (UIImage *)TypeUnSelectImage:(TypeSelectView *)selectView :(int)index;

@end

@interface TypeSelectView : UIScrollView {
}

@property (nonatomic, assign) int miLeft;
@property (nonatomic, assign) int miTop;
@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnTypeSelect;
@property (nonatomic, strong) UIImage *mSelectImage;
@property (nonatomic, strong) UIImage *mUnSelectImage;
@property (nonatomic, strong) NSArray *mArray;

- (void)reloadData;

- (void)SelectType:(int)index;

@end
