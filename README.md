# SNPNetwork

[![CI Status](http://img.shields.io/travis/arashzjahangiri@gmail.com/SNPNetwork.svg?style=flat)](https://travis-ci.org/arashzjahangiri@gmail.com/SNPNetwork)
[![Version](https://img.shields.io/cocoapods/v/SNPNetwork.svg?style=flat)](http://cocoapods.org/pods/SNPNetwork)
[![License](https://img.shields.io/cocoapods/l/SNPNetwork.svg?style=flat)](http://cocoapods.org/pods/SNPNetwork)
[![Platform](https://img.shields.io/cocoapods/p/SNPNetwork.svg?style=flat)](http://cocoapods.org/pods/SNPNetwork)

SNPNetwork is a Swift-based HTTP networking library for iOS. It provides an interface on top of Alamofire that simplifies a number of common networking tasks. We've created it to add some features we needed in Snapp application which is not supported directly in Alamofire. For example it has a super-simplified JSON parsing facility that gives you clearer syntax by set it's 'responseKey' parameter. To modularize our architecture we release it as Pod file so that you can add it to your project. Let's see what's inside SNPNetwork and how you can use it. It also has another functionality for download tasks.

## Take a look inside!
Here we describe methods of SNPNetwork that do discussioned tasks. <br/>

0) Before you start to call APIs using 'requsest' function you can call below function to set all of your default headers, necessary headers, for all of your requests. One of best places to set default headers is in AppDelegate. <br/>
Parameters:<br/>
- headers: is a dictionary like this [String: String]<br/>

```ruby
class func setDefaultHeaders(headers: HTTPHeaders)
```

1) common networking tasks:

```ruby
class func request<T: Decodable, E: SNPError>(url: URLConvertible,
method: HTTPMethod = .get,
parameters: Parameters? = nil,
encoding: ParameterEncoding = URLEncoding.default,
headers: HTTPHeaders? = nil,
responseKey: String? = nil,
appendDefaultHeaders: Bool = true,
completion: @escaping (T?, E?) -> Void)
```
As you can see request is a generic function that returns expected model you want and also an error of type 'SNPError'. It is a class function which means that without making instance of SNPNetwork class you can use it anywhere.(SNPNetwork.request("www.test.com")) <br/>
Parameters:<br/>
- url: url of interest to retrieve data. It should be String<br/>
- method: is the type of request you look for and is an enumeration like this:

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

- parameters: is a dictionary like this [String: Any]<br/>
- headers: is a dictionary like this [String: String]<br/>
- appendDefaultHeaders is of type Bool. If you set default headers for request, this flag is responsible to append defaultHeader to 'headers' parameter by default, else(appendDefaultHeaders = false)  default headers will be replaced with 'headers' parameter.<br/>
- responseKey: is expected path of response and will be like "Data.Information.Employee.Person"<br/>

2) download tasks:

```ruby
class func download(_ url: String,
progress: ((_ progress: Double) -> Void)?,
completion: @escaping (_ status: String?) -> Void)
```
- url: url of interest to download data. It should be String<br/>
- progress: show progress of downloading file<br/>

As you can see download is a class function which means that without making instance of SNPNetwork class you can use it anywhere.(SNPNetwork.download("www.test.com"))

## Example usage:
0) set default headers:
```ruby
SNPNetwork.setDefaultHeaders(headers: ["iOS-Ver":"11.0"])
```
1) common networking tasks:
```ruby
SNPNetwork.request(url: "www.test.com",
method: .post,
parameters: parameters(),
encoding: JSONEncoding.default,
responseKey: "data") { (config: Config?, error: SNPError?) in
if error == nil {
self.config = config
} else {
print(error!)
}
}
```
--OR--

```ruby
SNPNetwork.request(url: "www.test.com") { (config: Config?, error: SNPError?) in
if error == nil {
self.config = config
} else {
print(error!)
}
}
```

2) download tasks:

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

## Getting Started

1.git clone https://github.com/snapp-cab/SNPNetwork.git<br/>
2.run pod install in the iOS project.<br />

```ruby
pod 'SNPNetwork'
```

## Author

Arash Z. Jahangiri, arash.jahangiri@snapp.cab

## Questions<br/>
If you have any questions about the project, please contact via email: arash.jahangiri@snapp.cab

Pull requests are welcome!

## License

SNPNetwork is available under the MIT license. See the LICENSE file for more info.
