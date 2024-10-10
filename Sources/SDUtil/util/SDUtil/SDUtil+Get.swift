import Foundation
import SwiftData
/**
 * Getter
 */
extension SDUtil {
   /**
    * Retrieves the URL of a database file created by SwiftData.
    * - Description: SwiftData automatically generates a database file when the app first 
    *                launches. This method provides the ability to retrieve the URL of this
    *                file, which is typically stored in the application support directory.
    *                You can specify a custom file name and directory if needed.
    *                This is useful for accessing or modifying the database file directly.
    * - Note: SwiftData will create a database file when the app first launches. You can get the location of the file that is located in the support directory like so.
    * - Note: The parameters allow the creation of new database files if necessary.
    * - Note: Reference: https://www.hackingwithswift.com/quick-start/swiftdata/how-to-change-swiftdatas-underlying-storage-filename
    * - Fixme: ⚠️️ Consider simplifying the URL construction to: let storeURL = URL.documentsDirectory.appending(path: "database.sqlite")
    * - Fixme: ⚠️️ Consider moving the default file name to a constant for easier maintenance.
    * - Fixme: ⚠️️ add abstract doc
    * - Parameters:
    *   - fileName: The name of the database file to retrieve. Defaults to "default.store" if not specified.
    *   - dir: The directory where the database file is located. Defaults to the application support directory if not specified.
    * - Returns: An optional URL pointing to the location of the database file. Returns `nil` if the file does not exist or the directory is not specified.
    */
   public static func getDatabaseURL(fileName: String = "default.store", dir: URL? = SDUtil.appURL) -> URL? {
      // Attempts to append the specified fileName to the end of the directory URL
      dir?.appendingPathComponent(fileName)
   }
   /**
    * Retrieves the URL of the application group directory.
    * - Description: This method is designed to retrieve the URL of the application group directory. 
    *                The application group directory is a shared directory that allows data to be
    *                shared between the main app and its app extensions. It is typically used to store
    *                shared data, such as user preferences or cached files.
    * - Fixme: ⚠️️ Replace with app-group url, see legacy
    */
   public static var appURL: URL? {
      // Retrieves an array of URLs for the application support directory in the user domain mask
      let urls = FileManager.default.urls( // Get the URLs for the application support directory in the user domain mask
         for: .applicationSupportDirectory, // Specify the application support directory
         in: .userDomainMask // Specify the user domain mask
      )
      // Returns the last URL from the array, which is the most relevant directory
      return urls.last
   }
   /** 
    * Retrieves the URL of the application group directory.
    * - Description: This method fetches the URL for the application group directory, which is a 
    *                shared space that facilitates data sharing between the main application and
    *                it's extensions. It is commonly utilized for storing shared preferences,
    *                configuration settings, or cached data that needs to be accessible across
    *                multiple parts of an application suite.
    */
   public static var tempDirURL: URL {
      let dirPath: String = NSTemporaryDirectory() // Get the path of the temporary directory for the current user
      return .init(
         fileURLWithPath: dirPath, // Initializes a URL with the path of the temporary directory
         isDirectory: true // Specifies that the URL represents a directory
      ) // Create a new URL with the path of the temporary directory and return it (// file:///var/folders/2b/2c_967m52k5fhdyrf77_b01h0000gn/T/ etc)
   }
}
