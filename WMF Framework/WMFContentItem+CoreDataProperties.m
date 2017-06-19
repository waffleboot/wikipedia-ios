#import <WMF/WMFContentItem+CoreDataProperties.h>

@implementation WMFContentItem (CoreDataProperties)

+ (NSFetchRequest<WMFContentItem *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"WMFContentItem"];
}

@dynamic articleURLString;
@dynamic contentTypeInteger;
@dynamic date;
@dynamic midnightUTCDate;
@dynamic object;
@dynamic group;

@end
