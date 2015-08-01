//
//  ArticleListViewCell.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-24.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetImageView.h"
#import "ArticleListInfo.h"

@interface ArticleListViewCell : UITableViewCell {
    NetImageView *mImageView;
    UILabel *mlbTitle;
    UILabel *mlbDesc;
    UILabel *mlbAuthor;
}

- (void)LoadContent:(ArticleListInfo *)info;

@end
