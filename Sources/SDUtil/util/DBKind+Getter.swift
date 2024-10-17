import Foundation
import SwiftData
/**
 * Getter
 * fix: ⚠️️ add highlevel description why we have these methods etc
 */
extension DBKind {
   /**
    * Default container
    * - Abstract: This method retrieves the default container for the database. 
    *             The container is a central hub that coordinates the interactions
    *             between different parts of the database. It is essential for database
    *             operations such as data retrieval, insertion, and deletion.
    * - Description: This method is responsible for retrieving the default container for the database. The container acts as a central hub that coordinates interactions between different parts of the database, such as data retrieval, insertion, and deletion. It is essential for ensuring the proper functioning of database operations.
    * - Throws: An error of type `Error` if the container initialization fails.
    * - Returns: A `ModelContainer` instance that is initialized with the schema and configuration of the database.
    */
   public func getContainer() throws -> ModelContainer {
      // Initialize a new ModelContainer with the schema and configuration
      try .init(
         for: getSchema(), // Retrieves the schema for the container
         configurations: [getConfig()] // Adds the configuration to the container
      )
   }
   /**
    * Default schema
    * - Abstract: Initializes a new schema instance with the models retrieved from the database. 
    *             This method is responsible for creating a schema that represents the structure
    *             and organization of the data in the database. It achieves this by using the models
    *             associated with the database configuration.
    * - Description: This method initializes a new schema instance using the models retrieved from 
    *                the database. The schema represents the structure and organization of the data
    *                within the database, including the relationships between different entities.
    *                It is essential for defining how data is stored, accessed, and managed in the database.
    * - Note: The schema is a crucial component for database operations such as data validation, querying, and migration. It ensures that the data adheres to the defined structure and constraints.
    * - Returns: A `Schema` instance that encapsulates the structure and organization of the database models.
    */
   public func getSchema() -> Schema {
      .init( // Initialize a new Schema instance
         getModels() // Retrieve the models associated with the database
      )
   }
   /**
    * Context
    * - Abstract: We put this in a `getContext` method that throws. much simpler. less guard code etc
    * - Description: Retrieves a new, fresh ModelContext instance.
    * - Important: ⚠️️⚠️️ Careful with this. It will return a new fresh context, if you have something on another context, in might not work with this one etc
    * - Fixme: ⚠️️ Move this to the container scope? elaborate?
    * - Fixme: ⚠️️ Add better error msg to find future bugs
    * - Fixme: ⚠️️ Consider deleting this method, check usage etc
    * - Fixme: ⚠️️ If nil, we should maybe try to use `CDUtil.context(config: config)` to get proper debug data
    * - Note: no need to use func with discarable etc
    */
   public func getContext() throws -> ModelContext {
      let container: ModelContainer = try getContainer() // Retrieve the container for the database
      let modelContext: ModelContext = .init(container) // Initialize a new model context with the retrieved container
      modelContext.autosaveEnabled = false // ⚠️️ Seems to cause problems (see console output), so turn it off
      // Returns the newly created model context
      return modelContext
   }
   /**
    * URL
    * - Description: This property retrieves the URL from the database configuration.
    * - Fixme: ⚠️️ Rename to getURL? or keep? we have to make it a method? maybe wait, maybe we add throw error to it later etc
    */
   internal var url: URL {
      // Retrieves the URL from the database configuration
      self.getConfig().url
   }
}
