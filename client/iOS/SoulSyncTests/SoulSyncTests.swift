//
//  SoulSyncTests.swift
//  SoulSyncTests
//
//  Created by Hanna Skairipa on 12/30/23.
//

import XCTest
@testable import SoulSync

final class SoulSyncTests: XCTestCase {
    func testAPI() {
            // Define the expectation
            let expectation = self.expectation(description: "GET request should succeed and return valid JSON")

        NetworkManager.shared.get(to: URL(string: apiURL)!) { data, response, error in
                // Handle error
                if let error = error {
                    XCTFail("Error making GET request: \(error.localizedDescription)")
                    expectation.fulfill()  // fulfill the expectation to complete the test
                    return
                }
                
                // Check the response
                if let httpResponse = response as? HTTPURLResponse {
                    switch httpResponse.statusCode {
                    case 200:
                        // Success
                        if let data = data {
                            do {
                                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                                XCTAssertNotNil(jsonObject, "Response JSON should not be nil")
                            } catch {
                                XCTFail("Error parsing JSON: \(error.localizedDescription)")
                            }
                        } else {
                            XCTFail("No data received")
                        }
                    case 400...499:
                        XCTFail("Client error, status code: \(httpResponse.statusCode)")
                    case 500...599:
                        XCTFail("Server error, status code: \(httpResponse.statusCode)")
                    default:
                        XCTFail("Unexpected status code: \(httpResponse.statusCode)")
                    }
                } else {
                    XCTFail("Invalid response received")
                }
                
                // Fulfill the expectation to indicate that the background task has finished successfully.
                expectation.fulfill()
            }
            
            // Wait until the expectation is fulfilled, with a timeout of 10 seconds.
            waitForExpectations(timeout: 10, handler: nil)
        }
}
