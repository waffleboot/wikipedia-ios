#import <WMF/WMFContentSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface WMFOnThisDayContentSource : NSObject <WMFContentSource, WMFDateBasedContentSource>

@property (readonly, nonatomic, strong) NSURL *siteURL;

- (instancetype)initWithSiteURL:(NSURL *)siteURL;

- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
