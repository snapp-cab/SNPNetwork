## SNPNetwork

[![CI Status](http://img.shields.io/travis/arashzjahangiri@gmail.com/SNPNetwork.svg?style=flat)](https://travis-ci.org/arashzjahangiri@gmail.com/SNPNetwork)
[![Version](https://img.shields.io/cocoapods/v/SNPNetwork.svg?style=flat)](http://cocoapods.org/pods/SNPNetwork)
[![License](https://img.shields.io/cocoapods/l/SNPNetwork.svg?style=flat)](http://cocoapods.org/pods/SNPNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SNPNetwork.svg?style=flat)](http://cocoapods.org/pods/SNPNetwork)

SNPNetwork is a Swift-based HTTP networking library for iOS. It provides an interface on top of Alamofire
that simplifies a number of common networking tasks. We've created it to add some features we needed in Snapp
application which is not supported directly in Alamofire. Another key feature is a super-simplified JSON parsing
facility that gives you clearer syntax by set it's 'responseKey' parameter.
<br />
## Getting Started

To run the SNPNetwork project, clone the repo, and run `pod install` from the SNPNetwork directory first.

## Installation

SNPNetwork is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SNPNetwork'
```
## Take a look inside!
Here we describe methods of SNPNetwork module. 
```ruby
class func request<T: Decodable, E: SNPError>(url: URLConvertible,
method: HTTPMethod = .get,
parameters: Parameters? = nil,
encoding: ParameterEncoding = URLEncoding.default,
headers: HTTPHeaders? = nil,
responseKey: String? = nil,
completion: @escaping (T?, E?) -> Void)
```
As you can see request is a generic function that returns expected model you want and also an error of type 'SNPError'. It is a class function which means that without making instance of SNPNetwork class you can use it anywhere.(SNPNetwork.request("www.test.com"))
Parameters:
url: url of interest to retrieve data. It should be String
method: is the type of request you look for and is an enumeration like this:
```ruby
public enum HTTPMethod: String {
case options = "OPTIONS"
case get     = "GET"
case head    = "HEAD"
case post    = "POST"
case put     = "PUT"
case patch   = "PATCH"
case delete  = "DELETE"
case trace   = "TRACE"
case connect = "CONNECT"
}
```
parameters: is a dictionary like this [String: Any]
headers: is a dictionary like this [String: String]
responseKey: is expected path of response and will be like "Data.Information.Employee.Person"

Example usage:
```ruby
SNPNetwork.request(url: "www.test.com",
method: .post,
parameters: parameters(),
encoding: JSONEncoding.default,
responseKey: "data") { (config: Config?, error: SNPError?) in
if error == nil {
self.config = config
if self.config?.waitingGif != nil {
//do something                                    
}
} else {
completion(error!)
}
```
--OR--
```ruby
SNPNetwork.request(url: "www.test.com") { (config: Config?, error: SNPError?) in
if error == nil {
self.config = config
if self.config?.waitingGif != nil {
//do something
}
} else {
completion(error!)
}
}
```
```ruby
class func download(_ url: String,
progress: ((_ progress: Double) -> Void)?,
completion: @escaping (_ status: String?) -> Void)
```
url: url of interest to retrieve data. It should be String
progress: show progress of downloading file
As you can see download is a class function which means that without making instance of SNPNetwork class you can use it anywhere.(SNPNetwork.download("www.test.com"))

Example usage:
```ruby
SNPNetwork.download("www.test.com", progress: {(progress) in
print(progress)
}, completion: {(status) in
print(status!)
})
```
--OR--
```ruby
SNPNetwork.download("www.test.com", progress: nil, completion: {(status) in
print(status!)
})
```
## Author
Arash Z. Jahangiri, arashzjahangiri@gmail.com

## License

SNPNetwork is available under the MIT license. See the LICENSE file for more info.
<br />
## Questions<br/>
If you have any questions about the project, please contact via email: arashzjahangiri@gmail.com

Pull requests are welcome!
