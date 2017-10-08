    import Foundation
    import Alamofire
    
    public class SNPNetwork {
        // MARK: - Properties
        static let shared = SNPNetwork()
        // MARK: - Methods
        private init() {}
        
     
    }
    public func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil) ->SNPNetworkRequest {
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).validate()
        let SNPRequest:SNPNetworkRequest = SNPNetworkRequest(alamofireRequest: request, urlRequest: request.request!)
        return SNPRequest;
    }
