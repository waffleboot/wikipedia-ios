@import Foundation;

@interface WMFProxyServer : NSObject

@property (nonatomic, readonly, getter=isRunning) BOOL running;

- (void)start;

+ (WMFProxyServer *)sharedProxyServer;

- (NSString *)localFilePathForRelativeFilePath:(NSString *)relativeFilePath; //path for writing files to the file proxy's server

- (NSURL *)proxyURLForRelativeFilePath:(NSString *)relativeFilePath fragment:(NSString *)fragment; //returns the proxy url for a given relative path

// Details: https://github.com/wikimedia/wikipedia-ios/pull/1334/commits/f2b2228e2c0fd852479464ec84e38183d1cf2922
- (NSURL *)proxyURLForWikipediaAPIHost:(NSString *)host;

- (NSString *)stringByReplacingImageURLsWithProxyURLsInHTMLString:(NSString *)HTMLString withBaseURL:(NSURL *)baseURL targetImageWidth:(NSUInteger)targetImageWidth; //replaces image URLs in an HTML string with URLs that will be routed through this proxy

- (void)setResponseData:(NSData *)data withContentType:(NSString *)contentType forPath:(NSString *)path;

- (NSURL *)proxyURLForFiles;
- (NSURL *)proxyURLForMedia;

@end
