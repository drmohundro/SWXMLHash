# SWXMLHash

SWXMLHash is a relatively simple way to parse XML in Swift. If you're familiar with `NSXMLParser`, this library is a simple wrapper around it. Conceptually, it provides a translation from XML to a dictionary of arrays (aka hash).

The API takes a lot of inspiration from [SwiftyJSON](https://github.com/lingoer/SwiftyJSON).

## Installation

Ultimately, this will be distributed with [CocoaPods](http://cocoapods.org/) support; however,  CocoaPods doesn't yet support Swift projects. In the meantime, just add SWXMLHash as a git submodule and drag `SWXMLHash.swift` into your project.

## Examples

All examples below can be found in the included specs.

### Initialization

```swift
let xml = SWXMLHash.parse(xmlToParse)
```

### Single Element Lookup

Given:

```xml
<root>
  <header>
    <title>Foo</title>
  </header>
  ...
</root>
```

Will return "Foo".

```swift
xml["root"]["header"]["title"].element?.text
```

### Multiple Elements Lookup

Given:

```xml
<root>
  ...
  <catalog>
    <book><author>Bob</author></book>
    <book><author>John</author></book>
    <book><author>Mark</author></book>
  </catalog>
  ...
</root>
```

The below will return "John".

```swift
xml["root"]["catalog"]["book"][1]["author"].element?.text
```

### Attributes Usage

Given:

```xml
<root>
  ...
  <catalog>
    <book><author id="1">Bob</author></book>
    <book><author id="123">John</author></book>
    <book><author id="456">Mark</author></book>
  </catalog>
  ...
</root>
```

The below will return "123".

```swift
xml["root"]["catalog"]["book"][1].element?.attributes["id"]
```

### Returning All Elements

Given:

```xml
<root>
  ...
  <catalog>
    <book><genre>Fiction</genre></book>
    <book><genre>Non-fiction</genre></book>
    <book><genre>Technical</genre></book>
  </catalog>
  ...
</root>
```

The below will return "Fiction, Non-fiction, Technical" (note the `all` method).

```swift
", ".join(xml["root"]["catalog"]["book"].all.map { elem in
  elem["genre"].element!.text!
})
```

Alternatively, you can just iterate over the elements using `for-in` directly against an element.

```swift
for elem in xml["root"]["catalog"]["book"] {
  NSLog(elem["genre"].element!.text!)
}
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

## TODO

* [x] finish implementing error handling for group indexing
* [x] add attribute support
* [ ] maybe add attribute look-up for elements as opposed to solely array indexing
* [ ] add CocoaPods support once it supports Swift projects
* [ ] more???

## License

SWXMLHash is released under the MIT license. See [LICENSE](LICENSE) for details.
