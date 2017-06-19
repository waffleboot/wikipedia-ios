#import "WMFContentGroup+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WMFContentGroup (CoreDataProperties)

+ (NSFetchRequest<WMFContentGroup *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *articleURLString;
@property (nullable, nonatomic, retain) NSArray *content;
@property (nonatomic) int32_t contentGroupKindInteger;
@property (nullable, nonatomic, copy) NSDate *contentMidnightUTCDate;
@property (nonatomic) int16_t contentTypeInteger;
@property (nonatomic) int32_t dailySortPriority;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) BOOL isVisible;
@property (nullable, nonatomic, copy) NSString *key;
@property (nullable, nonatomic, retain) CLLocation *location;
@property (nullable, nonatomic, copy) NSDate *midnightUTCDate;
@property (nullable, nonatomic, retain) CLPlacemark *placemark;
@property (nullable, nonatomic, copy) NSString *siteURLString;
@property (nonatomic) BOOL wasDismissed;
@property (nullable, nonatomic, retain) NSOrderedSet<WMFContentItem *> *items;

@end

@interface WMFContentGroup (CoreDataGeneratedAccessors)

- (void)insertObject:(WMFContentItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray<WMFContentItem *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(WMFContentItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray<WMFContentItem *> *)values;
- (void)addItemsObject:(WMFContentItem *)value;
- (void)removeItemsObject:(WMFContentItem *)value;
- (void)addItems:(NSOrderedSet<WMFContentItem *> *)values;
- (void)removeItems:(NSOrderedSet<WMFContentItem *> *)values;

@end

NS_ASSUME_NONNULL_END
