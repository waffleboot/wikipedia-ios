#import <WMF/WMFContentGroup+CoreDataProperties.h>

@implementation WMFContentGroup (CoreDataProperties)

+ (NSFetchRequest<WMFContentGroup *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WMFContentGroup"];
}

@dynamic articleURLString;
@dynamic content;
@dynamic contentGroupKindInteger;
@dynamic contentMidnightUTCDate;
@dynamic contentTypeInteger;
@dynamic dailySortPriority;
@dynamic date;
@dynamic isVisible;
@dynamic key;
@dynamic location;
@dynamic midnightUTCDate;
@dynamic placemark;
@dynamic siteURLString;
@dynamic wasDismissed;
@dynamic items;

@end
