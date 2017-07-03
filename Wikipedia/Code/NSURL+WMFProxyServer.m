#import <WMF/NSURL+WMFProxyServer.h>
#import <WMF/NSURL+WMFQueryParameters.h>

NSString *const WMFProxyImageOriginalSrcKey = @"originalSrc";
NSString *const WMFProxyImageBasePath = @"imageProxy";
NSString *const WMFProxyFileBasePath = @"fileProxy";
NSString *const WMFProxyAPIBasePath = @"APIProxy";
NSString *const WMFProxyMediaBasePath = @"mediaProxy";

@implementation NSURL (WMFProxyServer)

- (nullable NSURL *)wmf_imageProxyOriginalSrcURL {
    return [NSURL URLWithString:[self wmf_valueForQueryKey:WMFProxyImageOriginalSrcKey]];
}

- (NSURL *)wmf_imageProxyURLWithOriginalSrc:(NSString *)originalSrc {
    return [self wmf_urlWithValue:originalSrc forQueryKey:WMFProxyImageOriginalSrcKey];
}

@end
