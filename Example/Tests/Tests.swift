//
//  SNPNetworkTests.swift
//  SnappTests
//
//  Created by Arash Z.Jahangiri on 4/3/18.
//  Copyright © 2018 Snapp. All rights reserved.
//

import XCTest
@testable import SNPNetwork
import Alamofire
@testable import SNPUtilities

class Tests: XCTestCase {
    
    var expectedString: String!
    let mockURL = "http://mockurl"
    
    struct MockModel: Codable {
        let mockData: String?
    }
    
    func testDownloadWasSuccessful() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            var wasDownloadSuccessful = false
            func download(_ url: String,
                                         progress:((_ progress: Double) -> Void)?,
                                         completion: @escaping (_ status: String?) -> Void) {
                wasDownloadSuccessful = true
                completion("Downloading file was successful and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)")
            }
        }
        
        MockSNPNetwork.shared.download(mockURL, progress: nil, completion: { (status) in
            self.expectedString = status!
        })
        
        XCTAssertTrue(MockSNPNetwork.shared.wasDownloadSuccessful)
        XCTAssertEqual( expectedString, "Downloading file was successful and \'wasDownloadSuccessful\' flag is \(MockSNPNetwork.shared.wasDownloadSuccessful)")
    }
    
    func testDownloadWasFailed() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            var wasDownloadSuccessful = true
            func download(_ url: String,
                                         progress: ((_ progress: Double) -> Void)?,
                                         completion: @escaping (_ status: String?) -> Void) {
                wasDownloadSuccessful = false
                completion("Downloading file was failed and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)")
            }
        }
        
        MockSNPNetwork.shared.download(mockURL, progress: nil, completion: { (status) in
            self.expectedString = status!
        })
        
        XCTAssertFalse(MockSNPNetwork.shared.wasDownloadSuccessful)
        XCTAssertEqual(expectedString, "Downloading file was failed and \'wasDownloadSuccessful\' flag is \(MockSNPNetwork.shared.wasDownloadSuccessful)")
    }
    
    func testRequestReturnsData() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            let fakeResult = MockModel(mockData: "mockData")
            func request<T, E>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, appendDefaultHeaders: Bool, responseKey: String, completion: @escaping (T?, E?) -> Void) where T : Decodable, E : SNPError {
                completion(fakeResult as? T, nil)
            }
        }
        
        MockSNPNetwork.shared.request(url: mockURL,
                               method: .get,
                               parameters: nil,
                               encoding: URLEncoding.default,
                               headers: nil, appendDefaultHeaders: false,
                               responseKey: "") { (model: MockModel?, error: SNPError?) in
                                guard let aModel = model else {
                                    XCTFail("Model should not be nil")
                                    print(error!)
                                    return
                                }
                                XCTAssertNotNil(aModel)
                                self.expectedString = "mockData"
                                XCTAssertEqual(self.expectedString, aModel.mockData!)
        }
    }
    
    func testRequestReturnsNil() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            let fakeError = SNPError(domain: "FakeDomain", code: 987, message: "this is fake message")
            
            func request<T, E>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, appendDefaultHeaders: Bool, responseKey: String, completion: @escaping (T?, E?) -> Void) where T : Decodable, E : SNPError {
                completion(nil, fakeError as? E)
            }
        }
        
        MockSNPNetwork.shared.request(url: mockURL,
                               method: .get,
                               parameters: nil,
                               encoding: URLEncoding.default,
                               headers: nil, appendDefaultHeaders: false,
                               responseKey: "") { (model: MockModel?, error: SNPError?) in
                                guard let anError = error else {
                                    XCTFail("Error should not be nil")
                                    print(model!)
                                    return
                                }
                                XCTAssertNotNil(anError)
                                self.expectedString = "this is fake message"
                                XCTAssertEqual(self.expectedString, anError.message)
                                
        }
    }
}
