//
//  WebAPITests.swift
//  WebAPITests
//
//  Created by 劉柏賢 on 2021/8/11.
//

import XCTest
@testable import WebAPI

class WebAPITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testGetZooWebAPI() {

        let webAPI = SearchUsersWebAPI()
        let expect = expectation(description: "Get \(webAPI.urlString)")
        
        let parameter = SearchUsersParameter(q: "bosian")
        
        webAPI.invokeAsync(parameter).done { model in
            
            XCTAssertTrue(model.isSuccess)
            XCTAssertTrue(!model.items.isEmpty)
            
            for item in model.items {
                XCTAssertTrue(!item.avatarUrl.isEmpty)
                XCTAssertTrue(!item.login.isEmpty)
            }
            
            expect.fulfill()
            
        }.catch { error in
            print(error)
            expect.fulfill()
            XCTFail("\(error)")
        }
        
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func testGetZooWebAPIForPagination() {

        let webAPI = SearchUsersWebAPI()
        let expect = expectation(description: "Get \(webAPI.urlString)")
        
        let parameter = SearchUsersParameter(perPage: 2, page: 1, q: "bosian")
        
        webAPI.invokeAsync(parameter).done { model in
            
            XCTAssertTrue(model.isSuccess)
            XCTAssertTrue(!model.items.isEmpty)
            
            for item in model.items {
                XCTAssertTrue(!item.avatarUrl.isEmpty)
                XCTAssertTrue(!item.login.isEmpty)
            }
            
            expect.fulfill()
            
        }.catch { error in
            print(error)
            expect.fulfill()
            XCTFail("\(error)")
        }
        
        waitForExpectations(timeout: 60) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
