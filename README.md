# SWXMLHash

SWXMLHash is a relatively simple way to parse XML in Swift. If you're familiar with `NSXMLParser`, this library is a simple wrapper around it. Conceptually, it provides a translation from XML to a dictionary of arrays (aka hash).

## Examples

All examples below are from the included specs.

```swift
// given the following XML
let xmlToParse = "<root><header><title>Test Title Header</title></header><catalog><book id=\"bk101\"><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book><book id=\"bk102\"><author>Ralls, Kim</author><title>Midnight Rain</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-12-16</publish_date><description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description></book><book id=\"bk103\"><author>Corets, Eva</author><title>Maeve Ascendant</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-11-17</publish_date><description>After the collapse of a nanotechnology society in England, the young survivors lay the foundation for a new society.</description></book></catalog></root>"
    
// will return "Test Title Header"
xml["root"]["header"]["title"].text

// will return "Ralls, Kim"
xml["root"]["catalog"].group("book")[1]["author"].text

// will return "Computer, Fantasy, Fantasy"
", ".join(xml["root"]["catalog"].group("book").map { elem in elem["genre"].text! })
```

## TODO

* [ ] finish implementing error handling for group indexing
* [ ] add attribute support
* [ ] more???
