# SWXMLHash

SWXMLHash is a relatively simple way to parse XML in Swift. If you're familiar with `NSXMLParser`, this library is a simple wrapper around it. Conceptually, it provides a translation from XML to a dictionary of arrays (aka hash).

The API takes a lot of inspiration from [SwiftyJSON](https://github.com/lingoer/SwiftyJSON).

## Examples

All examples below can be found in the included specs.

### Initialization

```swift
// instantiate your SWXMLHash instance
let parser = SWXMLHash()

// begin parsing
let xml = parser.parse(xmlToParse)
```

### Single Element Lookup

```swift
xml["root"]["header"]["title"].element?.text
```

### Multiple Elements Lookup

```swift
xml["root"]["catalog"]["book"][1]["author"].element?.text
```

### Attributes Usage

```swift
xml["root"]["catalog"]["book"][1].element?.attributes["id"]
```

### Returning All Elements

```swift
", ".join(xml["root"]["catalog"]["book"].all.map { elem in elem["genre"].element!.text! })
```

### Error Handling

```swift
switch xml["root"]["what"]["header"]["foo"] {
case .Element(let elem):
  // everything is good, code away!
case .Error(let error):
  // error is an NSError instance that you can deal with
}
```

## Installation

Ultimately, this will be distributed with [CocoaPods](http://cocoapods.org/) support; however,  CocoaPods doesn't yet support Swift projects. In the meantime, just add SWXMLHash as a git submodule and drag `SWXMLHash.swift` into your project.

## TODO

* [x] finish implementing error handling for group indexing
* [x] add attribute support
* [ ] maybe add attribute look-up for elements as opposed to solely array indexing
* [ ] add CocoaPods support once it supports Swift projects
* [ ] more???
