#import <WMF/WMFContentItem+CoreDataClass.h>
@class WMFArticle;
@class WMFContentGroup;

NS_ASSUME_NONNULL_BEGIN

@interface WMFContentItem (CoreDataProperties)

+ (NSFetchRequest<WMFContentItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *articleURLString;
@property (nonatomic) int16_t contentTypeInteger;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSDate *midnightUTCDate;
@property (nullable, nonatomic, retain) NSObject *object;
@property (nullable, nonatomic, retain) NSOrderedSet<WMFArticle *> *articles;
@property (nullable, nonatomic, retain) WMFContentGroup *group;

@end

@interface WMFContentItem (CoreDataGeneratedAccessors)

- (void)insertObject:(WMFArticle *)value inArticlesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromArticlesAtIndex:(NSUInteger)idx;
- (void)insertArticles:(NSArray<WMFArticle *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeArticlesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInArticlesAtIndex:(NSUInteger)idx withObject:(WMFArticle *)value;
- (void)replaceArticlesAtIndexes:(NSIndexSet *)indexes withArticles:(NSArray<WMFArticle *> *)values;
- (void)addArticlesObject:(WMFArticle *)value;
- (void)removeArticlesObject:(WMFArticle *)value;
- (void)addArticles:(NSOrderedSet<WMFArticle *> *)values;
- (void)removeArticles:(NSOrderedSet<WMFArticle *> *)values;

@end

NS_ASSUME_NONNULL_END
