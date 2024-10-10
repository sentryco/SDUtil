import Foundation
import SwiftData
/**
 * This extension provides additional functionality for the `ModelContext` class, including utility methods for managing and saving changes to the model context. It is designed to enhance the efficiency and reliability of database operations within the application.
 * - Description: The `ModelContext` extension adds utility methods that simplify the process of 
 *                managing and saving changes to the model context. These methods help ensure that
 *                changes are properly tracked and saved, reducing the risk of data loss and
 *                improving the overall stability of the application.
 */
extension ModelContext {
   /**
    * - Abstract: This method attempts to save changes to the model context if there are any pending
    *             changes. It is a utility function that simplifies the process of saving changes
    *             to the database. If there are no changes, it does not perform any save operation.
    * - Description: This method attempts to save any pending changes to the model context.
    *                If there are no changes, it does not perform any save operation. This helps 
    *                ensure that only necessary save operations are performed, improving efficiency.
    * - Note: ref: https://useyourloaf.com/blog/swiftdata-saving-changes/
    */
   public func saveIfChanged() throws {
      guard hasChanges else { return } // Check if there are any changes to save, exit if not
      try save() // Attempt to save the changes
   }
}
