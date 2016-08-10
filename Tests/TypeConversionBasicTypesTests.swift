//
//  TypesConversionBasicTests.swift
//
//  Copyright (c) 2016 David Mohundro
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

import SWXMLHash
import XCTest

// swiftlint:disable force_try
// swiftlint:disable variable_name

class TypeConversionBasicTypesTests: XCTestCase {
    var parser: XMLIndexer?
    let xmlWithBasicTypes = "<root>" +
        "  <string>the string value</string>" +
        "  <int>100</int>" +
        "  <double>100.45</double>" +
        "  <float>44.12</float>" +
        "  <bool1>0</bool1>" +
        "  <bool2>true</bool2>" +
        "  <empty></empty>" +
        "  <basicItem>" +
        "    <name>the name of basic item</name>" +
        "    <price>99.14</price>" +
        "  </basicItem>" +
        "  <attr string=\"stringValue\" int=\"200\" double=\"200.15\" float=\"205.42\" bool1=\"0\" bool2=\"true\"/>" +
        "  <attributeItem name=\"the name of attribute item\" price=\"19.99\"/>" +
    "</root>"

    override func setUp() {
        parser = SWXMLHash.parse(xmlWithBasicTypes)
    }

    func testShouldConvertValueToNonOptional() {
        let value: String = try! parser!["root"]["string"].value()
        XCTAssertEqual(value, "the string value")
    }

    func testShouldConvertEmptyToNonOptional() {
        let value: String = try! parser!["root"]["empty"].value()
        XCTAssertEqual(value, "")
    }

