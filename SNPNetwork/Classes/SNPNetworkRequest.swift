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
                public static var config:SNPNetworkConfig?
                
                public func response (completionHandler: @escaping (SNPDefaultDataResponse) -> Void) -> Self{
                    alamofireRequest!.response { response in
                        let snpresponse = SNPDefaultDataResponse(request: response.request, response: response.response, data: response.data)
                        completionHandler(snpresponse)
                    }
                    return self
                }
                
                public func responseJSON(
                    options: JSONSerialization.ReadingOptions = .allowFragments,
                    completionHandler: @escaping (SNPDataResponse<Any>) -> Void)
                    -> Self
                {
                    
                    alamofireRequest!.responseJSON { response in
                        let result:SNPNetworkResult = SNPNetworkResult(alamofireEnum: response.result)
                        let SNPResponse = SNPDataResponse(request: response.request, response: response.response, data: response.data , result: result )
                        completionHandler(SNPResponse)
                    }
                    
                    return self;
                }
                
                public func responseString(
                    options: JSONSerialization.ReadingOptions = .allowFragments,
                    completionHandler: @escaping (SNPDataResponse<String>) -> Void)
                    -> Self
                {
                    
                    alamofireRequest!.responseString { response in
                        let result:SNPNetworkResult = SNPNetworkResult(alamofireEnum: response.result)
                        let SNPResponse = SNPDataResponse(request: response.request, response: response.response, data: response.data , result: result )
                        completionHandler(SNPResponse)
                    }
                    
                    return self;
                }
                
                public func responseData(
                    options: JSONSerialization.ReadingOptions = .allowFragments,
                    completionHandler: @escaping (SNPDataResponse<Data>) -> Void)
                    -> Self
                {
                    
                    alamofireRequest!.responseData { response in
                        let result:SNPNetworkResult = SNPNetworkResult(alamofireEnum: response.result)
                        let SNPResponse = SNPDataResponse(request: response.request, response: response.response, data: response.data , result: result )
                        completionHandler(SNPResponse)
                    }
                    
                    return self;
                }
                
                
            }
