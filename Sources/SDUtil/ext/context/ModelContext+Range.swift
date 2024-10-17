import Foundation
import SwiftData
/**
 * Getters
 */
extension ModelContext {
   /**
    * Attempts to read the first index of an object of type `T` based on a provided `FetchDescriptor`.
    * - Description: This method is designed to efficiently retrieve the index of the first object 
    *                that matches the criteria specified in the `FetchDescriptor`.
    *                It is particularly useful for scenarios where the index of a specific object
    *                is needed, such as for sorting or positioning within a dataset.
    * - Note: ref: https://stackoverflow.com/questions/76509438/swiftdata-use-objectid-urirepresentation-to-load-coredata-object
    * - Note: ID(url: x-coredata://D9E927FF-A996-41A9-97DB-00CA5AD003EE/Change/p1)
    * - Fixme: ⚠️️ Test if obj isTemporaryID etc see legacy, elaborate?
    * - Fixme: ⚠️️ Add example to comment? And add test to unit test?
    * - Parameters:
    *   - descriptor: A `FetchDescriptor` object that defines the criteria for fetching data from the database. It specifies the type of data to fetch and any additional constraints or filters to apply.
    * - Returns: An optional `Int64` value representing the index of the first object that matches the criteria specified in the `FetchDescriptor`. If no object matches the criteria, it returns `nil`.
    */
   public func readFirstIndex<T: PersistentModel>(descriptor: FetchDescriptor<T>) throws -> Int64? {
      let match: T? = try readFirst(descriptor: descriptor) // Read the first object that matches the descriptor
      guard let id: PersistentIdentifier = match?.persistentModelID else { return nil } // Get the persistent model ID of the match, return nil if it's not found
      guard let url: URL = try id.uriRepresentation() else { return nil } // Get the URI representation of the ID, return nil if it's not found
      // Split the URL string into components using "/p" as the separator
      let components: [String] = url.absoluteString.components(separatedBy: "/p") // Get the components of the object ID URI
      // Ensure there are at least two components in the array
      guard components.count > 1 else { return nil } // Check if there are more than 1 element in the components array
      // Attempt to convert the second component to an Int64
      guard let idx: Int64 = .init(components[1]) else { return nil } // Try to convert the second element of the components array to an `Int64`
      // Adjust the index from 1-based to 0-based
      return idx - 1 // Subtract 1 from the index to convert from 1-based to 0-based indexing
   }
   /**
    * Reads the first object of type `T` that matches the criteria specified in the `FetchDescriptor`.
    * - Description: This method is designed to efficiently retrieve the first object of type `T` 
    *                that matches the criteria defined in the provided `FetchDescriptor`.
    *                It is particularly useful for scenarios where only the first object is needed,
    *                ch as for displaying a single item or initializing a process.
    * - Note: `CoreData` can have generic predicates it seems
    * - Fixme: ⚠️️ Add example to comment? And add test to unit test?
    * - Parameters:
    *   - descriptor: A `FetchDescriptor` object that defines the criteria for fetching data from the database. It specifies the type of data to fetch and any additional constraints or filters to apply.
    * - Returns: An optional object of type `T` that matches the criteria specified in the `FetchDescriptor`. If no object matches the criteria, it returns `nil`.
    */
   public func readFirst<T: PersistentModel>(descriptor: FetchDescriptor<T>) throws -> T? {
      // Create a mutable copy of the descriptor to modify it's fetch limit
      var descriptor: FetchDescriptor<T> = descriptor
      // Set the fetch limit to 1 to only fetch the first object
      descriptor.fetchLimit = 1
      // Attempt to fetch the first object that matches the descriptor and return it
      return try self.fetch(descriptor).first
   }
}
/**
 * Private helper
 */
extension PersistentIdentifier {
   /**
    * Attempts to convert the `PersistentIdentifier` to a URL representation.
    * - Description: This method is designed to transform the `PersistentIdentifier` into a URL 
    *                string that can be used for various purposes such as data retrieval or
    *                identification. It leverages JSON encoding and serialization to extract
    *                the URI representation from the identifier.
    * - Fixme: ⚠️️ Add example to comment? And add test to unit test?
    * - Fixme: ⚠️️ Move keys to const
    * - Returns: An optional `URL` object representing the URI of the `PersistentIdentifier`. If the conversion fails or the URI representation is not found, it returns `nil`.
    */
   fileprivate func uriRepresentation() throws -> URL? {
      // Encode the `PersistentIdentifier` into a JSON object
      let encoded = try JSONEncoder().encode(self)
      // Deserialize the JSON object into a JSON object
      let jsonObj = try JSONSerialization.jsonObject(with: encoded)
      // Attempt to cast the JSON object to a dictionary
      if let dictionary = jsonObj as? [String: Any],
         // Extract the "implementation" dictionary from the JSON object
         let implementation = dictionary["implementation"] as? [String: Any],
         // Extract the "uriRepresentation" string from the "implementation" dictionary
         let uriRepresentation = implementation["uriRepresentation"] as? String {
         // Convert the "uriRepresentation" string to a URL and return it
         return URL(string: uriRepresentation)
      } else {
         // Return nil if the URI representation cannot be extracted
         return  nil
      }
   }
}
