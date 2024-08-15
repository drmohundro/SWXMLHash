//
//  TypeConversionArrayOfNonPrimitiveTypesTests.swift
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

// swiftlint:disable line_length
// swiftlint:disable type_name

struct TypeConversionArrayOfNonPrimitiveTypesTests {
    var parser: XMLIndexer?
    let xmlWithArraysOfTypes = """
        <root>
          <arrayOfGoodBasicItems>
            <basicItem id="1234a">
              <name>item 1</name>
              <price>1</price>
            </basicItem>
            <basicItem id="1234b">
              <name>item 2</name>
              <price>2</price>
            </basicItem>
            <basicItem id="1234c">
              <name>item 3</name>
              <price>3</price>
            </basicItem>
          </arrayOfGoodBasicItems>
          <arrayOfBadBasicItems>
            <basicItem>
              <name>item 1</name>
              <price>1</price>
            </basicItem>
            <basicItem>  // it's missing the name node
              <price>2</price>
            </basicItem>
            <basicItem>
              <name>item 3</name>
              <price>3</price>
            </basicItem>
          </arrayOfBadBasicItems>
          <arrayOfMissingBasicItems />
          <arrayOfGoodAttributeItems>
            <attributeItem name=\"attr 1\" price=\"1.1\"/>
            <attributeItem name=\"attr 2\" price=\"2.2\"/>
            <attributeItem name=\"attr 3\" price=\"3.3\"/>
          </arrayOfGoodAttributeItems>
          <arrayOfBadAttributeItems>
            <attributeItem name=\"attr 1\" price=\"1.1\"/>
            <attributeItem price=\"2.2\"/> // it's missing the name attribute
            <attributeItem name=\"attr 3\" price=\"3.3\"/>
          </arrayOfBadAttributeItems>
        </root>
    """

    let correctBasicItems = [
        BasicItem(name: "item 1", price: 1, id: "1234a"),
        BasicItem(name: "item 2", price: 2, id: "1234b"),
        BasicItem(name: "item 3", price: 3, id: "1234c")
    ]

    let correctAttributeItems = [
        AttributeItem(name: "attr 1", price: 1.1),
        AttributeItem(name: "attr 2", price: 2.2),
        AttributeItem(name: "attr 3", price: 3.3)
    ]

    init() {
        parser = XMLHash.parse(xmlWithArraysOfTypes)
    }

    @Test
    func shouldConvertArrayOfGoodBasicItemsToNonOptional() {
        do {
            let value: [BasicItem] = try parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].value()
            #expect(value == correctBasicItems)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodBasicItemsToOptional() {
        do {
            let value: [BasicItem]? = try parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].value()
            #expect(value != nil)
            if let value = value {
                #expect(value == correctBasicItems)
            }
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodBasicItemsToArrayOfOptionals() {
        do {
            let value: [BasicItem?] = try parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].value()
            #expect(value.compactMap({ $0 }) == correctBasicItems)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadBasicItemsToNonOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadBasicItems"]["basicItem"].value() as [BasicItem])
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadBasicItemsToOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadBasicItems"]["basicItem"].value() as [BasicItem]?)
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadBasicItemsToArrayOfOptionals() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadBasicItems"]["basicItem"].value() as [BasicItem?])
        }
    }

    @Test
    func shouldConvertArrayOfEmptyMissingToOptional() {
        do {
            let value: [BasicItem]? = try parser!["root"]["arrayOfMissingBasicItems"]["basicItem"].value()
            #expect(value == nil)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodAttributeItemsToNonOptional() {
        do {
            let value: [AttributeItem] = try parser!["root"]["arrayOfGoodAttributeItems"]["attributeItem"].value()
            #expect(value == correctAttributeItems)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodAttributeItemsToOptional() {
        do {
            let value: [AttributeItem]? = try parser!["root"]["arrayOfGoodAttributeItems"]["attributeItem"].value()
            #expect(value != nil)
            if let value = value {
                #expect(value == correctAttributeItems)
            }
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldConvertArrayOfGoodAttributeItemsToArrayOfOptionals() {
        do {
            let value: [AttributeItem?] = try parser!["root"]["arrayOfGoodAttributeItems"]["attributeItem"].value()
            #expect(value.compactMap({ $0 }) == correctAttributeItems)
        } catch {
            Issue.record("\(error)")
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadAttributeItemsToNonOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadAttributeItems"]["attributeItem"].value() as [AttributeItem])
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadAttributeItemsToOptional() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadAttributeItems"]["attributeItem"].value() as [AttributeItem]?)
        }
    }

    @Test
    func shouldThrowWhenConvertingArrayOfBadAttributeItemsToArrayOfOptionals() {
        #expect(throws: XMLDeserializationError.self) {
            try (parser!["root"]["arrayOfBadAttributeItems"]["attributeItem"].value() as [AttributeItem?])
        }
    }

    func testFilterWithAttributesShouldWork() {
        do {
            let subParser = parser!["root"]["arrayOfGoodAttributeItems"]["attributeItem"].filterAll { _, idx in idx > 0 }

            let values: [AttributeItem] = try subParser.value()

            #expect(values != nil)
            #expect(values[0].name == "attr 2")
            #expect(values[0].price == 2.2)
            #expect(values[1].name == "attr 3")
            #expect(values[1].price == 3.3)
        } catch {
            Issue.record("\(error)")
        }
    }

    func testFilterAndSerializationSingleShouldWork() {
        do {
            let subParser = parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].filterAll { _, idx in idx == 0 }

            let value: BasicItem = try subParser.value()

            #expect(value != nil)
            #expect(value.id == "1234a")
        } catch {
            Issue.record("\(error)")
        }
    }

    func testFilterAndSerializationShouldWork() {
        do {
            let subParser = parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].filterAll { _, idx in idx > 0 }

            let values: [BasicItem] = try subParser.value()

            #expect(values != nil)
            #expect(values[0].id == "1234b")
            #expect(values[1].id == "1234c")
        } catch {
            Issue.record("\(error)")
        }
    }
}

// swiftlint:enable line_length
// swiftlint:enable type_name
