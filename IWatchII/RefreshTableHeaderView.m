#import "RefreshTableHeaderView.h"

#define TEXT_COLOR	 [UIColor colorWithRed:211.0/256.0 green:211.0/256.0 blue:211.0/256.0 alpha:1.0]
#define BORDER_COLOR [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f

@implementation RefreshTableHeaderView

@synthesize state;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		mTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 30.0f, self.frame.size.width, 20.0f)];
		mTimeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		mTimeLabel.font = [UIFont systemFontOfSize:10.0f];
		mTimeLabel.textColor = TEXT_COLOR;
		mTimeLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		mTimeLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		mTimeLabel.backgroundColor = [UIColor clearColor];
		mTimeLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:mTimeLabel];
		[mTimeLabel release];

		if ([[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"]) {
			mTimeLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"EGORefreshTableView_LastRefresh"];
		}
		else {
			[self setCurrentDate];
		}
		
		mStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
		mStatusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		mStatusLabel.font = [UIFont boldSystemFontOfSize:11.0f];
		mStatusLabel.textColor = TEXT_COLOR;
		mStatusLabel.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		mStatusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		mStatusLabel.backgroundColor = [UIColor clearColor];
		mStatusLabel.textAlignment = UITextAlignmentCenter;
		[self addSubview:mStatusLabel];
		[mStatusLabel release];
		
		mStatusImage = [[CALayer alloc] init];
		mStatusImage.frame = CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f);
		mStatusImage.contentsGravity = kCAGravityResizeAspect;
		mStatusImage.contents = (id)[UIImage imageNamed:@"blackArrow.png"].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			mStatusImage.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:mStatusImage];
		[mStatusImage release];
		
		mActView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		mActView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		[self addSubview:mActView];
		[mActView release];

        UIImage *backImage = [UIImage imageNamed:@"headback.png"];
        if (backImage) {
            self.backgroundColor = [UIColor colorWithPatternImage:backImage];
        }
        else {
            self.backgroundColor = [UIColor colorWithRed:150.0/255.0 green:150.0/255.0 blue:150.0/255.0 alpha:1.0];
        }
		
		[self setState:PullRefreshNormal];
    }
    return self;
}

- (void)setCurrentDate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setAMSymbol:@"AM"];
	[formatter setPMSymbol:@"PM"];
	[formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
	mTimeLabel.text = [NSString stringWithFormat:@"上次更新时间: %@", [formatter stringFromDate:[NSDate date]]];
	[[NSUserDefaults standardUserDefaults] setObject:mTimeLabel.text forKey:@"EGORefreshTableView_LastRefresh"];
	[[NSUserDefaults standardUserDefaults] synchronize];
	[formatter release];
}

/*
- (void)drawRect:(CGRect)rect{
	UIImage *image=[UIImage imageNamed:@"background.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
*/

- (void)setState:(PullRefreshState)aState{
	switch (aState) {
		case PullRefreshPulling:
			mStatusLabel.text = @"松开更新...";
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			mStatusImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
			[CATransaction commit];
			break;
		case PullRefreshNormal:
			if (state == PullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				mStatusImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			mStatusLabel.text = @"下拉更新...";
			[mActView stopAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			mStatusImage.hidden = NO;
			mStatusImage.transform = CATransform3DIdentity;
			[CATransaction commit];
			break;
		case PullRefreshLoading:
			mStatusLabel.text = @"加载中...";
			[mActView startAnimating];
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			mStatusImage.hidden = YES;
			[CATransaction commit];
			break;
		default:
			break;
	}
	state = aState;
}

- (void)dealloc {
    [super dealloc];
}

@end
