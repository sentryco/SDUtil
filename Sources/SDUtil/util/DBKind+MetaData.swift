import Foundation
import SwiftData
//import CoreData
//import Logger
/**
 * MetaData
 * - Abstract: This extension provides access to the metadata associated with a `DBKind` instance. Metadata is a collection of key-value pairs that can be used to store additional information about the database configuration. The metadata is stored in a dictionary where each key is a string and each value is also a string.
 * - Description: Metadata in the context of `DBKind` serves as a flexible storage solution for additional, non-structural data that can influence or reflect the state of the database configuration. This can include configuration flags, versioning information, or custom settings that do not directly alter the database schema but are essential for operational purposes.
 */
extension DBKind {
   /**
    * `Metadata` key / value dictionary access
    * - Description: This property provides access to the metadata associated with 
    *                a `DBKind` instance. Metadata is a collection of key-value pairs
    *                that can be used to store additional information about the database
    *                configuration. The metadata is stored in a dictionary where each
    *                key is a string and each value is also a string.
    * - Remark: metaData["someKey"] = "someValue" // Appends value to current metaData structure, keeps dict intact
    * - Remark: The metadata sync-log keeps track of latest peer updates
    * - Remark: Keeps track of update status for each peer by storing the latest `changeUUID` it received successfully
    * - Fixme: ⚠️️ Make it throw? this would require it being a function etc
    * - Fixme: ⚠️️ Add Abstract
    * - Example: 
    *   ```swift
    *   var db = DB()
    *   db.metaData["version"] = "1.0"
    *   let currentVersion = db.metaData["version"]
    *   print("Current DB version: \(currentVersion ?? "unknown")")
    *   ```
    * - Returns: A dictionary of metadata where each key is a string and each value is also a string.
    */
   public var metaData: [String: String] {
      get {
         do {
            // Get the metadata dictionary for the Core Data stack configuration
            guard let url: URL = try? self.getContainer().configurations.first?.url else { Swift.print("⚠️️ Err - no url"); return [:] }
            // Attempts to retrieve the metadata dictionary from the context using the provided URL
            let metaData: [String: Any]? = try self.getContext().getMetaData(url: url)
            // Filter out non-string values and return the metadata dictionary, or an empty dictionary if it's `nil`
            return metaData?.compactMapValues { $0 as? String } ?? [:]
         } catch {
//            Logger.error("\(Trace.trace()) - error: \(error.localizedDescription)") // Log an error if there's an exception
            return [:] // Return an empty dictionary
         }
      } set {
         do {
            // Set the metadata dictionary for the Core Data stack configuration
            guard let url: URL = try? self.getContainer().configurations.first?.url else { Swift.print("⚠️️ Err - no url"); return }
            // Attempts to set the metadata dictionary for the given URL using the current context
            try self.getContext().setMetaData(
               metadata: newValue, // Passes the new metadata dictionary to be set
               url: url // Specifies the URL associated with the metadata
            )
         } catch {
//            Logger.error("\(Trace.trace()) - error: \(error.localizedDescription)") // Log an error if there's an exception
         }
      }
   }
}
