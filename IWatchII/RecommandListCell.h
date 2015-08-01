//
//  RecommandListCell.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-31.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommandInfo.h"
#import "NetImageView.h"

@interface RecommandListCell : UITableViewCell {
    NetImageView *mLeftView;
    NetImageView *mRightView;
    UILabel *mlbLeftTitle;
    UILabel *mlbRightTitle;
    UILabel *mlbLeftTime;
    UILabel *mlbRightTime;
}

@property (nonatomic, assign) int miIndex;
@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnRecommandSelect;

- (void)LoadContent:(RecommandInfo *)info :(RecommandInfo *)info2;

@end
