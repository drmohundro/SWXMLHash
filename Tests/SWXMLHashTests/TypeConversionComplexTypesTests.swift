//
//  TypeConversionComplexTypesTests.swift
//  SWXMLHash
//
//  Copyright (c) 2016 David Mohundro. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import SWXMLHash
import Testing

struct TypeConversionComplexTypesTests {
    var parser: XMLIndexer?
    let xmlWithComplexType = """
        <root>
          <complexItem>
            <name>the name of complex item</name>
            <price>1024</price>
            <basicItems>
              <basicItem id="1234a">
                <name>item 1</name>
                <price>1</price>
              </basicItem>
              <basicItem id="1234a">
                <name>item 2</name>
                <price>2</price>
              </basicItem>
              <basicItem id="1234a">
                <name>item 3</name>
                <price>3</price>
              </basicItem>
            </basicItems>
            <attributeItems>
              <attributeItem name=\"attr1\" price=\"1.1\"/>
              <attributeItem name=\"attr2\" price=\"2.2\"/>
              <attributeItem name=\"attr3\" price=\"3.3\"/>
            </attributeItems>
          </complexItem>
          <empty></empty>
        </root>
    """

    let correctComplexItem = ComplexItem(
        name: "the name of complex item",
        priceOptional: 1_024,
        basics: [
            BasicItem(name: "item 1", price: 1, id: "1234a"),
            BasicItem(name: "item 2", price: 2, id: "1234b"),
            BasicItem(name: "item 3", price: 3, id: "1234c")
        ],
        attrs: [
            AttributeItem(name: "attr1", price: 1.1),
            AttributeItem(name: "attr2", price: 2.2),
            AttributeItem(name: "attr3", price: 3.3)
        ]
    )

    init() {
        parser = XMLHash.parse(xmlWithComplexType)
    }

    @Test
    func shouldConvertComplexItemToNonOptional() {
        do {
            let value: ComplexItem = try parser!["root"]["complexItem"].value()
            #expect(value == correctComplexItem)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldThrowWhenConvertingEmptyToNonOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["empty"].value() as ComplexItem)
        }
    }

    @Test
    func shouldThrowWhenConvertingMissingToNonOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["missing"].value() as ComplexItem)
        }
    }

    @Test
    func shouldConvertComplexItemToOptional() {
        do {
            let value: ComplexItem? = try parser!["root"]["complexItem"].value()
            #expect(value == correctComplexItem)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertEmptyToOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["empty"].value() as ComplexItem?)
        }
    }

    @Test
    func shouldConvertMissingToOptional() {
        do {
            let value: ComplexItem? = try parser!["root"]["missing"].value()
            #expect(value == nil)
        } catch {
            Issue.record("\(error)")
        }
    }
}

struct ComplexItem: XMLObjectDeserialization {
    let name: String
    let priceOptional: Double?
    let basics: [BasicItem]
    let attrs: [AttributeItem]

    static func deserialize(_ node: XMLIndexer) throws -> ComplexItem {
        try ComplexItem(
            name: node["name"].value(),
            priceOptional: node["price"].value(),
            basics: node["basicItems"]["basicItem"].value(),
            attrs: node["attributeItems"]["attributeItem"].value()
        )
    }
}

extension ComplexItem: Equatable {
    // swiftlint:disable:next identifier_name
    static func == (a: ComplexItem, b: ComplexItem) -> Bool {
        a.name == b.name && a.priceOptional == b.priceOptional && a.basics == b.basics && a.attrs == b.attrs
    }
}
