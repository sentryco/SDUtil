import Foundation
import SwiftData
/**
 * Set
 */
extension SDUtil {
   /**
    * Removes the database file at the specified URL.
    * - Description: This method checks if a database file exists at the given URL and 
    *                attempts to remove it if it does. This operation is useful for 
    *                resetting the database state, especially when model changes occur.
    *                However, in a production environment, it is recommended to use
    *                a migration schema instead of removing the database file.
    * - Note: If model changes, sometimes we just reset the db
    * - Note: This method does not throw an error if the file does not exist or if the removal fails. It is recommended to modify this method to throw an error in such cases.
    * - Fixme: ⚠️️ Use migrationSchema if it's in production
    * - Fixme: ⚠️️ Move to URL scope or? add reasoning etc
    * - Fixme: ⚠️️ Make this throw 👈
    * - Parameter url: The URL of the database file to be removed.
    * - Returns: This method does not return a value. It modifies the file system by removing the database file if it exists.
    */
   public static func removeDB(url: URL) {
      // Check if the default database exists at the given URL
      if assertDefaultDBExists(url: url) {
         try? FileManager.default.removeItem(at: url) // This will reset the database every time
      }
   }
   /**
    * Asserts the existence of a database file at the specified URL.
    * - Description: This method checks if a database file exists at the given URL. 
    *                It is used to verify the presence of a database file before
    *                performing operations that require its existence.
    * - Note: This method is designed to work with the default file manager provided by the system.
    * - Note: Alt name: `assertFileExists`
    * - Fixme: ⚠️️ Move to URL scope or? because it's FileManager util code. or at least make an ext?
    * - Parameter url: The URL of the database file to check for existence.
    * - Returns: A boolean indicating whether the database file exists at the specified URL.
    */
   fileprivate static func assertDefaultDBExists(url: URL) -> Bool {
       // Checks if the file exists at the specified URL path
       FileManager.default.fileExists(atPath: url.path)
   }
   /**
    * ⚠️️ Temp solution ⚠️️
    * - Abstract: Resets the database file associated with the given database configuration.
    * - Description: This method is a temporary solution for resetting the database file. 
    *                It is designed to remove all data associated with the specified database
    *                configuration. The method attempts to wipe all data for the models defined
    *                in the database configuration and then deletes the database file itself.
    * - Note: Alternative names for this: `reset`, `destroy`, `nuke`, `remove`, `obliterate`, `zap`
    * - Remark: Seems like this does not work if we use getContainer in the code, it works if we use the lazy container
    * - Fixme: ⚠️️ Make it throw 👈
    * - Fixme: ⚠️️ Do some more research into wiping dbs in swiftdata etc
    * - Parameter db: The database configuration for which the database file is to be reset.
    */
   public static func resetDB(db: DBKind) {
      // Swift.print("☢️ Reset db - url: : \(db.url)")
      // Attempts to retrieve the container for the database configuration and wipes all data for the models associated with the configuration
      (try? db.getContainer())?.wipe(models: db.getModels())
       // Deletes all data from the database container
      (try? db.getContainer())?.deleteAllData() // ref: https://useyourloaf.com/blog/swiftdata-deleting-data/
       // Attempts to retrieve the context from the database
      let context = try? db.getContext()
      // Iterates through each persistent store associated with the context's coordinator
      // This part wipes the index etc, also db file I think ishh, altho its stil there for some reason
      context?.coordinator?.persistentStores.forEach { store in
         // Ensures a URL is available for the current store
         guard let url = store.url else { Swift.print("Err ⚠️️ no url"); return }
         // Attempts to destroy the persistent store at the specified URL using SQLite type
         try? context?.coordinator?.destroyPersistentStore(at: url, type: .sqlite)
      }
   }
   /**
    * Resets all database files associated with the given database configurations.
    * - Description: This method iterates through an array of database configurations 
    *                and calls `resetDB(db:)` on each configuration to reset its associated
    *                database file. This is a convenient way to reset multiple databases at once.
    * - Note: Alt name: `zapDBs`
    * - Parameter dbs: An array of database configurations for which the database files are to be reset.
    */
   public static func resetDBs(dbs: DBKinds) {
      // Iterates through each database configuration in the array and calls the resetDB method on each configuration
      dbs.forEach { resetDB(db: $0) }
   }
}
