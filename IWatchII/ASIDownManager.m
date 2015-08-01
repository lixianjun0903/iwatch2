//
//  ASIDownManager.m
//  ManziDigest
//
//  Created by Hepburn Alex on 12-9-19.
//  Copyright (c) 2012年 Hepburn Alex. All rights reserved.
//

#import "ASIDownManager.h"
#import "ASIFormDataRequest.h"

@implementation ASIDownManager

@synthesize delegate, OnImageDown, OnImageFail, tag, userInfo, mWebStr;

- (id)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)Cancel {
    if (mRequest) {
        NSLog(@"ASIHttpDownManager Cancel");
        mRequest.delegate = nil;
        [mRequest clearDelegatesAndCancel];
        [mRequest release];
        mRequest = nil;
    }
}

- (void)dealloc {
    NSLog(@"ASIHttpDownManager dealloc");
    [self Cancel];
    self.delegate = nil;
    self.userInfo = nil;
    self.mWebStr = nil;
    NSLog(@"ASIHttpDownManager dealloc2");
    [super dealloc];
}

- (void)PostHttpRequest2:(NSString *)urlString :(NSDictionary *)dict :(NSString *)filepath :(NSString *)filename {
    BOOL bFirst = YES;
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict objectForKey:key];
        if (bFirst) {
            urlString = [urlString stringByAppendingFormat:@"?%@=%@", key, value];
        }
        else {
            urlString = [urlString stringByAppendingFormat:@"&%@=%@", key, value];
        }
        bFirst = NO;
    }
    NSLog(@"PostHttpRequest:%@, %@, %@", urlString, filepath, filename);
    NSURL *url = [NSURL URLWithString:urlString];
    mRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [mRequest setTimeOutSeconds:120];
    if (filepath) {
        [mRequest addFile:filepath forKey:filename];
    }
    [mRequest setDelegate:self];
    [mRequest startAsynchronous];
    //    [mRequest release];
}

- (void)PostHttpRequest:(NSString *)urlString :(NSDictionary *)dict :(NSString *)filepath :(NSString *)filename {
    NSLog(@"PostHttpRequest:%@, %@, %@, %@", urlString, dict, filepath, filename);
    NSURL *url = [NSURL URLWithString:urlString];
    mRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [mRequest setTimeOutSeconds:120];
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict objectForKey:key];
        [mRequest addPostValue:value forKey:key];
    }
    if (filepath) {
        [mRequest addFile:filepath forKey:filename];
    }
    [mRequest setDelegate:self];
    [mRequest startAsynchronous];
//    [mRequest release];
}

- (void)PostHttpRequest:(NSString *)urlString :(NSDictionary *)dict files:(NSDictionary *)files {
    NSLog(@"PostHttpRequest:%@, %@, %@", urlString, dict, files);
    NSURL *url = [NSURL URLWithString:urlString];
    mRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    [mRequest setTimeOutSeconds:120];
    for (NSString *key in dict.allKeys) {
        NSString *value = [dict objectForKey:key];
        [mRequest addPostValue:value forKey:key];
    }
    for (NSString *key in files.allKeys) {
        NSString *value = [files objectForKey:key];
        [mRequest addFile:value forKey:key];
    }
    [mRequest setDelegate:self];
    [mRequest startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)_request {
    NSData *data = [_request responseData];
    NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    
    [self Cancel];
    if ([_request responseStatusCode] != 200) {
        NSLog(@"requestFinished Invalid:%d,%@", [_request responseStatusCode], _request.responseStatusMessage);
        if (delegate && OnImageFail) {
            [delegate performSelector:OnImageFail withObject:self];
        }
        return;
    }
    
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    responseStr = [responseStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.mWebStr = responseStr;

    if (delegate && OnImageDown) {
        [delegate performSelector:OnImageDown withObject:self];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)_request {
    NSData *data = [_request responseData];
    NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"requestFailed %@", responseStr);
    
    [self Cancel];
    if (delegate && OnImageFail) {
        [delegate performSelector:OnImageFail withObject:self];
    }
}

+ (void)ShowNetworkAnimate
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
#endif
}

+ (void)HideNetworkAnimate
{
#if TARGET_OS_IPHONE
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
#endif
}


@end
