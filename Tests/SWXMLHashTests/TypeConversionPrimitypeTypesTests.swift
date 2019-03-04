//
//  TypeConversionPrimitypeTypesTests.swift
//  SWXMLHash
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
//

import SWXMLHash
import XCTest

// swiftlint:disable line_length

class TypeConversionPrimitypeTypesTests: XCTestCase {
    var parser: XMLIndexer?
    let xmlWithArraysOfTypes = """
        <root>
          <arrayOfGoodInts>
            <int>0</int> <int>1</int> <int>2</int> <int>3</int>
          </arrayOfGoodInts>
          <arrayOfBadInts>
            <int></int> <int>boom</int>
          </arrayOfBadInts>
          <arrayOfMixedInts>
            <int>0</int> <int>boom</int> <int>2</int> <int>3</int>
          </arrayOfMixedInts>
          <arrayOfAttributeInts>
            <int value=\"0\"/> <int value=\"1\"/> <int value=\"2\"/> <int value=\"3\"/>
          </arrayOfAttributeInts>
          <empty></empty>
        </root>
    """

    override func setUp() {
        super.setUp()
        parser = SWXMLHash.parse(xmlWithArraysOfTypes)
    }

    func testShouldConvertArrayOfGoodIntsToNonOptional() {
        do {
            let value: [Int] = try parser!["root"]["arrayOfGoodInts"]["int"].value()
            XCTAssertEqual(value, [0, 1, 2, 3])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertArrayOfGoodIntsToOptional() {
        do {
            let value: [Int]? = try parser!["root"]["arrayOfGoodInts"]["int"].value()
            XCTAssertNotNil(value)
            if let value = value {
                XCTAssertEqual(value, [0, 1, 2, 3])
            }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertArrayOfGoodIntsToArrayOfOptionals() {
        do {
            let value: [Int?] = try parser!["root"]["arrayOfGoodInts"]["int"].value()
            XCTAssertEqual(value.compactMap({ $0 }), [0, 1, 2, 3])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldThrowWhenConvertingArrayOfBadIntsToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int])) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldThrowWhenConvertingArrayOfBadIntsToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int]?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldThrowWhenConvertingArrayOfBadIntsToArrayOfOptionals() {
        XCTAssertThrowsError(try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int?])) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldThrowWhenConvertingArrayOfMixedIntsToNonOptional() {
        XCTAssertThrowsError(try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int])) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldThrowWhenConvertingArrayOfMixedIntsToOptional() {
        XCTAssertThrowsError(try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int]?)) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldThrowWhenConvertingArrayOfMixedIntsToArrayOfOptionals() {
        XCTAssertThrowsError(try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int?])) { error in
            guard error is XMLDeserializationError else {
                XCTFail("Wrong type of error")
                return
            }
        }
    }

    func testShouldConvertArrayOfAttributeIntsToNonOptional() {
        do {
            let value: [Int] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
            XCTAssertEqual(value, [0, 1, 2, 3])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertArrayOfAttributeIntsToOptional() {
        do {
            let value: [Int]? = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
            XCTAssertNotNil(value)
            if let value = value {
                XCTAssertEqual(value, [0, 1, 2, 3])
            }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertArrayOfAttributeIntsToArrayOfOptionals() {
        do {
            let value: [Int?] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
            XCTAssertEqual(value.compactMap({ $0 }), [0, 1, 2, 3])
        } catch {
            XCTFail("\(error)")
        }
    }

    // swiftlint:disable nesting
    func testShouldConvertArrayOfAttributeIntsToNonOptionalWithStringRawRepresentable() {
        enum Keys: String {
            case value
        }
        do {
            let value: [Int] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: Keys.value)
            XCTAssertEqual(value, [0, 1, 2, 3])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertArrayOfAttributeIntsToOptionalWithStringRawRepresentable() {
        enum Keys: String {
            case value
        }
        do {
            let value: [Int]? = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: Keys.value)
            XCTAssertNotNil(value)
            if let value = value {
                XCTAssertEqual(value, [0, 1, 2, 3])
            }
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertArrayOfAttributeIntsToArrayOfOptionalsWithStringRawRepresentable() {
        enum Keys: String {
            case value
        }
        do {
            let value: [Int?] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: Keys.value)
            XCTAssertEqual(value.compactMap({ $0 }), [0, 1, 2, 3])
        } catch {
            XCTFail("\(error)")
        }
    }
    // swiftlint:enable nesting

    func testShouldConvertEmptyArrayOfIntsToNonOptional() {
        do {
            let value: [Int] = try parser!["root"]["empty"]["int"].value()
            XCTAssertEqual(value, [])
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertEmptyArrayOfIntsToOptional() {
        do {
            let value: [Int]? = try parser!["root"]["empty"]["int"].value()
            XCTAssertNil(value)
        } catch {
            XCTFail("\(error)")
        }
    }

    func testShouldConvertEmptyArrayOfIntsToArrayOfOptionals() {
        do {
            let value: [Int?] = try parser!["root"]["empty"]["int"].value()
            XCTAssertEqual(value.count, 0)
        } catch {
            XCTFail("\(error)")
        }
    }
}

extension TypeConversionPrimitypeTypesTests {
    static var allTests: [(String, (TypeConversionPrimitypeTypesTests) -> () throws -> Void)] {
        return [
            ("testShouldConvertArrayOfGoodIntsToNonOptional", testShouldConvertArrayOfGoodIntsToNonOptional),
            ("testShouldConvertArrayOfGoodIntsToOptional", testShouldConvertArrayOfGoodIntsToOptional),
            ("testShouldConvertArrayOfGoodIntsToArrayOfOptionals", testShouldConvertArrayOfGoodIntsToArrayOfOptionals),
            ("testShouldThrowWhenConvertingArrayOfBadIntsToNonOptional", testShouldThrowWhenConvertingArrayOfBadIntsToNonOptional),
            ("testShouldThrowWhenConvertingArrayOfBadIntsToOptional", testShouldThrowWhenConvertingArrayOfBadIntsToOptional),
            ("testShouldThrowWhenConvertingArrayOfBadIntsToArrayOfOptionals", testShouldThrowWhenConvertingArrayOfBadIntsToArrayOfOptionals),
            ("testShouldThrowWhenConvertingArrayOfMixedIntsToNonOptional", testShouldThrowWhenConvertingArrayOfMixedIntsToNonOptional),
            ("testShouldThrowWhenConvertingArrayOfMixedIntsToOptional", testShouldThrowWhenConvertingArrayOfMixedIntsToOptional),
            ("testShouldThrowWhenConvertingArrayOfMixedIntsToArrayOfOptionals", testShouldThrowWhenConvertingArrayOfMixedIntsToArrayOfOptionals),
            ("testShouldConvertArrayOfAttributeIntsToNonOptional", testShouldConvertArrayOfAttributeIntsToNonOptional),
            ("testShouldConvertArrayOfAttributeIntsToOptional", testShouldConvertArrayOfAttributeIntsToOptional),
            ("testShouldConvertArrayOfAttributeIntsToArrayOfOptionals", testShouldConvertArrayOfAttributeIntsToArrayOfOptionals),
            ("testShouldConvertArrayOfAttributeIntsToNonOptionalWithStringRawRepresentable", testShouldConvertArrayOfAttributeIntsToNonOptionalWithStringRawRepresentable),
            ("testShouldConvertArrayOfAttributeIntsToOptionalWithStringRawRepresentable", testShouldConvertArrayOfAttributeIntsToOptionalWithStringRawRepresentable),
            ("testShouldConvertArrayOfAttributeIntsToArrayOfOptionalsWithStringRawRepresentable", testShouldConvertArrayOfAttributeIntsToArrayOfOptionalsWithStringRawRepresentable),
            ("testShouldConvertEmptyArrayOfIntsToNonOptional", testShouldConvertEmptyArrayOfIntsToNonOptional),
            ("testShouldConvertEmptyArrayOfIntsToOptional", testShouldConvertEmptyArrayOfIntsToOptional),
            ("testShouldConvertEmptyArrayOfIntsToArrayOfOptionals", testShouldConvertEmptyArrayOfIntsToArrayOfOptionals)
        ]
    }
}
