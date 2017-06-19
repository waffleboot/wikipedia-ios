#import "WMFContentItem+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface WMFContentItem (CoreDataProperties)

+ (NSFetchRequest<WMFContentItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *articleURLString;
@property (nonatomic) int16_t contentTypeInteger;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nullable, nonatomic, copy) NSDate *midnightUTCDate;
@property (nullable, nonatomic, retain) NSObject *object;
@property (nullable, nonatomic, retain) WMFContentGroup *group;

@end

NS_ASSUME_NONNULL_END
