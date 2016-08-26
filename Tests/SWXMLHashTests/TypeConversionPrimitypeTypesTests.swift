//
//  TypeConversionPrimitypeTypesTests.swift
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
// swiftlint:disable line_length

class TypeConversionPrimitypeTypesTests: XCTestCase {
    var parser: XMLIndexer?
    let xmlWithArraysOfTypes = "<root>" +
        "<arrayOfGoodInts>" +
        "   <int>0</int> <int>1</int> <int>2</int> <int>3</int>" +
        "</arrayOfGoodInts>" +
        "<arrayOfBadInts>" +
        "   <int></int> <int>boom</int>" +
        "</arrayOfBadInts>" +
        "<arrayOfMixedInts>" +
        "   <int>0</int> <int>boom</int> <int>2</int> <int>3</int>" +
        "</arrayOfMixedInts>" +
        "<arrayOfAttributeInts>" +
        "   <int value=\"0\"/> <int value=\"1\"/> <int value=\"2\"/> <int value=\"3\"/>" +
        "</arrayOfAttributeInts>" +
        "<empty></empty>" +
    "</root>"

    override func setUp() {
        parser = SWXMLHash.parse(xmlWithArraysOfTypes)
    }

    func testShouldConvertArrayOfGoodIntsToNonOptional() {
        let value: [Int] = try! parser!["root"]["arrayOfGoodInts"]["int"].value()
        XCTAssertEqual(value, [0, 1, 2, 3])
    }

    func testShouldConvertArrayOfGoodIntsToOptional() {
        let value: [Int]? = try! parser!["root"]["arrayOfGoodInts"]["int"].value()
        XCTAssertEqual(value!, [0, 1, 2, 3])
    }

    func testShouldConvertArrayOfGoodIntsToArrayOfOptionals() {
        let value: [Int?] = try! parser!["root"]["arrayOfGoodInts"]["int"].value()
        XCTAssertEqual(value.flatMap({ $0 }), [0, 1, 2, 3])
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
        let value: [Int] = try! parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
        XCTAssertEqual(value, [0, 1, 2, 3])
    }

    func testShouldConvertArrayOfAttributeIntsToOptional() {
        let value: [Int]? = try! parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
        XCTAssertEqual(value!, [0, 1, 2, 3])
    }

    func testShouldConvertArrayOfAttributeIntsToArrayOfOptionals() {
        let value: [Int?] = try! parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
        XCTAssertEqual(value.flatMap({ $0 }), [0, 1, 2, 3])
    }

    func testShouldConvertEmptyArrayOfIntsToNonOptional() {
        let value: [Int] = try! parser!["root"]["empty"]["int"].value()
        XCTAssertEqual(value, [])
    }

    func testShouldConvertEmptyArrayOfIntsToOptional() {
        let value: [Int]? = try! parser!["root"]["empty"]["int"].value()
        XCTAssertNil(value)
    }

    func testShouldConvertEmptyArrayOfIntsToArrayOfOptionals() {
        let value: [Int?] = try! parser!["root"]["empty"]["int"].value()
        XCTAssertEqual(value.count, 0)
    }
}
