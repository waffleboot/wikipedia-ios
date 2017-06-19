#import <WMF/WMFArticle+CoreDataClass.h>
@class WMFContentItem;

NS_ASSUME_NONNULL_BEGIN

@interface WMFArticle (CoreDataProperties)

+ (NSFetchRequest<WMFArticle *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *displayTitle;
@property (nullable, nonatomic, copy) NSNumber *geoDimensionNumber;
@property (nullable, nonatomic, copy) NSNumber *geoTypeNumber;
@property (nullable, nonatomic, copy) NSNumber *imageHeight;
@property (nullable, nonatomic, copy) NSString *imageURLString;
@property (nullable, nonatomic, copy) NSNumber *imageWidth;
@property (nonatomic) BOOL isDownloaded;
@property (nonatomic) BOOL isExcludedFromFeed;
@property (nullable, nonatomic, copy) NSString *key;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSDate *newsNotificationDate;
@property (nullable, nonatomic, retain) NSDictionary *pageViews;
@property (nullable, nonatomic, copy) NSNumber *placesSortOrder;
@property (nullable, nonatomic, copy) NSDate *savedDate;
@property (nullable, nonatomic, copy) NSNumber *signedQuadKey;
@property (nullable, nonatomic, copy) NSString *snippet;
@property (nullable, nonatomic, copy) NSString *thumbnailURLString;
@property (nullable, nonatomic, copy) NSDate *viewedDate;
@property (nullable, nonatomic, copy) NSDate *viewedDateWithoutTime;
@property (nullable, nonatomic, copy) NSString *viewedFragment;
@property (nonatomic) double viewedScrollPosition;
@property (nonatomic) BOOL wasSignificantlyViewed;
@property (nullable, nonatomic, copy) NSString *wikidataDescription;
@property (nullable, nonatomic, retain) NSSet<WMFContentItem *> *contentItems;

@end

@interface WMFArticle (CoreDataGeneratedAccessors)

- (void)addContentItemsObject:(WMFContentItem *)value;
- (void)removeContentItemsObject:(WMFContentItem *)value;
- (void)addContentItems:(NSSet<WMFContentItem *> *)values;
- (void)removeContentItems:(NSSet<WMFContentItem *> *)values;

@end

NS_ASSUME_NONNULL_END
