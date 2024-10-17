[![Tests](https://github.com/sentryco/SDUtil/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/SDUtil/actions/workflows/Tests.yml)

# SDUtil

> Makes SwiftData easier to work with

SDUtil is a library that enhances the functionality of SwiftData by providing easy access to metadata and reading the insert order of data entities. 

## Features

- **Easy access to metadata**: Read and write metadata to the database with simple syntax. `db.metaData["version"] = "1.0"` and `let version = db.metaData["version"]`

- **Easily work with insert index**: Iterating through the database based on insert order. `getLast`, `getFirst` `getIndex` etc based on internal core-data index metadata. No record keeping needed

- **Range support**: Fetch data based on a range of indexes. `fetch(range: 0..<10)`

- **Background contexts** For async operations on the database. `getBackgroundContext`

- **Utility Functions**: Reset, remove and assert that databases exists and are working. 

- **Accessible CRUD operations** on the database. `insert`, `delete`, `update`, `fetch` etc

## Examples
 
**Inserting Data**

To insert a new item into the database, you can use the `insert` method from the `ModelContext` extension. This method allows you to specify the item and whether the changes should be saved immediately.

```swift
let context = try Database().getContext()  
let newItem = User(userName: "John", password: "abc123")
try? context.insertData(item: newItem, shouldSave: true)
``` 

**Fetching Data** 

To fetch data using a `FetchDescriptor`, you can use the `readData` method from the `ModelContext` extension. This method allows you to specify the type of data and any constraints or filters. 

```swift 
let context = try Database().getContext()  
let predicate = #Predicate<User> { user in  
    user.userName == "John" 
}
let descriptor = FetchDescriptor<User>(predicate: predicate)  
let results = try context.readData(descriptor: descriptor)
print(results.first?.password)
```

**Resetting the Database** 
 
To reset the database, you can use the `resetDB` method from the `SDUtil` extension. This method wipes all data for the models defined in the database configuration and deletes the database file itself. 
 
```swift 
let db = Database()
SDUtil.resetDB(db: db) 
let context = try? db.getContext()
let results = try? context?.fetch(FetchDescriptor<User>())
print(results.count)
```  

## Installation

```swift
.package(url: "https://github.com/sentryco/SDUtil", branch: "main")
```

## TODO: 

- 1. Error Handling:
the error handling could be improved by throwing and managing errors more effectively rather than just returning empty dictionaries or ignoring the errors.

- 2. Metadata Management:
The metadata functionality could be expanded to include more robust features such as versioning, audit trails, and synchronization mechanisms, especially if the metadata is critical for the application's functionality.

- 3. Testing and Coverage:
Increase the unit test coverage for critical components, especially those handling database operations and metadata management. This could help ensure stability and catch potential issues early. The TODO item in the README.md (startLine: 71, endLine: 74) about adding delete operations to unit tests is a good start.
    
- 4. Documentation and Examples:
Ensuring that all public APIs are well-documented and include examples can significantly improve the developer experience and ease of use.
Consider adding more complex examples that showcase the full capabilities of the library, such as handling concurrent database operations or integrating with other systems.

- 5. Refactoring and Code Organization:
Make variables and function names more consistent

- 6. Performance Optimization:
Review and optimize database interactions, especially those that might be impacted by large datasets or complex queries. Profiling and benchmarking could be used to identify bottlenecks.

- 7. Security Enhancements:
Ensure that all data handling practices meet security best practices, particularly in how metadata is managed and accessed. This includes securing any sensitive information that might be stored in the metadata.

 