    func testShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as String)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldConvertValueToOptional() {
        let value: String? = try! parser!["root"]["string"].value()
        XCTAssertEqual(value, "the string value")
    }

    func testShouldConvertEmptyToOptional() {
        let value: String? = try! parser!["root"]["empty"].value()
        XCTAssertEqual(value, "")
    }

    func testShouldConvertMissingToOptional() {
        let value: String? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }

    func testShouldConvertAttributeToNonOptional() {
        let value: String = try! parser!["root"]["attr"].value(ofAttribute: "string")
        XCTAssertEqual(value, "stringValue")
    }

    func testShouldConvertAttributeToOptional() {
        let value: String? = parser!["root"]["attr"].value(ofAttribute: "string")
        XCTAssertEqual(value, "stringValue")
    }

    func testShouldThrowWhenConvertingMissingAttributeToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["attr"].value(ofAttribute: "missing") as String)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldConvertMissingAttributeToOptional() {
        let value: String? = parser!["root"]["attr"].value(ofAttribute: "missing")
        XCTAssertNil(value)
    }

    func testIntShouldConvertValueToNonOptional() {
        let value: Int = try! parser!["root"]["int"].value()
        XCTAssertEqual(value, 100)
    }

    func testIntShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Int)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testIntShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as Int)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testIntShouldConvertValueToOptional() {
        let value: Int? = try! parser!["root"]["int"].value()
        XCTAssertEqual(value, 100)
    }

    func testIntShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Int?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testIntShouldConvertMissingToOptional() {
        let value: Int? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }

    func testIntShouldConvertAttributeToNonOptional() {
        let value: Int = try! parser!["root"]["attr"].value(ofAttribute: "int")
        XCTAssertEqual(value, 200)
    }

    func testIntShouldConvertAttributeToOptional() {
        let value: Int? = parser!["root"]["attr"].value(ofAttribute: "int")
        XCTAssertEqual(value, 200)
    }

    func testDoubleShouldConvertValueToNonOptional() {
        let value: Double = try! parser!["root"]["double"].value()
        XCTAssertEqual(value, 100.45)
    }

    func testDoubleShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Double)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testDoubleShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as Double)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testDoubleShouldConvertValueToOptional() {
        let value: Double? = try! parser!["root"]["double"].value()
        XCTAssertEqual(value, 100.45)
    }

    func testDoubleShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Double?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testDoubleShouldConvertMissingToOptional() {
        let value: Double? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }

    func testDoubleShouldConvertAttributeToNonOptional() {
        let value: Double = try! parser!["root"]["attr"].value(ofAttribute: "double")
        XCTAssertEqual(value, 200.15)
    }

    func testDoubleShouldConvertAttributeToOptional() {
        let value: Double? = parser!["root"]["attr"].value(ofAttribute: "double")
        XCTAssertEqual(value, 200.15)
    }

    func testFloatShouldConvertValueToNonOptional() {
        let value: Float = try! parser!["root"]["float"].value()
        XCTAssertEqual(value, 44.12)
    }

    func testFloatShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Float)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testFloatShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as Float)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testFloatShouldConvertValueToOptional() {
        let value: Float? = try! parser!["root"]["float"].value()
        XCTAssertEqual(value, 44.12)
    }

    func testFloatShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Float?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testFloatShouldConvertMissingToOptional() {
        let value: Float? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }

    func testFloatShouldConvertAttributeToNonOptional() {
        let value: Float = try! parser!["root"]["attr"].value(ofAttribute: "float")
        XCTAssertEqual(value, 205.42)
    }

    func testFloatShouldConvertAttributeToOptional() {
        let value: Float? = parser!["root"]["attr"].value(ofAttribute: "float")
        XCTAssertEqual(value, 205.42)
    }

    func testBoolShouldConvertValueToNonOptional() {
        let value1: Bool = try! parser!["root"]["bool1"].value()
        let value2: Bool = try! parser!["root"]["bool2"].value()
        XCTAssertFalse(value1)
        XCTAssertTrue(value2)
    }

    func testBoolShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Bool)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testBoolShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as Bool)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testBoolShouldConvertValueToOptional() {
        let value1: Bool? = try! parser!["root"]["bool1"].value()
        XCTAssertEqual(value1, false)
        let value2: Bool? = try! parser!["root"]["bool2"].value()
        XCTAssertEqual(value2, true)
    }

    func testBoolShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as Bool?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testBoolShouldConvertMissingToOptional() {
        let value: Bool? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }

    func testBoolShouldConvertAttributeToNonOptional() {
        let value: Bool = try! parser!["root"]["attr"].value(ofAttribute: "bool1")
        XCTAssertEqual(value, false)
    }

    func testBoolShouldConvertAttributeToOptional() {
        let value: Bool? = parser!["root"]["attr"].value(ofAttribute: "bool2")
        XCTAssertEqual(value, true)
    }

    let correctBasicItem = BasicItem(name: "the name of basic item", price: 99.14)

    func testBasicItemShouldConvertBasicitemToNonOptional() {
        let value: BasicItem = try! parser!["root"]["basicItem"].value()
        XCTAssertEqual(value, correctBasicItem)
    }

    func testBasicItemShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as BasicItem)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testBasicItemShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as BasicItem)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testBasicItemShouldConvertBasicitemToOptional() {
        let value: BasicItem? = try! parser!["root"]["basicItem"].value()
        XCTAssertEqual(value, correctBasicItem)
    }

    func testBasicItemShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as BasicItem?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testBasicItemShouldConvertMissingToOptional() {
        let value: BasicItem? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }

    let correctAttributeItem = AttributeItem(name: "the name of attribute item", price: 19.99)

    func testAttributeItemShouldConvertAttributeItemToNonOptional() {
        let value: AttributeItem = try! parser!["root"]["attributeItem"].value()
        XCTAssertEqual(value, correctAttributeItem)
    }

    func testAttributeItemShouldThrowWhenConvertingEmptyToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as AttributeItem)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testAttributeItemShouldThrowWhenConvertingMissingToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["missing"].value() as AttributeItem)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testAttributeItemShouldConvertAttributeItemToOptional() {
        let value: AttributeItem? = try! parser!["root"]["attributeItem"].value()
        XCTAssertEqual(value, correctAttributeItem)
    }

    func testAttributeItemShouldConvertEmptyToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["empty"].value() as AttributeItem?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testAttributeItemShouldConvertMissingToOptional() {
        let value: AttributeItem? = try! parser!["root"]["missing"].value()
        XCTAssertNil(value)
    }
}

struct BasicItem: XMLIndexerDeserializable {
    let name: String
    let price: Double

    static func deserialize(node: XMLIndexer) throws -> BasicItem {
        return try BasicItem(
            name: node["name"].value(),
            price: node["price"].value()
        )
    }
}

extension BasicItem: Equatable {}

func == (a: BasicItem, b: BasicItem) -> Bool {
    return a.name == b.name && a.price == b.price
}

struct AttributeItem: XMLElementDeserializable {
    let name: String
    let price: Double

    static func deserialize(element: XMLElement) throws -> AttributeItem {
        return try AttributeItem(
            name: element.value(ofAttribute: "name"),
            price: element.value(ofAttribute: "price")
        )
    }
}

extension AttributeItem: Equatable {}

func == (a: AttributeItem, b: AttributeItem) -> Bool {
    return a.name == b.name && a.price == b.price
}
