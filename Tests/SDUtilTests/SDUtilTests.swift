import XCTest
import SwiftData
import SDUtil
/**
 * SDUtilTests class performs unit tests for the SDUtil library focusing on database operations like insert, fetch, and reset.
 * It ensures that each core functionality adheres to expected behaviors using XCTest framework.
 * - Fix: ⚠️️ Add meta-data test from Database repo. 
 * - Fix: ⚠️️ Add delete test  (Add delete item to unitTests and example code in the readme. Use Copilot to generate.)
 * - Fix: ⚠️️ Add insert order test 
 */
final class SDUtilTests: XCTestCase {
    /**
    * Executes all test cases for the database operations.
    * It tests data insertion, fetching, and database reset functionalities.
    * Errors are caught and logged for debugging purposes.
    */
   func tests() {
      do {
         try Self.testInsertData()
         try Self.testFetchData()
         try Self.testResetDatabase()
      } catch {
         Swift.print("error.localizedDescription:  \(error.localizedDescription)")
      }
   }
}
/**
 * Extension to SDUtilTests containing specific database operation tests
 */
extension SDUtilTests {
   /**
    * Tests the data insertion functionality by adding a new user and verifying the insertion.
    * Throws an error if the insertion process fails.
    */
   fileprivate static func testInsertData() throws {
      // Obtain a context from the database to perform operations.
      let context = try Database().getContext() // Context initialization may throw an error if the database is not accessible.

      // Create a new user instance to be inserted into the database.
      let newItem = User(userName: "John", password: "abc123")

      do {
         // Attempt to insert the new user into the database and save the changes.
         try context.insertData(item: newItem, shouldSave: true)

         // Fetch the count of User objects to verify the insertion was successful.
         let userCount = try context.getCount(descriptor: FetchDescriptor<User>())

         // Print the result of the insertion: success if one user is present, failure otherwise.
         Swift.print("Insert success \(userCount == 1 ? "✅" : "🚫")")
      } catch {
         // If an error occurs during insertion, fail the test with the error message.
         XCTFail("Inserting data failed with error: \(error)")
      }
   }
   /**
    * Tests data fetching by querying for a user named 'John' and validating the fetched data.
    * Throws an error if fetching process fails or data is incorrect.
    */
   fileprivate static func testFetchData() throws {
      // Initialize the database context
      let context = try Database().getContext() // Assuming ModelContext can be initialized like this

      // Define a search predicate to filter users by name
      let predicate = #Predicate<User> { user in // Defines a search predicate to match entries by UUID
         user.userName == "John" // Matches the entry with the specified UUID
      }

      // Create a fetch descriptor using the defined predicate
      let descriptor = FetchDescriptor<User>(predicate: predicate) // Creates a fetch descriptor with the predicate

      do {
         // Fetch data from the context using the descriptor
         let results = try context.readData(descriptor: descriptor)
         
         // Assert that the results are not nil and contain data
         XCTAssertNotNil(results, "Results should not be nil")
         XCTAssertTrue(results.count > 0, "Results should contain data")
         
         // Check if the first result's password is as expected
         Swift.print("Data is correct: \(results.first?.password == "abc123" ? "✅" : "🚫")")
      } catch {
         // Handle errors by failing the test with the error message
         XCTFail("Fetching data failed with error: \(error)")
      }
   }
   /**
    * Tests the database reset functionality by clearing all data and ensuring the database is empty.
    * Throws an error if reset fails or database is not empty post-reset.
    */
   fileprivate static func testResetDatabase() throws {
      // Initialize the Database object. This assumes that Database conforms to DBKind.
      let db = Database()

      do {
         // Attempt to reset the database to a clean state.
         SDUtil.resetDB(db: db) // The 'try' keyword is commented out; ensure error handling is correct.

         // Obtain a context from the database to verify the reset operation.
         let context = try db.getContext()

         // Fetch all User entries to check if the database is indeed empty.
         let results = try context.fetch(FetchDescriptor<User>())

         // Assert that no entries exist in the database after the reset.
         XCTAssertEqual(results.count, 0, "Database should be empty after reset")

         // Print the result of the reset operation: success if no entries are found.
         Swift.print("DB was reset, db is now empty \(results.count == 0 ? "✅" : "🚫")")
      } catch {
         // If an error occurs during the reset process, fail the test with the error message.
         XCTFail("Resetting database failed with error: \(error)")
      }
   }
}
/**
 * Database
 */
class Database: DBKind {
   /**
    * Returns the list of model types that the database can persist.
    * Currently, only `User` model is supported.
    */
   func getModels() -> [any PersistentModel.Type] {
      [User.self]
   }

   /**
    * Provides the configuration settings for the database, including its schema and URL.
    * This configuration is essential for initializing and managing the database.
    */
   func getConfig() -> ModelConfiguration {
      .init(
         schema: getSchema(), // Retrieves the schema definition for the database.
         url: dbURL // The URL where the database file is stored.
      )
   }

   /// The URL of the database file.
   let dbURL: URL

   /**
    * Initializes a new instance of the Database with a specified URL.
    * If no URL is provided, it defaults to a predefined location.
    *
    * - Parameter dbURL: The file URL where the database will be stored. Defaults to 'database.store'.
    */
   init(dbURL: URL = SDUtil.getDatabaseURL(fileName: "database.store")!) {
      self.dbURL = dbURL
   }
}
/**
 * User
 */
@Model
final class User {
   /// The username for the user account.
   var userName: String
   
   /// The password for the user account. Ensure this is stored securely.
   var password: String
   
   /**
    Initializes a new user with specified credentials.
    
    - Parameters:
      - userName: The username for the new user account.
      - password: The password for the new user account. This should be handled securely.
    */
   init(userName: String, password: String) {
      self.userName = userName
      self.password = password
   }
}
