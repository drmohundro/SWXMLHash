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
import XCTest

// swiftlint:disable identifier_name

class TypeConversionComplexTypesTests: XCTestCase {
    var parser: XMLIndexer?
    let xmlWithComplexType = """
        <root>
          <complexItem>
            <name>the name of complex item</name>
            <price>1024</price>
            <basicItems>
              <basicItem>
                <name>item 1</name>
                <price>1</price>
              </basicItem>
              <basicItem>
                <name>item 2</name>
                <price>2</price>
              </basicItem>
              <basicItem>
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
            BasicItem(name: "item 1", price: 1),
            BasicItem(name: "item 2", price: 2),
            BasicItem(name: "item 3", price: 3)
        ],
        attrs: [
            AttributeItem(name: "attr1", price: 1.1),
            AttributeItem(name: "attr2", price: 2.2),
            AttributeItem(name: "attr3", price: 3.3)
        ]
    )

    override func setUp() {
        parser = SWXMLHash.parse(xmlWithComplexType)
    }

    func testShouldConvertComplexitemToNonOptional() {
        do {
            let value: ComplexItem = try parser!["root"]["complexItem"].value()
            XCTAssertEqual(value, correctComplexItem)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as ComplexItem)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as ComplexItem)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldConvertComplexitemToOptional() {
        do {
            let value: ComplexItem? = try parser!["root"]["complexItem"].value()
            XCTAssertEqual(value, correctComplexItem)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as ComplexItem?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldConvertMissingToOptional() {
        do {
            let value: ComplexItem? = try parser!["root"]["missing"].value()
            XCTAssertNil(value)
        } catch {
            XCTFail("\(error)")
        }
    }
}

struct ComplexItem: XMLIndexerDeserializable {
    let name: String
    let priceOptional: Double?
    let basics: [BasicItem]
    let attrs: [AttributeItem]

    static func deserialize(_ node: XMLIndexer) throws -> ComplexItem {
        return try ComplexItem(
            name: node["name"].value(),
            priceOptional: node["price"].value(),
            basics: node["basicItems"]["basicItem"].value(),
            attrs: node["attributeItems"]["attributeItem"].value()
        )
    }
}

extension ComplexItem: Equatable {}

func == (a: ComplexItem, b: ComplexItem) -> Bool {
    return a.name == b.name && a.priceOptional == b.priceOptional && a.basics == b.basics && a.attrs == b.attrs
}

extension TypeConversionComplexTypesTests {
    static var allTests: [(String, (TypeConversionComplexTypesTests) -> () throws -> Void)] {
        return [
            ("testShouldConvertComplexitemToNonOptional", testShouldConvertComplexitemToNonOptional),
            ("testShouldThrowWhenConvertingEmptyToNonOptional", testShouldThrowWhenConvertingEmptyToNonOptional),
            ("testShouldThrowWhenConvertingMissingToNonOptional", testShouldThrowWhenConvertingMissingToNonOptional),
            ("testShouldConvertComplexitemToOptional", testShouldConvertComplexitemToOptional),
            ("testShouldConvertEmptyToOptional", testShouldConvertEmptyToOptional),
            ("testShouldConvertMissingToOptional", testShouldConvertMissingToOptional)
        ]
    }
}
