    import Foundation
    import Alamofire
    import AlamofireObjectMapper
    
    public func request(url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: [String:String]? = nil) ->SNPNetworkRequest {
        var header:[String:String]?
        if let overridenHeaders = headers {
            header = overridenHeaders
        }else if let configHeader = SNPNetworkRequest.config?.defaultHeaders{
            header = configHeader
        }
        
        let request = Alamofire.request(url, method: method, parameters: parameters, encoding: encoding, headers: header)
        let SNPRequest:SNPNetworkRequest = SNPNetworkRequest(alamofireRequest: request, urlRequest: request.request!)
        return SNPRequest;
    }
    
 

