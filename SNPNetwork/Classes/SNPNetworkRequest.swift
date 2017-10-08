			//
//  SNPNetworkRequest.swift
//  Alamofire
//
//  Created by Nader Rashed on 10/2/17.
//
 import Alamofire
            
public class SNPNetworkRequest{
    init(alamofireRequest:DataRequest , urlRequest:URLRequest  ) {
        self.alamofireRequest = alamofireRequest
        self.request = urlRequest
    }
    
    public let request: URLRequest?
    public var error: Error?
    private let alamofireRequest: DataRequest?
    
    
    public func responseJSON(
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completionHandler: @escaping (SNPDataResponse) -> Void)
        -> Self
    {
        alamofireRequest!.responseJSON { response in
            let SNPResponse = SNPDataResponse(request: response.request, response: response.response, data: response.data);
            completionHandler(SNPResponse)
        }
        return self;
    }
    
    
}
