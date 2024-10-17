import Foundation
import SwiftData
/**
 * Setters
 */
extension ModelContext {
   /**
    * Inserts a new item into the database and optionally saves the changes.
    * - Description: This method is designed to insert a new item of type `T` into the database. 
    *                It requires the item to be inserted and an optional parameter `shouldSave`
    *                to determine whether the changes should be saved immediately after the
    *                insertion. The default value of `shouldSave` is `true`.
    * - Note: We have to pass the context, as its not in the item
    * - Note: Context has to be spun up right before the item is created and the same context must be used here
    * - Note: I think we disable autoSave when we create the context, so no need to turn it off here
    * - Note: We can get context from the item
    * - Fixme: ⚠️️ Consider renaming to just insert?
    * ## Examples:
    * insert(item: LoginItem.dummyData, container: CredentialDatabase.shared.container)
    * - Parameters:
    *   - item: The item to be inserted into the database.
    *   - shouldSave: A boolean value that determines whether the changes should be saved immediately after the insertion. The default value is `true`.
    */
   public func insertData<T: PersistentModel>(item: T, shouldSave: Bool = true) throws {
      // Inserts the item into the database
      self.insert(item)
      // Checks if the shouldSave parameter is true and attempts to save the changes if there are any
      if shouldSave { try self.saveIfChanged() } // Since auto-save is turned off, we have to save (auto-save has side-effects, thats why its turned off)
   }
   /**
    * Deletes an item from the database and optionally saves the changes.
    * - Description: This method is designed to remove an item of type `T` from the database. 
    *                It requires the item to be deleted and an optional parameter `shouldSave`
    *                to determine whether the changes should be saved immediately after the deletion.
    *                The default value of `shouldSave` is `true`.
    * - Fixme: ⚠️️ move to PersistentModel scope? add reasoning?
    * ## Example:
    * delete(item: User.dummyData, shouldSave: false)
    * - Parameters:
    *   - item: The item to be deleted from the database.
    *   - shouldSave: A boolean value that determines whether the changes should be saved immediately after the deletion. The default value is `true`.
    * - Returns: Throws an error if the deletion or saving fails.
    */
   public func delete(item: any PersistentModel, shouldSave: Bool = true) throws {
      // Removes the specified item from the database
      self.delete(item)
      // Checks if the shouldSave parameter is true and attempts to save the changes if there are any
      if shouldSave { try self.saveIfChanged() }
   }
}
