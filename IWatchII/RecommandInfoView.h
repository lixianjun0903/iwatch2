//
//  RecommandInfoView.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "RecommandInfo.h"

@interface RecommandInfoView : UIView {
    NetImageView *mImageView;
    UILabel *mlbDay;
    UILabel *mlbMonth;
    UILabel *mlbTitle;
    UILabel *mlbDesc;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnRecommandSelect;

- (void)LoadContent:(RecommandInfo *)info;

@end
