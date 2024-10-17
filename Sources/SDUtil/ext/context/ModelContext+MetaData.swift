import Foundation
import SwiftData
import CoreData
//import Logger
/**
 * - Note: We might be also able to access metafdata from entry model: `change.persistentBackingData.metadata`
 */
extension ModelContext {
   /**
    * Retrieves metadata associated with a `CoreData` SQLite file.
    * - Description: This method attempts to fetch metadata from a `CoreData` SQLite file specified 
    *                by its URL. It is designed to provide access to metadata stored within the file,
    *                which can be useful for various purposes such as data analysis or debugging.
    * - Note: Alt name: `readMetaData`
    * - Fixme: ⚠️️ Add own custom error? enum MetaDataError: Error { case coordinator, store }
    * - Parameters:
    *   - config: The configuration of the `CoreData` SQLite file.
    *   - url: The URL of the `SQLite` file. This is used to access the file and its metadata.
    * - Returns: An optional dictionary of metadata associated with the SQLite
    *            file. If the file does not exist or there is an error, it returns `nil`.
    */
   internal func getMetaData(url: URL) throws -> [String: Any]? {
      guard let coordinator: NSPersistentStoreCoordinator = self.coordinator else { // Get the persistent store coordinator for the managed object context, and throw an error if it's `nil`
         throw NSError(domain: "MetaData.getMetaData() - ⚠️️ unable to get coordinator", code: 0) // Throw an error if the coordinator is not found
      }
      guard let store: NSPersistentStore = coordinator.persistentStore(for: url) else { // Get the persistent store for the Core Data stack configuration, and throw an error if it's `nil`
         throw NSError(domain: "MetaData.getMetaData() - ⚠️️ unable to find store", code: 0) // Throw an error if the store is not found
      }
      return coordinator.metadata(for: store) // Get the metadata for the persistent store
   }
   /**
    * Sets metadata
    * - Description: This method updates the metadata associated with a `CoreData` SQLite file. 
    *                It is designed to modify the metadata stored within the file,
    *                which can be useful for various purposes such as data analysis or debugging.
    * - Note: Alt name: `insertMetaData`
    * - Fixme: ⚠️️ add MetaDataError 👈
    * - Parameters:
    *   - metadata: Dict to set as metadata in `CoreData`
    *   - config: Config of `CoreData` `SQLite` file
    *   - url: The URL of the SQLite file. This is used to access the file and it's metadata.
    */
   internal func setMetaData(metadata: [String: Any], url: URL) throws {
      guard let coordinator: NSPersistentStoreCoordinator = self.coordinator else { // Get the persistent store coordinator for the managed object context, and throw an error if it's `nil`
         throw NSError(domain: "MetaData.getMetaData() - ⚠️️ unable to get coordinator", code: 0)
      }
      guard let store: NSPersistentStore = coordinator.persistentStore(for: url) else { // Get the persistent store for the Core Data stack configuration, and throw an error if it's `nil`
         throw NSError(domain: "MetaData.getMetaData() - ⚠️️ unable to find store", code: 0)
      }
      coordinator.setMetadata(metadata, for: store) // Set the metadata for the persistent store using the persistent store coordinator
      // - Fixme: ⚠️️ This can't be save if changed, as changed doesn't apply for metadata, verify this some more how it works etc
      try self.save() // Save the changes to the SQLite file
   }
}
/**
 * - Note: ref: https://fatbobman.com/en/posts/use-core-data-features-in-swiftdata-by-swiftdatakit/
 */
extension ModelContext {
   /**
    * Computed property to access the `NSPersistentStoreCoordinator`
    * - Description: This property provides a convenient way to access the `NSPersistentStoreCoordinator` 
    *                associated with the `ModelContext`. It is particularly useful when resetting the 
    *                database or performing operations that require direct access to the coordinator.
    * - Note: We also use this when we reset the database
    * - Returns: An optional `NSPersistentStoreCoordinator` object, which is the coordinator associated with the `ModelContext`. If the coordinator cannot be found, it returns `nil`.
    */
   internal var coordinator: NSPersistentStoreCoordinator? {
      // Accesses the persistent store coordinator associated with the managed object context
      managedObjectContext?.persistentStoreCoordinator
   }
   /**
    * Computed property to access the underlying `NSManagedObjectContext`
    * - Description: This property provides a convenient way to access the `NSManagedObjectContext` 
    *                associated with the `ModelContext`. It is particularly useful when performing
    *                operations that require direct access to the context.
    * - Returns: An optional `NSManagedObjectContext` object, which is the managed object context associated with the `ModelContext`. If the context cannot be found, it returns `nil`.
    * - Fixme: ⚠️️ use const for childname?
    */
   fileprivate var managedObjectContext: NSManagedObjectContext? {
      // Use Mirror reflection to access the child property "_nsContext" of the current object
      guard let managedObjectContext: NSManagedObjectContext = getMirrorChildValue(of: self, childName: "_nsContext") as? NSManagedObjectContext else {
         return nil // If the child property is not of type NSManagedObjectContext, return nil
      }
      return managedObjectContext // Return the NSManagedObjectContext object if it is successfully retrieved
   }
}
/**
 * Private helper method to access a child value from an object using Mirror reflection.
 * - Description: This method is designed to dynamically access a child property of an object using 
 *                its name. It leverages Swift's Mirror reflection capabilities to iterate through
 *                the object's children and find the one matching the specified name.
 * - Parameters:
 *   - object: The object from which to access the child value. This can be
 *             any type of object that can be reflected upon using Mirror.
 *   - childName: The name of the child property to access within the object.
 *                This is used to identify the specific child value to return.
 * - Returns: An optional value of type Any, which is the value of the child
 *            property with the specified name if found, or nil if not found.
 */
fileprivate func getMirrorChildValue(of object: Any, childName: String) -> Any? {
   // - Fixme: ⚠️️ add child type
   // Use Mirror to reflect the object and find the first child that matches the specified childName
   guard let child = Mirror(reflecting: object).children.first(where: { $0.label == childName }) else {
      return nil // Return nil if no child with the specified name is found
   }
   // Return the value of the found child
   return child.value
}
