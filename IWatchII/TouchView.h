//
//  TouchView.h
//  HtmlReader
//
//  Created by Bruce on 11-7-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TouchView : UIImageView {
	BOOL mbMove;
	CGPoint mStartPoint;
	CGPoint mEndPoint;
}

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) SEL OnViewClick;
@property (nonatomic, assign) SEL OnViewMove;
@property (nonatomic, assign) SEL OnLongPressStart;
@property (nonatomic, assign) SEL OnLongPressEnd;
@property (nonatomic, assign) CGPoint mStartPoint;
@property (nonatomic, assign) CGPoint mEndPoint;

@end
