import Foundation
import SwiftData
/**
 * Extension for `ModelContainer` to provide additional functionality.
 * - Description: This extension includes methods for managing model contexts and
 *                performing database operations in a background thread.
 */
extension ModelContainer {
   /**
    * Typealias for the block
    * - Description: This typealias defines a closure that takes an optional ModelContext as 
    *                a parameter and does not return a value. It is used to execute a block
    *                of code within a background thread with a new ModelContext instance.
    * - Note: This typealias defines a closure that takes an optional ModelContext as a parameter and does not return a value. It is used to execute a block of code within a background thread with a new ModelContext instance.
    */
   public typealias ContextClosure = (_ context: ModelContext?) -> Void
   /**
    * This will require merging into main context
    * - Abstract: Executes a block of code in a background thread with a new ModelContext instance.
    * - Description: This method is designed to perform operations that require a separate 
    *                context, such as merging data into the main context. It is essential
    *                to disable autoSave for the context to ensure proper data merging.
    * - Important: Remember to turn off autoSave: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-merge-two-model-contexts
    * - Note: More on bg thread swift: https://betterprogramming.pub/concurrent-programming-in-swiftdata-c9bf021a4c2d
    * - Fixme: ⚠️️ look into using actor with swift-data CRUD, might fix the need for respawning container etc: https://stackoverflow.com/questions/77253448/how-to-save-swiftdata-outside-swiftui-to-persist
    * - Parameter block: A closure that will be executed in a background thread with a new ModelContext instance. This block is where you would perform operations that require a separate context.
    */
   public func getBackgroundContext(block: @escaping ContextClosure) {
      // Dispatches a block of code to run asynchronously on a background thread with a quality of service set to background
      DispatchQueue.global(qos: .background).async {
         // Creates a new ModelContext instance using the current ModelContainer instance
         let extraContext: ModelContext = .init(self)
         // Executes the provided block with the newly created ModelContext instance
         block(extraContext)
      }
   }
   /**
    * Wipe
    * - Abstract: Clears all data for the specified models from the database.
    * - Description: This method clears all data associated with the specified models from 
    *                the database. It iterates through each model type in the provided array,
    *                creates a new ModelContext instance for each, and attempts to delete all
    *                data associated with that model type. If any deletion operation fails,
    *                an error message is logged.
    * - Side Effects: This method modifies the database by removing data associated with the specified models. It does not return a value but logs an error message if any of the deletion operations fail.
    * - Note: This method is designed to provide a convenient way to clear data for specific models in the database. It is particularly useful for scenarios where a complete reset of specific models is required, such as during testing or when initializing a new database.
    * - Important: ⚠️️ Remember to reset the `shared.container` instance, - Fixme: ⚠️️ elaborate?
    * - Note: there is also: `container.deleteAllData()` not sure what deleteAllData does
    * - Note: Alternative names for this: `reset`, `destroy`, `nuke`, `remove`, `obliterate`, `zap`
    * - Note there is also `SDUtil.resetDB`
    * - Fixme: ⚠️️ add some explination for the models type, its strange, maybe us copilot if there is nothing in legacy etc?
    * - Parameters:
    *   - models: An array of `PersistentModel` types for which all data should be cleared from the database.
    * - Returns: This method does not return a value. It modifies the database by removing data associated with the specified models.
    */
   public func wipe(models: [any PersistentModel.Type]) { // self.getContext { modelContext in
      do {
         // Iterate through each model type in the provided array
         try models.forEach { (_ model: PersistentModel.Type) in
            // Create a new ModelContext instance for each model type
            let context: ModelContext = .init(self)
            // Attempt to delete all data associated with the current model type
            try context.delete(model: model)
         }
      } catch {
         // Log an error message if any of the deletion operations fail
         Swift.print("🚫 Failed to clear all Country and City data.")
      }
   }
}
/**
 * ModelContainer ext
 */
extension ModelContainer {
   /**
    * Provides a convenient way to access a new ModelContext instance.
    * - Description: This property creates and returns a new instance of ModelContext 
    *                using the current ModelContainer instance. It is designed to simplify the 
    *                process of accessing a ModelContext for operations that require a new context.
    * - Returns: An optional ModelContext instance, which is a new context created using the current ModelContainer instance. If the creation fails, it returns `nil`.
    */
   public var context: ModelContext? {
      .init(self) // Creates a new ModelContext instance using the current ModelContainer instance
   }
}
