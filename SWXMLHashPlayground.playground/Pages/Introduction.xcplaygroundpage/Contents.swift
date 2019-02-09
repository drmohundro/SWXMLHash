// swiftlint:disable force_unwrapping
/*:

## SWXMLHash Playground

SWXMLHash is a relatively simple way to parse XML in Swift.

Feel free to play around here with the samples and try the library out.

### Simple example

*/
import Foundation
import SWXMLHash

let xmlWithNamespace = """
<root xmlns:h=\"http://www.w3.org/TR/html4/\"
xmlns:f=\"http://www.w3schools.com/furniture\">
  <h:table>
    <h:tr>
      <h:td>Apples</h:td>
      <h:td>Bananas</h:td>
    </h:tr>
  </h:table>
  <f:table>
    <f:name>African Coffee Table</f:name>
    <f:width>80</f:width>
    <f:length>120</f:length>
  </f:table>
</root>
"""

var xml = SWXMLHash.parse(xmlWithNamespace)

// one root element
let count = xml["root"].all.count

// "Apples"
xml["root"]["h:table"]["h:tr"]["h:td"][0].element!.text

// enumerate all child elements (procedurally)
func enumerate(indexer: XMLIndexer, level: Int) {
    for child in indexer.children {
        let name = child.element!.name
        print("\(level) \(name)")

        enumerate(indexer: child, level: level + 1)
    }
}

enumerate(indexer: xml, level: 0)

// enumerate all child elements (functionally)
func reduceName(names: String, elem: XMLIndexer) -> String {
    return names + elem.element!.name + elem.children.reduce(", ", reduceName)
}

xml.children.reduce("elements: ", reduceName)

//: ### Custom Conversion/Deserialization

// custom types conversion
let booksXML = """
<root>
  <books>
    <book>
      <title>Book A</title>
      <price>12.5</price>
      <year>2015</year>
    </book>
    <book>
      <title>Book B</title>
      <price>10</price>
      <year>1988</year>
    </book>
    <book>
      <title>Book C</title>
      <price>8.33</price>
      <year>1990</year>
      <amount>10</amount>
    </book>
  <books>
</root>
"""

struct Book: XMLIndexerDeserializable {
    let title: String
    let price: Double
    let year: Int
    let amount: Int?

    static func deserialize(_ node: XMLIndexer) throws -> Book {
        return try Book(
            title: node["title"].value(),
            price: node["price"].value(),
            year: node["year"].value(),
            amount: node["amount"].value()
        )
    }
}

xml = SWXMLHash.parse(booksXML)

let books: [Book] = try xml["root"]["books"]["book"].value()
