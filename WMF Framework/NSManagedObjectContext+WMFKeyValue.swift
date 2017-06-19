import Foundation


extension NSManagedObjectContext {
    @objc(wmf_valueForKey:)
    func wmf_value(for key: String) -> WMFKeyValue? {
        var keyValue: WMFKeyValue? = nil
        let request = WMFKeyValue.fetchRequest()
        request.predicate = NSPredicate(format: "key == %@", key)
        request.fetchLimit = 1
        do {
            keyValue = try fetch(request).first
        } catch let error {
            DDLogError("Error fetching key value: \(error)")
        }
        return keyValue
    }
    
    @objc(wmf_numberValueForKey:)
    func wmf_numberValue(for key: String) -> NSNumber? {
        return wmf_value(for: key)?.value as? NSNumber
    }
    
    @objc(wmf_setValue:forKey:)
    func wmf_set(value: NSObject?, for key: String) {
        let keyValue: WMFKeyValue?
        
        if #available(iOSApplicationExtension 10.0, *) {
            keyValue = wmf_value(for: key) ?? WMFKeyValue(context: self)
        } else if let entity = NSEntityDescription.entity(forEntityName: "WMFKeyValue", in: self) {
            keyValue = wmf_value(for: key) ?? WMFKeyValue(entity: entity, insertInto: self)
        } else {
            keyValue = nil
        }
        
        keyValue?.value = value
        
        if hasChanges {
            do {
               try save()
            } catch let error {
                DDLogError("Error saving key value: \(error)")
            }
        }
        
    }
}
