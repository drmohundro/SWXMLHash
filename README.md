# SWXMLHash

[![Join the chat at https://gitter.im/drmohundro/SWXMLHash](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/drmohundro/SWXMLHash?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

SWXMLHash is a relatively simple way to parse XML in Swift. If you're familiar with `NSXMLParser`, this library is a simple wrapper around it. Conceptually, it provides a translation from XML to a dictionary of arrays (aka hash).

The API takes a lot of inspiration from [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON).

## Contents

* [Installation](#installation)
* [Getting Started](#getting-started)
* [Examples](#examples)
* [Changelog](#changelog)
* [Contributing](#contributing)
* [License](#license)

## Installation

SWXMLHash can be installed using [CocoaPods](http://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage), or manually.

### CocoaPods

To install CocoaPods, run:

```bash
$ gem install cocoapods
```

Then create a `Podfile` with the following contents:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

pod 'SWXMLHash', '~> 1.0.0'
```

Finally, run the following command to install it:

```bash
$ pod install
```

### Carthage

To install Carthage, run (using Homebrew):

```bash
$ brew update
$ brew install carthage
```

Then add the following line to your `Cartfile`:

```
github "drmohundro/SWXMLHash" ~> 1.0
```

### Manual Installation

To install manually, you'll need to clone the SWXMLHash repository. You can do this in a separate directory or you can make use of git submodules - in this case, git submodules are recommended so that your repository has details about which commit of SWXMLHash you're using. Once this is done, you can just drop the `SWXMLHash.swift` file into your project.

## Getting Started

If you're just getting started with SWXMLHash, I'd recommend cloning the repository down and opening the workspace. I've included a Swift playground in the workspace which makes it *very* easy to experiment with the API and the calls.

<img src="https://raw.githubusercontent.com/drmohundro/SWXMLHash/assets/swift-playground@2x.png" width="600" alt="Swift Playground" />

## Examples

All examples below can be found in the included specs.

### Initialization

```swift
let xml = SWXMLHash.parse(xmlToParse)
```

Alternatively, for lazy parsing support, you call `lazy` instead of `parse`. Lazy loading avoids loading the entire XML document into memory, so it could be preferable for performance reasons. See the error handling for one caveat regarding lazy loading.

```swift
let xml = SWXMLHash.lazy(xmlToParse)
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
    <book id="1"><author>Bob</author></book>
    <book id="123"><author>John</author></book>
    <book id="456"><author>Mark</author></book>
  </catalog>
  ...
</root>
```

The below will return "123".

```swift
xml["root"]["catalog"]["book"][1].element?.attributes["id"]
```

Alternatively, you can look up an element with specific attributes. The below will return "John".

```swift
xml["root"]["catalog"]["book"].withAttr("id", "123")["author"].element?.text
```

### Returning All Elements At Current Level

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

### Returning All Child Elements At Current Level

Given:

```xml
<root>
  <catalog>
    <book>
      <genre>Fiction</genre>
      <title>Book</title>
      <date>1/1/2015</date>
    </book>
  </catalog>
</root>
```

The below will `NSLog` "root", "catalog", "book", "genre", "title", and "date" (note the `children` method).

```swift
func enumerate(indexer: XMLIndexer) {
  for child in indexer.children {
    NSLog(child.element!.name)
    enumerate(child)
  }
}

enumerate(xml)
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

Note that error handling as show above will not work with lazy loaded XML. The lazy parsing doesn't actually occur until the `element` or `all` method are called - as a result, there isn't any way to know prior to asking for an element if it exists or not.

## Changelog

See [CHANGELOG](CHANGELOG.md) for a list of all changes and their corresponding versions.

## Contributing

This framework uses [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) for its tests. To get these dependencies, you'll need to have [Carthage](https://github.com/Carthage/Carthage) installed. Once it is installed, you should be able to just run `carthage update`.

To run the tests, you can either run them from within Xcode or you can run `rake test`.

## License

SWXMLHash is released under the MIT license. See [LICENSE](LICENSE) for details.
