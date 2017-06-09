import Foundation

@objc(WMFEventLoggingService)
class EventLoggingService : NSObject {

    private static let LoggingEndpoint =
        // production
        "https://meta.wikimedia.org/beacon/event"
        // testing
        // "http://deployment.wikimedia.beta.wmflabs.org/beacon/event";
    
    private let reachabilityManager: AFNetworkReachabilityManager
    
    private var lastNetworkRequestTimestamp: TimeInterval?
    
    static let shared = EventLoggingService()
    
    public init(reachabilityManager: AFNetworkReachabilityManager = AFNetworkReachabilityManager.shared()) {
        self.reachabilityManager = reachabilityManager
    }
    
    deinit {
        stop()
    }
    
    private var urlSession: URLSession {
        get {
            return URLSession.shared
        }
    }
    
    private var eventQueue: [EventCapsule] = []
    
    public func start() -> Void {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.WMFNetworkRequestBegan, object: nil, queue: .main) { (note) in
            self.lastNetworkRequestTimestamp = Date.timeIntervalSinceReferenceDate
            DDLogDebug("last network request: \(String(describing: self.lastNetworkRequestTimestamp))")
        }
    }
    
    public func stop() -> Void {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func logEvent(_ eventCapsule: EventCapsule) -> Void
    {
        eventQueue.append(eventCapsule)
    }
    
    private func postEvent(_ eventCapsule: EventCapsule) -> Void {

        let payload: [String:Any] =  [
            "event": eventCapsule.event,
            "schema": eventCapsule.schema,
            "revision": eventCapsule.revision,
            "wiki": eventCapsule.wiki
        ]
        
        do {
            let payloadJsonData = try JSONSerialization.data(withJSONObject:payload, options: [])
            guard let payloadString = String(data: payloadJsonData, encoding: .utf8) else {
                DDLogError("Could not convert JSON data to string")
                return
            }
            let encodedPayloadJsonString = payloadString.wmf_UTF8StringWithPercentEscapes()
            let urlString = "\(EventLoggingService.LoggingEndpoint)?\(encodedPayloadJsonString)"
            guard let url = URL(string: urlString) else {
                DDLogError("Could not convert string '\(urlString)' to URL object")
                return
            }
            
            var request = URLRequest(url: url)
            request.setValue(WikipediaAppUtils.versionedUserAgent(), forHTTPHeaderField: "User-Agent")
            urlSession.dataTask(with: request).resume()
            
        } catch let error {
            DDLogError(error.localizedDescription)
        }
    }
}