import Foundation

import Alamofire

//public class SNPRequest: DataRequest {
//    var canBeQueued = true
//    
//    convenience init(request: DataRequest?, canBeQueued: Bool = true) {
//        
//    }
//    
//    convenience init(
//}


//public func request(
//    _ url: URLConvertible,
//    method: HTTPMethod = .get,
//    parameters: Parameters? = nil,
//    encoding: ParameterEncoding = URLEncoding.default,
//    headers: HTTPHeaders? = nil,
//    canBeQueued: Bool = true)
//    -> DataRequest {
//        
//        let alamofireRequest = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
//        let 
//}

public class SNPNetwork {
    
//    private struct RequestData {
//        var url: 
//    }
    
    // MARK: - Properties
    static let shared = SNPNetwork()
    
    var queue = [Request]()
    var authorized = false {
        didSet {
            if authorized {
                for request in queue {
//                    request.res
                }
            }
        }
    }
    
    // MARK: - Methods
    private init() {}
    
    func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, canBeQueued: Bool = true, completion: @escaping (HTTPURLResponse?) -> Void) {
        
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
        
        if authorized {
            request.response { response in
                completion(response.response)
            }
        } else if canBeQueued {
            queue.append(request)
        }
    }
}

//class Ride {
//}
//
//class DataAccess {
//    func getRide(completion: @escaping (Ride?, Error?) -> Void) {
//        
//        
//        
//        let request = SNPNetwork.request(url: "", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, canBeQueued: true)
//        request.request?.validate()
//        
//        
//        
//        request.request?.responseJSON { response in
//            if response.result.isSuccess {
//                completion(response as! Ride, nil)
//            } else {
//                completion(nil, response.error)
//            }
//        }
//    }
//}

