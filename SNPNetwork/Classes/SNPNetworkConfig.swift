//
//  SNPNetworkConfig.swift
//  Alamofire
//
//  Created by Nader Rashed on 10/8/17.
//

public struct SNPNetworkConfig {
    public var defaultHeaders:[String: String]!
    public var baseURL:String!
    
    public init(defaultHeader: [String:String]! = nil , baseURL:String! = nil){
        self.defaultHeaders = defaultHeader
        self.baseURL = baseURL
    }
}

