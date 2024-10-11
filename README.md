[![Tests](https://github.com/sentryco/SDUtil/actions/workflows/Tests.yml/badge.svg)](https://github.com/sentryco/SDUtil/actions/workflows/Tests.yml)

# SDUtil

> Makes SwiftData easier to work with

SDUtil (SwiftData Utility) is a library designed to simplify and enhance the usage of SwiftData in Swift projects. It provides a set of extensions and utilities that streamline common tasks associated with data management in iOS and macOS applications.

## Features

- **Model Context Extensions**: Enhance the functionality of model contexts with additional methods for fetching, inserting, and deleting data.

- **Database Configuration and Management**: Tools for configuring and managing the database lifecycle, including resetting and wiping databases.

- **Utility Functions**: General utilities to facilitate database operations such as getting database URLs or managing database files.


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

## License

SDUtil is released under the MIT license. See [LICENSE](LICENSE) for details.

## TODO: 
- [ ] Add delete item to unitTests and example code in the readme. Use Copilot to generate.
- [ ] Improve readme.md
- [ ] add doc in readme regarding insert order and metadata
