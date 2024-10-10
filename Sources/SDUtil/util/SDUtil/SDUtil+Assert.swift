import Foundation
import SwiftData
/**
 * Assert
 */
extension SDUtil {
   /**
    * Checks if a persistent file exists for the given database configuration.
    * - Description: This method attempts to retrieve the URL of the first configuration 
    *                from the database container. If the URL cannot be found,
    *                it prints an error message and returns false. If the URL is found,
    *                it checks if a persistent store file exists at that URL and returns
    *                true if it does, false otherwise.
    * - Fixme: ⚠️️ maybe print the throw error ?
    * - Fixme: ⚠️️ add abstract
    * - Parameter db: The database configuration to check for a persistent file.
    * - Returns: A boolean indicating whether a persistent file exists for the given database configuration.
    */
   public static func hasPersistentFile(db: DBKind) -> Bool {
      // Attempts to retrieve the URL of the first configuration from the database container. If the URL cannot be found, it prints an error message and returns false.
      guard let url: URL = try? db.getContainer().configurations.first?.url else { Swift.print("⚠️️ Err - no url"); return false }
      // let url: URL = SDUtil.getDatabaseURL(fileName: "", dir: nil)
      let hasPersistentFile: Bool = FileManager().fileExists(atPath: url.path) // Check if the persistent store file exists at the given URL
      // Logger.debug("\(Trace.trace()) - hasPersistentFile: \(hasPersistentFile)") - This line is commented out and does not affect the code
      return hasPersistentFile // Return `true` if the persistent store file exists, `false` otherwise
   }
}
