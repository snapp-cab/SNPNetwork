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

class Tests: XCTestCase {
    
    var expectedString: String!
    let mockURL = "http://mockurl"
    
    struct MockModel: Codable {
        let mockData: String?
    }
    
    func testDownloadWasSuccessful() {
        
        class MockSNPNetwork: SNPNetwork {
            static var wasDownloadSuccessful = false
            override class func download(_ url: String,
                                         progress:((_ progress: Double) -> Void)?,
                                         completion: @escaping (_ status: String?) -> Void) {
                wasDownloadSuccessful = true
                completion("Downloading file was successful and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)")
            }
        }
        
        MockSNPNetwork.download(mockURL, progress: nil, completion: { (status) in
            self.expectedString = status!
        })
        
        XCTAssertTrue(MockSNPNetwork.wasDownloadSuccessful)
        XCTAssertEqual( expectedString, "Downloading file was successful and \'wasDownloadSuccessful\' flag is \(MockSNPNetwork.wasDownloadSuccessful)")
    }
    
    func testDownloadWasFailed() {
        
        class MockSNPNetwork: SNPNetwork {
            static var wasDownloadSuccessful = true
            override class func download(_ url: String,
                                         progress: ((_ progress: Double) -> Void)?,
                                         completion: @escaping (_ status: String?) -> Void) {
                wasDownloadSuccessful = false
                completion("Downloading file was failed and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)")
            }
        }
        
        MockSNPNetwork.download(mockURL, progress: nil, completion: { (status) in
            self.expectedString = status!
        })
        
        XCTAssertFalse(MockSNPNetwork.wasDownloadSuccessful)
        XCTAssertEqual(expectedString, "Downloading file was failed and \'wasDownloadSuccessful\' flag is \(MockSNPNetwork.wasDownloadSuccessful)")
    }
    
    func testRequestReturnsData() {
        
        class MockSNPNetwork: SNPNetwork {
            static let fakeResult = MockModel(mockData: "mockData")
            override class func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                                   method: HTTPMethod = .get,
                                                                   parameters: Parameters? = nil,
                                                                   encoding: ParameterEncoding = URLEncoding.default,
                                                                   headers: HTTPHeaders? = nil,
                                                                   responseKey: String? = nil,
                                                                   completion: @escaping (T?, E?) -> Void) {
                completion(fakeResult as? T, nil)
            }
        }
        
        MockSNPNetwork.request(url: mockURL,
                               method: .get,
                               parameters: nil,
                               encoding: URLEncoding.default,
                               headers: nil,
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
        
        class MockSNPNetwork: SNPNetwork {
            static let fakeError = SNPError(domain: "FakeDomain", code: 987, message: "this is fake message")
            override class func request<T: Decodable, E: SNPError>(url: URLConvertible,
                                                                   method: HTTPMethod = .get,
                                                                   parameters: Parameters? = nil,
                                                                   encoding: ParameterEncoding = URLEncoding.default,
                                                                   headers: HTTPHeaders? = nil,
                                                                   responseKey: String? = nil,
                                                                   completion: @escaping (T?, E?) -> Void) {
                completion(nil, fakeError as? E)
            }
        }
        
        MockSNPNetwork.request(url: mockURL,
                               method: .get,
                               parameters: nil,
                               encoding: URLEncoding.default,
                               headers: nil,
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
