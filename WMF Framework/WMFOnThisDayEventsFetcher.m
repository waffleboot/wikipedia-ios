#import "WMFOnThisDayEventsFetcher.h"
#import "WMFFeedOnThisDayEvent.h"
#import <WMF/WMF-Swift.h>

@interface WMFOnThisDayEventsFetcher ()

@property (nonatomic, strong) AFHTTPSessionManager *operationManager;

@end

@implementation WMFOnThisDayEventsFetcher

- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager wmf_createIgnoreCacheManager];
        manager.responseSerializer = [WMFMantleJSONResponseSerializer serializerForArrayOf:[WMFFeedOnThisDayEvent class] fromKeypath:@"events"];
        NSMutableIndexSet *set = [manager.responseSerializer.acceptableStatusCodes mutableCopy];
        [set removeIndex:304];
        manager.responseSerializer.acceptableStatusCodes = set;
        self.operationManager = manager;
    }
    return self;
}

- (BOOL)isFetching {
    return [[self.operationManager operationQueue] operationCount] > 0;
}

- (void)fetchOnThisDayEventsForURL:(NSURL *)siteURL month:(NSUInteger)month day:(NSUInteger)day failure:(WMFErrorHandler)failure success:(void (^)(NSArray<WMFFeedOnThisDayEvent *> *announcements))success {
    NSParameterAssert(siteURL);
    if (siteURL == nil || month < 1 || day < 1) {
        NSError *error = [NSError wmf_errorWithType:WMFErrorTypeInvalidRequestParameters
                                           userInfo:nil];
        failure(error);
        return;
    }

    NSURL *url = [siteURL wmf_URLWithPath:[NSString stringWithFormat:@"/api/rest_v1/feed/onthisday/events/%lu/%lu", (unsigned long)month, (unsigned long)day] isMobile:NO];

    [self.operationManager GET:[url absoluteString]
        parameters:nil
        progress:NULL
        success:^(NSURLSessionDataTask *operation, NSArray<WMFFeedOnThisDayEvent *> *responseObject) {
            if (![responseObject isKindOfClass:[NSArray class]]) {
                failure([NSError wmf_errorWithType:WMFErrorTypeUnexpectedResponseType
                                          userInfo:nil]);
                return;
            }

            WMFFeedOnThisDayEvent *event = responseObject.firstObject;
            if (![event isKindOfClass:[WMFFeedOnThisDayEvent class]]) {
                failure([NSError wmf_errorWithType:WMFErrorTypeUnexpectedResponseType
                                          userInfo:nil]);
                return;
            }

            success(responseObject);
        }
        failure:^(NSURLSessionDataTask *operation, NSError *error) {
            failure(error);
        }];
}

@end
