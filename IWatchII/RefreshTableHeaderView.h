#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@interface RefreshTableHeaderView : UIView {
	UILabel *mTimeLabel;
	UILabel *mStatusLabel;
	CALayer *mStatusImage;
	UIActivityIndicatorView *mActView;
	PullRefreshState state;
}

@property(nonatomic,assign) PullRefreshState state;

- (void)setCurrentDate;
- (void)setState:(PullRefreshState)aState;

@end
