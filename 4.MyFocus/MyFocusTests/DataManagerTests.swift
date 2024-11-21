import XCTest
import CoreData
@testable import MyFocus

class DataManagerTests: XCTestCase {
    var dataManager: DataManager!

    override func setUp() {
        super.setUp()
        dataManager = DataManager.shared
    }

    override func tearDown() {
        dataManager = nil
        super.tearDown()
    }

    func testCoreDataInitialization() {
        XCTAssertNotNil(dataManager.container)
        XCTAssertTrue(dataManager.container.persistentStoreDescriptions.count > 0)
    }

    func testNetworkManagerInitialization() {
        XCTAssertNotNil(dataManager.networkManager)
    }

    func testCoreDataLoadStores() {
        let expectation = self.expectation(description: "CoreData stores should load successfully")

        // Создание in-memory хранилища для тестов
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.url = URL(fileURLWithPath: "/dev/null")
        dataManager.container.persistentStoreDescriptions = [description]

        dataManager.container.loadPersistentStores { _, error in
            XCTAssertNil(error, "Core Data failed to load stores")
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
}
