# SNPUtilities

[![CI Status](http://img.shields.io/travis/arashzjahangiri@gmail.com/SNPUtilities.svg?style=flat)](https://travis-ci.org/arashzjahangiri@gmail.com/SNPUtilities)
[![Version](https://img.shields.io/cocoapods/v/SNPUtilities.svg?style=flat)](http://cocoapods.org/pods/SNPUtilities)
[![License](https://img.shields.io/cocoapods/l/SNPUtilities.svg?style=flat)](http://cocoapods.org/pods/SNPUtilities)
[![Platform](https://img.shields.io/cocoapods/p/SNPUtilities.svg?style=flat)](http://cocoapods.org/pods/SNPUtilities)

SNPUtilities is a Swift-based helper library for iOS. Our plan is to add any helper function, class, Extension in this repo. Current version contains: <br/>
1. File manager related tasks such as clear temp files.<br/>
2. SNPError, a custom error maker we need in our application, Snapp. This SNPError is used in API callbacks or as input parameter type in a function.<br/>
3. SNPDecodable. <br/>
4. Extension to Bundle.<br/>
5. Extension to Dictionary.<br/>
6. Extension to Int.<br/>
7. Extension to UIDevice.<br/>
8. Category for UIImage(Objective-C).<br/>
9. Keychain wrapper.<br/>
10. Extension to NSString.<br/>
11. Extension to UIViewController.<br/>
12. Extention to String for converting digits to persian.<br/>
13. Extention to String for handling price format numbers.<br/>
## Getting Started

1. Add a Podfile. In the terminal, navigate to your Xcode project directory. Create a Podfile by running the following command.
```ruby
$ pod init
```
2. Edit your Podfile. Add the following in your Podfile under your project's target.
```ruby
target 'YourAppTarget' do
platform :ios, '9.0'
pod 'SNPUtilities'
end
```
3. Install SNPUtilities. Navigate to your Xcode project directory and run the following command.
```ruby
$ pod install
```

## Author

Arash Z. Jahangiri, arash.jahangiri@snapp.cab

## Questions<br/>
If you have any questions about the project, please contact via email: arash.jahangiri@snapp.cab

Pull requests are welcome!

## License

SNPUtilities is available under the MIT license. See the LICENSE file for more info.
