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
    // MARK: - Properties
    var expectedString: String!
    let mockURL = "http://mockurl"
    
    struct MockModel: Codable {
        let mockData: String?
    }
    // MARK: - Methods
    func makeRequest() -> SNPNetworkRequest<SNPError> {
        let params = ["key1": "value1", "key2": 10] as [String : Any]
        let headers = ["key1": "value1", "key2": "value2"]
        let completion: ((Data?, SNPError?) -> Void) = { _,_ in }
        return SNPNetworkRequest<SNPError>(url: "http://fakeurl.com", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, appendDefaultHeaders: false, responseKey: "", completion: completion)
    }
    
    // MARK: - Mock Objects
    
    // MARK: MockAuthenticationManager
    class MockAuthenticationManager: NSObject, SNPAuthenticationDelegate {
        static let shared = MockAuthenticationManager()
        private(set) var accessToken: String?
        private(set) var refreshToken: String?
        
        private override init() {
            super.init()
            MockSNPNetwork.shared.delegate = self
        }
        
        func refreshAccessToken(refreshToken: String, completion: @escaping (SNPError?) -> Void) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.accessToken = "FakeNewAccessToken"
                completion(nil)
            })
        }
        
        // SNPAuthenticationDelegate
        func refreshAccessToken(completion: @escaping (SNPError?) -> Void) {
            refreshAccessToken(refreshToken: "fakeRefreshToken") { (error) in
                if error != nil {
                    completion(error)
                } else {
                    completion(nil)
                }
            }
        }
        
        func adapt(requests: [SNPNetworkRequest<SNPError>]) -> [SNPNetworkRequest<SNPError>] {
            var requestArray = requests
            for i in 0..<requestArray.count {
                requestArray[i].headers!["Authorization"] = accessToken
            }
            return requestArray
        }
    }
    // MARK: MockSNPNetwork
    class MockSNPNetwork: SNPNetworkProtocol {
        static let shared = MockSNPNetwork()
        var queue = [SNPNetworkRequest]()
        var mustQueue = false
        var delegate: SNPAuthenticationDelegate?
        var statusCode: Int = 401
        
        init() {}
        
        func request<E: SNPError>(url: URLConvertible,
                                  method: HTTPMethod = .get,
                                  parameters: Parameters? = nil,
                                  encoding: ParameterEncoding = URLEncoding.default,
                                  headers: HTTPHeaders? = nil,
                                  appendDefaultHeaders: Bool = true,
                                  responseKey: String = "",
                                  completion: @escaping (Data?, E?) -> Void) {
            if mustQueue == true {
                let toBeQueuedRequest = SNPNetworkRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
                self.queue.append(toBeQueuedRequest as! SNPNetworkRequest<SNPError>)
                return
            }
            if statusCode == 401 {
                // we should start queueing the requests
                let toBeQueuedRequest = SNPNetworkRequest(url: url, method: method, parameters: parameters, encoding: encoding, headers: headers, appendDefaultHeaders: appendDefaultHeaders, responseKey: responseKey, completion: completion)
                self.queue.append(toBeQueuedRequest as! SNPNetworkRequest<SNPError>)
                self.delegate?.refreshAccessToken { error in
                    if error == nil {
                        // successfully refreshed access token
                        // adapt all requests
                        self.queue = self.delegate!.adapt(requests: self.queue)
                        // turn `mustQueue` flag off, because we have new valid access token
                        self.mustQueue = false
                        // now dequeue each request and make it call again.
                        for item in self.queue {
                            XCTAssertEqual(item.headers!["Authorization"], "FakeNewAccessToken")
                            self.statusCode = 200
                            self.request(url: item.url, method: item.method, parameters: item.parameters, encoding: item.encoding, headers: item.headers, appendDefaultHeaders: item.appendDefaultHeaders, responseKey: item.responseKey, completion: item.completion)
                            _ = self.queue.remove(at: 0)
                        }
                    } else {
                        // nothing we can do, we must show login page to user
                    }
                }
                self.mustQueue = true
            } else if statusCode == 200 {
                print("Request has done normaly.")
            }
        }
    }
    
    // MARK: - Tests
    func testDownloadWasSuccessful() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            var wasDownloadSuccessful = false
            func defaultDownload(_ url: String,
                                         progress:((_ progress: Double) -> Void)?,
                                         completion: @escaping (_ result: DownloadResult) -> Void) {

                wasDownloadSuccessful = true
                let resultString = "Downloading file was successful and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)"
                completion(.success(resultString))
            
                                         }
            func download(_ url: String,
                          progress:((_ progress: Double) -> Void)?,
                          completion: @escaping (_ result: DownloadResult) -> Void) {
                wasDownloadSuccessful = true
                let resultString = "Downloading file was successful and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)"
                completion(.success(resultString))
            }
        }
        
        MockSNPNetwork.shared.download(mockURL, progress: nil, completion: { (result) in
            self.expectedString = result.get()!
        })
        
        XCTAssertTrue(MockSNPNetwork.shared.wasDownloadSuccessful)
        XCTAssertEqual(expectedString, "Downloading file was successful and \'wasDownloadSuccessful\' flag is \(MockSNPNetwork.shared.wasDownloadSuccessful)")
    }
    
    func testDownloadWasFailed() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            var wasDownloadSuccessful = true
            func defaultDownload(_ url: String,
                                         progress: ((_ progress: Double) -> Void)?,
                                         completion: @escaping (_ result: DownloadResult) -> Void) {
                wasDownloadSuccessful = false
                let resultString = "Downloading file was failed and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)"
                completion(.failure(resultString))
            }
            func download(_ url: String,
                          progress: ((_ progress: Double) -> Void)?,
                          completion: @escaping (_ result: DownloadResult) -> Void) {
                wasDownloadSuccessful = false
                let resultString = "Downloading file was failed and \'wasDownloadSuccessful\' flag is \(wasDownloadSuccessful)"
                completion(.failure(resultString))
            }
        }
        
        MockSNPNetwork.shared.download(mockURL, progress: nil, completion: { (result) in
            self.expectedString = result.get()!
        })
        
        XCTAssertFalse(MockSNPNetwork.shared.wasDownloadSuccessful)
        XCTAssertEqual(expectedString, "Downloading file was failed and \'wasDownloadSuccessful\' flag is \(MockSNPNetwork.shared.wasDownloadSuccessful)")
    }
    
    func testRequestReturnsData() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            let fakeResult = MockModel(mockData: "mockData")
            func defaultRequest<T, E>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, appendDefaultHeaders: Bool, responseKey: String, completion: @escaping (T?, E?) -> Void) where T : Decodable, E : SNPError {
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
            
            func defaultRequest<T, E>(url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?, appendDefaultHeaders: Bool, responseKey: String, completion: @escaping (T?, E?) -> Void) where T : Decodable, E : SNPError {
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
    
    func testAddRequestsToQueueWhenMustQueueEnabled401Occured() {
        // This call cause to initiate `SNPAuthenticationDelegate`.
        _ = MockAuthenticationManager.shared.accessToken
        // We supose that `accessToken` has exprired, and this request encounters 401 status code.
        MockSNPNetwork.shared.statusCode = 401
        
        let request1 = makeRequest()
        MockSNPNetwork.shared.request(url: request1.url, method: request1.method, parameters: request1.parameters, encoding: request1.encoding, headers: request1.headers, appendDefaultHeaders: request1.appendDefaultHeaders, responseKey: request1.responseKey, completion: request1.completion)
        let request2 = makeRequest()
        MockSNPNetwork.shared.request(url: request2.url, method: request2.method, parameters: request2.parameters, encoding: request2.encoding, headers: request2.headers, appendDefaultHeaders: request2.appendDefaultHeaders, responseKey: request2.responseKey, completion: request2.completion)
        let request3 = makeRequest()
        MockSNPNetwork.shared.request(url: request3.url, method: request3.method, parameters: request3.parameters, encoding: request3.encoding, headers: request3.headers, appendDefaultHeaders: request3.appendDefaultHeaders, responseKey: request3.responseKey, completion: request3.completion)
        let request4 = makeRequest()
        MockSNPNetwork.shared.request(url: request4.url, method: request4.method, parameters: request4.parameters, encoding: request4.encoding, headers: request4.headers, appendDefaultHeaders: request4.appendDefaultHeaders, responseKey: request4.responseKey, completion: request4.completion)
        
        XCTAssertEqual(MockSNPNetwork.shared.queue.count, 4)
    }
    func testDequeueRequestsWhenNewAccessTokenFetched() {
        class MockSNPNetwork: SNPNetworkProtocol {
            static let shared = MockSNPNetwork()
            var queue = [SNPNetworkRequest]()
            var mustQueue = true
            var delegate: SNPAuthenticationDelegate?
            
            func request<E: SNPError>(url: URLConvertible,
                                      method: HTTPMethod = .get,
                                      parameters: Parameters? = nil,
                                      encoding: ParameterEncoding = URLEncoding.default,
                                      headers: HTTPHeaders? = nil,
                                      appendDefaultHeaders: Bool = true,
                                      responseKey: String = "",
                                      completion: @escaping (Data?, E?) -> Void) {
                let params = ["key1": "value1", "key2": 10] as [String : Any]
                let headers = ["key1": "value1", "key2": "value2"]
                let completion: ((Data?, SNPError?) -> Void) = { _,_ in }
                let request = SNPNetworkRequest<SNPError>(url: "http://fakeurl.com", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, appendDefaultHeaders: false, responseKey: "", completion: completion)
                queue.append(request)
                queue.append(request)
                queue.append(request)
                for item in self.queue {
                    let url = try! item.url.asURL()
                    XCTAssertEqual(url, NSURL(string: "http://fakeurl.com")! as URL)
                    XCTAssertEqual(item.method, .post)
                    
                    let paramsValue1: String = item.parameters!["key1"] as! String
                    XCTAssertEqual(paramsValue1 , "value1")
                    
                    let paramsValue2: Int = item.parameters!["key2"] as! Int
                    XCTAssertEqual(paramsValue2 , 10)
                    
                    let headersValue1: String = item.headers!["key1"]!
                    XCTAssertEqual(headersValue1 , "value1")
                    
                    let headersValue2: String = item.headers!["key2"]!
                    XCTAssertEqual(headersValue2 , "value2")
                    
                    XCTAssertFalse(item.appendDefaultHeaders)
                    
                    XCTAssertNotNil(item.completion)
                    
                    _ = self.queue.remove(at: 0)
                }
            }
        }
        
        let request1 = makeRequest()
        MockSNPNetwork.shared.request(url: request1.url, method: request1.method, parameters: request1.parameters, encoding: request1.encoding, headers: request1.headers, appendDefaultHeaders: request1.appendDefaultHeaders, responseKey: request1.responseKey, completion: request1.completion)
        XCTAssertEqual(MockSNPNetwork.shared.queue.count, 0)
    }
    
    func testDequeueRequestsMakesQueueEmpty() {
        // This call cause to initiate `SNPAuthenticationDelegate`.
        _ = MockAuthenticationManager.shared.accessToken
        // We supose that `accessToken` has exprired, and this request encounters 401 status code.
        MockSNPNetwork.shared.statusCode = 401
        
        let request1 = makeRequest()
        MockSNPNetwork.shared.request(url: request1.url, method: request1.method, parameters: request1.parameters, encoding: request1.encoding, headers: request1.headers, appendDefaultHeaders: request1.appendDefaultHeaders, responseKey: request1.responseKey, completion: request1.completion)
        let request2 = makeRequest()
        MockSNPNetwork.shared.request(url: request2.url, method: request2.method, parameters: request2.parameters, encoding: request2.encoding, headers: request2.headers, appendDefaultHeaders: request2.appendDefaultHeaders, responseKey: request2.responseKey, completion: request2.completion)
        let request3 = makeRequest()
        MockSNPNetwork.shared.request(url: request3.url, method: request3.method, parameters: request3.parameters, encoding: request3.encoding, headers: request3.headers, appendDefaultHeaders: request3.appendDefaultHeaders, responseKey: request3.responseKey, completion: request3.completion)
        let request4 = makeRequest()
        MockSNPNetwork.shared.request(url: request4.url, method: request4.method, parameters: request4.parameters, encoding: request4.encoding, headers: request4.headers, appendDefaultHeaders: request4.appendDefaultHeaders, responseKey: request4.responseKey, completion: request4.completion)
        
        let delayExpectation = expectation(description: "Waiting for new access token to be fetched")
        
        // while refreshAccessToken request will returns new accessToken after 2 seconds, then after 2 seconds we are sure all requests will adopts and will dequeue.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            delayExpectation.fulfill()
        }
        // Wait for the expectation to be fulfilled, if it takes more than
        // 3 seconds, throw an error
        waitForExpectations(timeout: 3)
        // Now then we have valid access token and any new request must be get statusCode = 200, which means that `queue` is empty and `mustQueue = false`.
        XCTAssertFalse(MockSNPNetwork.shared.mustQueue)
        XCTAssertEqual(MockSNPNetwork.shared.queue.count, 0)
    }
    
    func testNewAccessTokenFetchedSuccessfuly() {
        // This call cause to initiate `SNPAuthenticationDelegate`.
        _ = MockAuthenticationManager.shared.accessToken
        // We supose that `accessToken` has exprired, and this request encounters 401 status code.
        MockSNPNetwork.shared.statusCode = 401
        
        let request1 = makeRequest()
        MockSNPNetwork.shared.request(url: request1.url, method: request1.method, parameters: request1.parameters, encoding: request1.encoding, headers: request1.headers, appendDefaultHeaders: request1.appendDefaultHeaders, responseKey: request1.responseKey, completion: request1.completion)
        let request2 = makeRequest()
        MockSNPNetwork.shared.request(url: request2.url, method: request2.method, parameters: request2.parameters, encoding: request2.encoding, headers: request2.headers, appendDefaultHeaders: request2.appendDefaultHeaders, responseKey: request2.responseKey, completion: request2.completion)
        let request3 = makeRequest()
        MockSNPNetwork.shared.request(url: request3.url, method: request3.method, parameters: request3.parameters, encoding: request3.encoding, headers: request3.headers, appendDefaultHeaders: request3.appendDefaultHeaders, responseKey: request3.responseKey, completion: request3.completion)
        
        XCTAssertTrue(MockSNPNetwork.shared.mustQueue)
        XCTAssertEqual(MockSNPNetwork.shared.queue.count, 3)
        
        let request4 = makeRequest()
        MockSNPNetwork.shared.request(url: request4.url, method: request4.method, parameters: request4.parameters, encoding: request4.encoding, headers: request4.headers, appendDefaultHeaders: request4.appendDefaultHeaders, responseKey: request4.responseKey, completion: request4.completion)
        
        let delayExpectation = expectation(description: "Waiting for new access token to be fetched")
        
        // while refreshAccessToken request will returns new accessToken after 2 seconds, then after 2 seconds we are sure all requests will adopts and will dequeue.
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            delayExpectation.fulfill()
        }
        // Wait for the expectation to be fulfilled, if it takes more than
        // 3 seconds, throw an error
        waitForExpectations(timeout: 3)
        
        // Now then we have valid access token and any new request must be get statusCode = 200, which means that `queue` is empty and `mustQueue = false`.
        let request5 = self.makeRequest()
        MockSNPNetwork.shared.request(url: request5.url, method: request5.method, parameters: request5.parameters, encoding: request5.encoding, headers: request5.headers, appendDefaultHeaders: request5.appendDefaultHeaders, responseKey: request5.responseKey, completion: request5.completion)
        XCTAssertFalse(MockSNPNetwork.shared.mustQueue)
        XCTAssertEqual(MockSNPNetwork.shared.queue.count, 0)
    }
  
}
