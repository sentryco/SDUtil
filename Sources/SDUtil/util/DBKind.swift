import Foundation
import SwiftData
/**
 * Base database protocol
 * - Description: This protocol serves as the base for all database configurations 
 *                in the application. It provides a set of methods and properties
 *                that are common to all database configurations.
 * - Important: ⚠️️ We add class restriction to the protocol, because
 *                 we can't mutate shared let, not even if it's static
 * - Note: `Database.swift` has boilerplate stubs meant for overriding with fatal error etc. in order to keep doc in one place etc, and keep concrete types simple
 * - Note: More than one context in SwiftData is a hassle to manage etc.
 * - Note: Searching many entites at the same time is a hassle in coredata and swiftdata
 * - Note: `:AnyObject` was `:class` 👉 Using 'class' keyword to define a class-constrained protocol is de-precated; use 'AnyObject' instead
 * - Fixme: ⚠️️ Find reference for why its a hassle to manage more than one context and why searching many entities 👈
 * - Fixme: ⚠️️ Add dbURL, elaborate?
 * - Fixme: ⚠️️ add abstract description as well
 */
public protocol DBKind: AnyObject {
   /**
    * Models
    * - Abstract: Retrieves an array of PersistentModel types associated with the database.
    * - Description: This method returns an array of `PersistentModel` types that are part 
    *                of the database configuration. It is essential for identifying the
    *                models that are managed by the database.
    * - Note: This method is crucial for database operations such as data retrieval, insertion, and deletion, as it provides the necessary model types for these operations.
    * - Fixme: ⚠️️⚠️️⚠️️ This can be static 👈, make sure tests run after etc?
    */
   func getModels() -> [any PersistentModel.Type]
   /**
    * Schema
    * - Description: The schema property provides access to the database schema, which is a crucial aspect 
    *                of database management. It encapsulates the structure and organization of the
    *                data stored in the database, including the relationships between different entities.
    * - Note: The `version` and `encodingVersion` properties in SwiftData serve distinct purposes. `version` represents the version of the database schema, which is used for migration purposes. It allows the database to evolve over time by applying migrations to the schema. On the other hand, `encodingVersion` is related to the data encoding and decoding process. It ensures that the data stored in the database is compatible with the current version of the app. When the data model changes, the `encodingVersion` is incremented to reflect these changes, allowing the app to handle data from previous versions correctly.
    * - Note: Debug with: `schema.entities.count`, `schema.version`, `schema.encodingVersion`
    */
   func getSchema() -> Schema
   /**
    * Config
    * - Description: This section provides important notes and considerations for 
    *                configuring the database. It highlights the complexities of
    *                resetting a database using `url` and `allowSave: false`,
    *                and the potential issues that may arise from using `allowSave: false`
    *                due to a possible bug. Additionally, it emphasizes the need to use
    *                `getDataBaseUrl` for custom paths and the requirement of providing
    *                a URL for autosave to be disabled. It also mentions the use of
    *                `resetDB(url: url)` for resetting the database and the available
    *                configuration options, including `.isStoredInMemoryOnly` and `.allowsSave`.
    *                Finally, it notes that removing the database file can be used to
    *                restart the database, and that `isStoredInMemoryOnly` can be useful for
    *                debugging in preview mode.
    * - Important: ⚠️️ url + allowSave: false is extremly finicky if you want to reset a db. The process that works is: 1. delete the db file. 2. create db file with new model 3. add url and allowsSave: false. allows save must have url
    * - Important: ⚠️️ if we use: allowsSave: false, it seems like we get "The file couldn’t be saved because you don’t have permission." probably a bug, so skip using it for now. I think allows save means writable, not autosave. we set autosave on the context
    * - Note: Seems like we have to use the getDataBaseUrl, other custom paths doesnt work out of the box
    * - Note: Seems we have to provide an url for autosave to be off
    * - Note: Use resetDB(url: url) to reset
    * - Note: Options: `.isStoredInMemoryOnly`, `.allowsSave`
    * - Note: You can restart the database by removing the file
    * - Note: `isStoredInMemoryOnly` can be used for debuggin in preview, altho filebased db also works in preview
    */
   func getConfig() -> ModelConfiguration
   /**
    * Container
    * Description: This section is responsible for managing the container that holds 
    *              the database configurations. It provides a way to access the container,
    *              which is essential for database operations such as data retrieval,
    *              insertion, and deletion. The container can be thought of as a central
    *              hub that coordinates the interactions between different parts of the database.
    * - Note: Seems we can omit schema in config if it is provided here, or add to both, but not just here, this is because we can add many configs to one container
    * - Note: Use container.deleteAllData() to empty container
    */
   func getContainer() throws -> ModelContainer
}
