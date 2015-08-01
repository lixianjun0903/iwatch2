//
//  ForumListViewCell.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumListInfo.h"

@interface ForumListViewCell : UITableViewCell {
    UILabel *mlbTitle;
    UILabel *mlbTime;
    UILabel *mlbCount;
    UIImageView *mFlagView;
    
    UIImageView *arrowImage;
    UIImageView *jinghuaImage;
}
@property (nonatomic)int flag;
- (void)LoadContent:(ForumListInfo *)info;

@end
