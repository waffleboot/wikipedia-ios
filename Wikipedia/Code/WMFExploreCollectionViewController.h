@import UIKit;
@import WMF.Swift;

@class WMFContentGroup;
@class MWKDataStore;
@protocol WMFExploreCollectionViewControllerDelegate;

extern const NSInteger WMFExploreFeedMaximumNumberOfDays;

NS_ASSUME_NONNULL_BEGIN

@interface WMFExploreCollectionViewController : UICollectionViewController <WMFAnalyticsViewNameProviding, WMFAnalyticsContextProviding>

@property (nonatomic, strong) MWKDataStore *userStore;

@property (nonatomic, weak) id<WMFExploreCollectionViewControllerDelegate> delegate;

@property (nonatomic, assign) BOOL canScrollToTop;

- (UIButton *)titleButton;

- (NSUInteger)numberOfSectionsInExploreFeed;

- (void)updateFeedSourcesUserInitiated:(BOOL)wasUserInitiated completion:(nonnull dispatch_block_t)completion;

@end

@protocol WMFExploreCollectionViewControllerDelegate <NSObject>

@optional
- (void)exploreCollectionViewController:(WMFExploreCollectionViewController *)collectionVC didEndScrolling:(UIScrollView *)scrollView;

@optional
- (void)exploreCollectionViewController:(WMFExploreCollectionViewController *)collectionVC willBeginScrolling:(UIScrollView *)scrollView;

@optional
- (void)exploreCollectionViewController:(WMFExploreCollectionViewController *)collectionVC didScroll:(UIScrollView *)scrollView;

@optional
- (void)exploreCollectionViewController:(WMFExploreCollectionViewController *)collectionVC didScrollToTop:(UIScrollView *)scrollView;

@end

NS_ASSUME_NONNULL_END
