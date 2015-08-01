//
//  AppDelegate.h
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDownManager.h"
#import "JSON.h"
//#import "NetImageView.h"
#import "HttpDownLoadBlock.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UIImageView *mLoadView;
    
    UIProgressView *proView;
    
    double proValue;
    
    NSTimer *timer;
}

@property (nonatomic, strong) ImageDownManager *mDownManager;
@property (nonatomic,copy)NSString *urlstr;
@property(nonatomic, retain)  UIProgressView *proView;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
