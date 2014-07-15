# SWXMLHash

SWXMLHash is a relatively simple way to parse XML in Swift. If you're familiar with `NSXMLParser`, this library is a simple wrapper around it. Conceptually, it provides a translation from XML to a dictionary of arrays (aka hash).

The API takes a lot of inspiration from [SwiftyJSON](https://github.com/lingoer/SwiftyJSON).

## Examples

All examples below can be found in the included specs.

```swift
// instantiate your SWXMLHash instance
let parser = SWXMLHash()

// begin parsing
let xml = parser.parse(xmlToParse)

// will return "Test Title Header"
xml["root"]["header"]["title"].element?.text

// will return "Ralls, Kim"
xml["root"]["catalog"]["book"][1]["author"].element?.text

// will return "bk102"
xml["root"]["catalog"]["book"][1].element?.attributes["id"]

// will return "Computer, Fantasy, Fantasy"
", ".join(xml["root"]["catalog"]["book"].all.map { elem in elem["genre"].element!.text! })

// error handling
switch xml["root"]["what"]["header"]["foo"] {
case .Element(let elem):
  // everything is good, code away!
case .Error(let error):
  // error is an NSError instance that you can deal with
}
```

## Installation

My future plan is to add [CocoaPods](http://cocoapods.org/) support for this package; however, CocoaPods doesn't yet officially support Swift projects yet. Until that point, the best option would probably be to just drop the relevant source files directly into your project (all Swift files under the SWXMLHash directory).

## TODO

* [x] finish implementing error handling for group indexing
* [x] add attribute support
* [ ] maybe add attribute look-up for elements as opposed to solely array indexing
* [ ] add CocoaPods support once it supports Swift projects
* [ ] more???
