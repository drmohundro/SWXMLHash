//
//  TypeConversionPrimitiveTypesTests.swift
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
import Testing

struct TypeConversionPrimitiveTypesTests {
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

    init() {
        parser = XMLHash.parse(xmlWithArraysOfTypes)
    }

    @Test
    func shouldConvertArrayOfGoodIntsToNonOptional() {
        do {
            let value: [Int] = try parser!["root"]["arrayOfGoodInts"]["int"].value()
            #expect(value == [0, 1, 2, 3])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodIntsToOptional() {
        do {
            let value: [Int]? = try parser!["root"]["arrayOfGoodInts"]["int"].value()
            #expect(value != nil)
            if let value = value {
                #expect(value == [0, 1, 2, 3])
            }
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodIntsToArrayOfOptionals() {
        do {
            let value: [Int?] = try parser!["root"]["arrayOfGoodInts"]["int"].value()
            #expect(value.compactMap({ $0 }) == [0, 1, 2, 3])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadIntsToNonOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int])
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadIntsToOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int]?)
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadIntsToArrayOfOptionals() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int?])
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfMixedIntsToNonOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int])
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfMixedIntsToOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int]?)
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfMixedIntsToArrayOfOptionals() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int?])
        }
    }

    @Test
    func shouldConvertArrayOfAttributeIntsToNonOptional() {
        do {
            let value: [Int] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
            #expect(value == [0, 1, 2, 3])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfAttributeIntsToOptional() {
        do {
            let value: [Int]? = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
            #expect(value != nil)
            if let value = value {
                #expect(value == [0, 1, 2, 3])
            }
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfAttributeIntsToArrayOfOptionals() {
        do {
            let value: [Int?] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: "value")
            #expect(value.compactMap({ $0 }) == [0, 1, 2, 3])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfAttributeIntsToNonOptionalWithStringRawRepresentable() {
        enum Keys: String {
            case value
        }
        do {
            let value: [Int] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: Keys.value)
            #expect(value == [0, 1, 2, 3])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfAttributeIntsToOptionalWithStringRawRepresentable() {
        enum Keys: String {
            case value
        }
        do {
            let value: [Int]? = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: Keys.value)
            #expect(value != nil)
            if let value = value {
                #expect(value == [0, 1, 2, 3])
            }
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfAttributeIntsToArrayOfOptionalsWithStringRawRepresentable() {
        enum Keys: String {
            case value
        }
        do {
            let value: [Int?] = try parser!["root"]["arrayOfAttributeInts"]["int"].value(ofAttribute: Keys.value)
            #expect(value.compactMap({ $0 }) == [0, 1, 2, 3])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertEmptyArrayOfIntsToNonOptional() {
        do {
            let value: [Int] = try parser!["root"]["empty"]["int"].value()
            #expect(value == [])
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertEmptyArrayOfIntsToOptional() {
        do {
            let value: [Int]? = try parser!["root"]["empty"]["int"].value()
            #expect(value == nil)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertEmptyArrayOfIntsToArrayOfOptionals() {
        do {
            let value: [Int?] = try parser!["root"]["empty"]["int"].value()
            #expect(value.isEmpty)
        } catch {
            Issue.record("\(error)")
        }
    }
}
