//
//  AppDelegate.m
//  IWatchII
//
//  Created by Hepburn Alex on 14-10-23.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
@implementation AppDelegate
@synthesize proView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;



- (void)Cancel {
    self.mDownManager.delegate = nil;
    SAFE_CANCEL_ARC(self.mDownManager);
}

- (void)loadData {
    
    float heigth = [[UIScreen mainScreen] bounds].size.height;
    float width = [[UIScreen mainScreen] bounds].size.width;
    
    if (_mDownManager) {
        return;
    }
    NSString *urlstr = [NSString stringWithFormat:@"%@json_watch.php?t=46&fid=%dx%d", SERVER_URL,(int)width,(int)heigth];
    self.mDownManager = [[ImageDownManager alloc] init];
    _mDownManager.delegate = self;
    _mDownManager.OnImageDown = @selector(OnLoadFinish:);
    _mDownManager.OnImageFail = @selector(OnLoadFail:);
    [_mDownManager GetImageByStr:urlstr];
}

- (void)OnLoadFinish:(ImageDownManager *)sender {
    NSString *resStr = sender.mWebStr;
    NSDictionary *dict = [resStr JSONValue];
    [self Cancel];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        NSArray *array = [dict objectForKey:@"data"];
        if (array && [array isKindOfClass:[NSArray class]]) {
            self.urlstr = array[0][@"thumb"];
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
//             [user removeObjectForKey:@"urlstr"];
          NSString *str = [user objectForKey:@"urlstr"];
            if (str == nil) {
                [user setObject:self.urlstr forKey:@"urlstr"];
                [user synchronize];
                [self loadImage];
                [self showDefaultImage];
            }
            else
            {
                if (![str isEqualToString:self.urlstr]) {
                    [self loadImage];
                    [self showDefaultImage];
                    [user setObject:self.urlstr forKey:@"urlstr"];
                    [user synchronize];
                }
                else
                {
                    [self showImage];
                }
            }
            
        }
    }
}
-(void)showImage
{
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
    filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,@"downloadImage",@"jpgg"];
    NSData *picData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image =  [UIImage imageWithData:picData];
    mLoadView.image = image;
    [self qidongdonghua];
}
-(void)showDefaultImage
{
//    mLoadView.image= [UIImage imageNamed:@"Default.png"];
    [mLoadView sd_setImageWithURL:[NSURL URLWithString:self.urlstr] placeholderImage:[UIImage imageNamed:@"Default.png"]];
    [self qidongdonghua];
}
-(void)qidongdonghua
{
    [UIView animateWithDuration:3 animations:^{
        mLoadView.frame = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height - 5) ;
    } completion:^(BOOL finished) {
        proValue = 0;
        proView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, self.window.frame.size.height - 5, self.window.frame.size.width, 5)];
        proView.progressViewStyle = UIProgressViewStyleBar;
        [self.window addSubview:proView];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeProgress) userInfo:nil repeats:YES];
        [self performSelector:@selector(ShowHomeView) withObject:self afterDelay:1.9];
    }];
}
- (void)OnLoadFail:(ImageDownManager *)sender {
    [self showDefaultImage];
    [self Cancel];
}
-(void)loadImage
{
    HttpDownLoadBlock  *request = [[HttpDownLoadBlock alloc]initWithStrUrl:self.urlstr Block:^(BOOL isFinish, HttpDownLoadBlock *http) {
        if (isFinish) {
            UIImage *image = http.dataImage;
            NSData *data = nil;
            NSString *picType;
            if (UIImagePNGRepresentation(image)) {
                data = UIImageJPEGRepresentation(image, 1);
                picType = @"jpgg";
            }else{
                data = UIImageJPEGRepresentation(image, 1);
                picType = @"jpgg";
            }
            NSString *filePath = [NSString stringWithFormat:@"%@/Documents/",NSHomeDirectory()];
            filePath = [NSString stringWithFormat:@"%@%@.%@",filePath,@"downloadImage",picType];
            [data writeToFile:filePath atomically:YES];
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    
    mLoadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, - self.window.bounds.size.height/ 2, self.window.bounds.size.width, self.window.bounds.size.height - 3)];
//    mLoadView.backgroundColor = [UIColor blackColor];
//    mLoadView.contentMode = UIViewContentModeScaleAspectFit;
    [self.window addSubview:mLoadView];
//    [self showDefaultImage];
    [self loadData];
    
    
    
//*********************分享部分*******************************************
    
    [UMSocialData setAppKey:APPKEY];
    [UMSocialData openLog:YES];

    
    [UMSocialWechatHandler setWXAppId:@"wx95d07660d567467e" appSecret:@"d8a52bb496087e06d5cb688c45054e2a" url:@"http://www.iwatch365.com"];
    
    [UMSocialQQHandler setQQWithAppId:@"1103602046" appKey:@"Woj5gpCWyv8MkBXL" url:@"http://www.iwatch365.com"];
    
//*********************分享部分*******************************************
//设置字体大小
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *num = [user objectForKey:@"num"];
    if (num == nil) {
        [user setObject:@"100.0" forKey:@"num"];
        [user synchronize];
    }
    
    return YES;
}
-(void)changeProgress

{
    proValue += 0.095; //改变proValue的值
    if(proValue > 1.1)
    {
        //停用计时
        [timer invalidate];
    }
    else
    {
        [proView setProgress:proValue];//重置进度条
    }
}
- (void)ShowHomeView {
    [proView removeFromSuperview];
    [mLoadView removeFromSuperview];
     timer = nil;
    self.window.rootViewController = [[HomeViewController alloc] init];
    [NSThread detachNewThreadSelector:@selector(clearImage) toTarget:self withObject:nil];
}
-(void)clearImage
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *str = [user objectForKey:@"tupian"];
    if (str == nil) {
        return;
    }
    if (![str isEqualToString:@"1"]) {
        return;
    }
    NSArray *filelist = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] error:nil]
                             pathsMatchingExtensions:[NSArray arrayWithObjects:@"png", @"jpg", @"PNG", @"JPG", nil]];
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    for (NSString *imagename in filelist) {
            NSString *imagepath = [docDir stringByAppendingPathComponent:imagename];
            [[NSFileManager defaultManager] removeItemAtPath:imagepath error:nil];
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"IWatchII" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"IWatchII.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark  - me
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}
@end
