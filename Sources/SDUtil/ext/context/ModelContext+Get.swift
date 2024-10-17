import Foundation
import SwiftData
/**
 * Getters
 * - Fixme: ⚠️️ Rename file to +read?
 */
extension ModelContext {
   /**
    * Read
    * - Description: This method reads data from the database based on a provided descriptor. 
    *                It is designed to fetch a collection of objects of type `T` that match
    *                the criteria specified in the descriptor.
    * - Note: `CoreData` kan have generic predicates it seems, see depercated util code
    * - Fixme: ⚠️️ add abstract description
    * - Parameters:
    *   - descriptor: A `FetchDescriptor` object that defines the criteria
    *                 for fetching data from the database. It specifies the
    *                 type of data to fetch and any additional constraints or
    *                 filters to apply.
    * - Returns: An array of objects of type `T` that match the criteria specified in the descriptor.
    */
   public func readData<T>(descriptor: FetchDescriptor<T>) throws -> [T] {
      try self.fetch(descriptor)
   }
   /**
    * Get count for a descriptor
    * - Abstract: Retrieves the count of objects that match the criteria specified in the descriptor without loading them.
    * - Description: This method is designed to efficiently count the number of objects of type `T` 
    *                that match the criteria defined in the provided `FetchDescriptor`, without fetching 
    *                the actual objects. It is particularly useful for scenarios where only the count is
    *                needed, such as for pagination or to determine the existence of data.
    * - Note: Alt name: `readCount`
    * - Note: ref: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-count-results-without-loading-them
    * - Example: To count the number of `User` instances that match a specific condition, use:
    *   ```swift
    *   let userCountDescriptor = FetchDescriptor<User>(predicate: NSPredicate(format: "isActive == %@", NSNumber(value: true)))
    *   let activeUserCount = try context.getCount(descriptor: userCountDescriptor)
    *   print("Active users count: \(activeUserCount)")
    *   ```
    * - Parameter descriptor: A `FetchDescriptor` object that defines the
    *                         criteria for fetching data from the database. It specifies the type
    *                         of data to fetch and any additional constraints or filters to apply.
    * - Returns: The count of objects of type `T` that match the criteria specified in the descriptor.
    */
   public func getCount<T>(descriptor: FetchDescriptor<T>) throws -> Int {
      try self.fetchCount(descriptor)
   }
   /**
    * The idea is to get the last change. So we can use that to assert if db has changed
    * - Description: This method retrieves the last object of type `T` from the database, 
    *                sorted by the specified key path in descending order. It is useful for
    *                obtaining the most recent entry based on a particular attribute.
    * - Note: https://stackoverflow.com/questions/78235806/fetch-the-last-record-by-date-in-swiftdata
    * Example usage:
    * Assuming `User` is a `PersistentModel` and has a `lastLoginDate` property of type `Date`:
    * ```
    * do {
    *     let lastLoggedInUser = try context.getLast(sortedBy: \User.lastLoginDate)
    *     print("Last logged in user: \(String(describing: lastLoggedInUser))")
    * } catch {
    *     print("An error occurred: \(error)")
    * }
    * ```
    */
   public func getLast<T: PersistentModel, V: Comparable>(sortedBy keyPath: KeyPath<T, V>) throws -> T? {
      var fetchDescriptor = FetchDescriptor<T>(sortBy: [SortDescriptor(keyPath, order: .reverse)])
      fetchDescriptor.fetchLimit = 1
      let items: [T] = try self.fetch(fetchDescriptor)
      return items.first
   }
}
