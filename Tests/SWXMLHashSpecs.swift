//
//  SWXMLHashTests.swift
//
//  Copyright (c) 2014 David Mohundro
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
import Quick
import Nimble

// swiftlint:disable force_unwrapping
// swiftlint:disable force_try
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
// swiftlint:disable variable_name

class SWXMLHashTests: QuickSpec {
    override func spec() {
        let xmlToParse = "<root><header>header mixed content<title>Test Title Header</title>more mixed content</header><catalog><book id=\"bk101\"><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book><book id=\"bk102\"><author>Ralls, Kim</author><title>Midnight Rain</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-12-16</publish_date><description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description></book><book id=\"bk103\"><author>Corets, Eva</author><title>Maeve Ascendant</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-11-17</publish_date><description>After the collapse of a nanotechnology society in England, the young survivors lay the foundation for a new society.</description></book></catalog></root>"

        var xml: XMLIndexer?

        beforeEach {
            xml = SWXMLHash.parse(xmlToParse)
        }

        describe("xml parsing") {
            it("should be able to parse individual elements") {
                expect(xml!["root"]["header"]["title"].element?.text).to(equal("Test Title Header"))
            }

            it("should be able to parse element groups") {
                expect(xml!["root"]["catalog"]["book"][1]["author"].element?.text).to(equal("Ralls, Kim"))
            }

            it("should be able to parse attributes") {
                expect(xml!["root"]["catalog"]["book"][1].element?.attributes["id"]).to(equal("bk102"))
            }

            it("should be able to look up elements by name and attribute") {
                expect(try! xml!["root"]["catalog"]["book"].withAttr("id", "bk102")["author"].element?.text).to(equal("Ralls, Kim"))
            }

            it("should be able to iterate element groups") {
                let result = xml!["root"]["catalog"]["book"].all.map({ $0["genre"].element!.text! }).joinWithSeparator(", ")
                expect(result).to(equal("Computer, Fantasy, Fantasy"))
            }

            it("should be able to iterate element groups even if only one element is found") {
                expect(xml!["root"]["header"]["title"].all.count).to(equal(1))
            }

            it("should be able to index element groups even if only one element is found") {
                expect(xml!["root"]["header"]["title"][0].element?.text).to(equal("Test Title Header"))
            }

            it("should be able to iterate using for-in") {
                var count = 0
                for _ in xml!["root"]["catalog"]["book"] {
                    count += 1
                }

                expect(count).to(equal(3))
            }

            it("should be able to enumerate children") {
                let result = xml!["root"]["catalog"]["book"][0].children.map({ $0.element!.name }).joinWithSeparator(", ")
                expect(result).to(equal("author, title, genre, price, publish_date, description"))
            }

            it("should be able to handle mixed content") {
                expect(xml!["root"]["header"].element?.text).to(equal("header mixed contentmore mixed content"))
            }

            it("should handle interleaving XML elements") {
                let interleavedXml = "<html><body><p>one</p><div>two</div><p>three</p><div>four</div></body></html>"
                let parsed = SWXMLHash.parse(interleavedXml)

                let result = parsed["html"]["body"].children.map({ $0.element!.text! }).joinWithSeparator(", ")
                expect(result).to(equal("one, two, three, four"))
            }

            it("should be able to provide a description for the document") {
                let descriptionXml = "<root><foo><what id=\"myId\">puppies</what></foo></root>"
                let parsed = SWXMLHash.parse(descriptionXml)

                expect(parsed.description).to(equal("<root><foo><what id=\"myId\">puppies</what></foo></root>"))
            }
        }

        describe("white space parsing") {
            var xml: XMLIndexer?

            beforeEach {
                let bundle = NSBundle(forClass: SWXMLHashTests.self)
                let path = bundle.pathForResource("test", ofType: "xml")
                let data = NSData(contentsOfFile: path!)
                xml = SWXMLHash.parse(data!)
            }

            it("should be able to pull text between elements without whitespace (issue #6)") {
                expect(xml!["niotemplate"]["section"][0]["constraint"][1].element?.text).to(equal("H:|-15-[title]-15-|"))
            }

            it("should be able to correctly parse CDATA sections *with* whitespace") {
                expect(xml!["niotemplate"]["other"].element?.text).to(equal("\n        \n  this\n  has\n  white\n  space\n        \n    "))
            }
        }

        describe("xml parsing error scenarios") {
            it("should return nil when keys don't match") {
                expect(xml!["root"]["what"]["header"]["foo"].element?.name).to(beNil())
            }

            it("should provide an error object when keys don't match") {
                var err: XMLIndexer.Error?
                defer {
                    expect(err).toNot(beNil())
                }
                do {
                    try xml!.byKey("root").byKey("what").byKey("header").byKey("foo")
                } catch let error as XMLIndexer.Error {
                    err = error
                } catch { err = nil }
            }

            it("should provide an error element when indexers don't match") {
                var err: XMLIndexer.Error?
                defer {
                    expect(err).toNot(beNil())
                }
                do {
                    try xml!.byKey("what").byKey("subelement").byIndex(5).byKey("nomatch")
                } catch let error as XMLIndexer.Error {
                    err = error
                } catch { err = nil }
            }

            it("should still return errors when accessing via subscripting") {
                var err: XMLIndexer.Error? = nil
                switch xml!["what"]["subelement"][5]["nomatch"] {
                case .XMLError(let error):
                    err = error
                default:
                    err = nil
                }
                expect(err).toNot(beNil())
            }
        }

        describe("mixed text with XML elements") {
            var xml: XMLIndexer?

            beforeEach {
                let xmlContent = "<everything><news><content>Here is a cool thing <a href=\"google.com\">A</a> and second cool thing <a href=\"fb.com\">B</a></content></news></everything>"
                xml = SWXMLHash.parse(xmlContent)
            }

            it("should be able to get all contents inside of an element") {
                expect(xml!["everything"]["news"]["content"].description).to(equal("<content>Here is a cool thing <a href=\"google.com\">A</a> and second cool thing <a href=\"fb.com\">B</a></content>"))
            }
        }
    }
}

class SWXMLHashLazyTests: QuickSpec {
    override func spec() {
        let xmlToParse = "<root><header>header mixed content<title>Test Title Header</title>more mixed content</header><catalog><book id=\"bk101\"><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book><book id=\"bk102\"><author>Ralls, Kim</author><title>Midnight Rain</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-12-16</publish_date><description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description></book><book id=\"bk103\"><author>Corets, Eva</author><title>Maeve Ascendant</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-11-17</publish_date><description>After the collapse of a nanotechnology society in England, the young survivors lay the foundation for a new society.</description></book></catalog></root>"

        var xml: XMLIndexer?

        beforeEach {
            xml = SWXMLHash.config { config in config.shouldProcessLazily = true }.parse(xmlToParse)
        }

        describe("lazy xml parsing") {
            it("should be able to parse individual elements") {
                expect(xml!["root"]["header"]["title"].element?.text).to(equal("Test Title Header"))
            }

            it("should be able to parse element groups") {
                expect(xml!["root"]["catalog"]["book"][1]["author"].element?.text).to(equal("Ralls, Kim"))
            }

            it("should be able to parse attributes") {
                expect(xml!["root"]["catalog"]["book"][1].element?.attributes["id"]).to(equal("bk102"))
            }

            it("should be able to look up elements by name and attribute") {
                expect(try! xml!["root"]["catalog"]["book"].withAttr("id", "bk102")["author"].element?.text).to(equal("Ralls, Kim"))
            }

            it("should be able to iterate element groups") {
                let result = xml!["root"]["catalog"]["book"].all.map({ $0["genre"].element?.text ?? "" }).joinWithSeparator(", ")
                expect(result).to(equal("Computer, Fantasy, Fantasy"))
            }

            it("should be able to iterate element groups even if only one element is found") {
                expect(xml!["root"]["header"]["title"].all.count).to(equal(1))
            }

            it("should be able to index element groups even if only one element is found") {
                expect(xml!["root"]["header"]["title"][0].element?.text).to(equal("Test Title Header"))
            }

            it("should be able to iterate using for-in") {
                var count = 0
                for _ in xml!["root"]["catalog"]["book"] {
                    count += 1
                }

                expect(count).to(equal(3))
            }

            it("should be able to enumerate children") {
                let result = xml!["root"]["catalog"]["book"][0].children.map({ $0.element?.name ?? "" }).joinWithSeparator(", ")
                expect(result).to(equal("author, title, genre, price, publish_date, description"))
            }

            it("should be able to handle mixed content") {
                expect(xml!["root"]["header"].element?.text).to(equal("header mixed contentmore mixed content"))
            }

            it("should handle interleaving XML elements") {
                let interleavedXml = "<html><body><p>one</p><div>two</div><p>three</p><div>four</div></body></html>"
                let parsed = SWXMLHash.lazy(interleavedXml)

                let result = parsed["html"]["body"].children.map({ $0.element?.text ?? "" }).joinWithSeparator(", ")
                expect(result).to(equal("one, two, three, four"))
            }
        }

        describe("white space parsing") {
            var xml: XMLIndexer?

            beforeEach {
                let bundle = NSBundle(forClass: SWXMLHashTests.self)
                let path = bundle.pathForResource("test", ofType: "xml")
                let data = NSData(contentsOfFile: path!)
                xml = SWXMLHash.lazy(data!)
            }

            it("should be able to pull text between elements without whitespace (issue #6)") {
                expect(xml!["niotemplate"]["section"][0]["constraint"][1].element?.text).to(equal("H:|-15-[title]-15-|"))
            }

            it("should be able to correctly parse CDATA sections *with* whitespace") {
                expect(xml!["niotemplate"]["other"].element?.text).to(equal("\n        \n  this\n  has\n  white\n  space\n        \n    "))
            }
        }

        describe("xml parsing error scenarios") {
            it("should return nil when keys don't match") {
                expect(xml!["root"]["what"]["header"]["foo"].element?.name).to(beNil())
            }
        }
    }
}

class SWXMLHashConfigSpecs: QuickSpec {
    override func spec() {
        describe("optional configuration options for NSXMLParser") {
            var parser: XMLIndexer?
            let xmlWithNamespace = "<root xmlns:h=\"http://www.w3.org/TR/html4/\"" +
                "  xmlns:f=\"http://www.w3schools.com/furniture\">" +
                "  <h:table>" +
                "    <h:tr>" +
                "      <h:td>Apples</h:td>" +
                "      <h:td>Bananas</h:td>" +
                "    </h:tr>" +
                "  </h:table>" +
            "</root>"

            beforeEach {
                parser = SWXMLHash.config { conf in
                    conf.shouldProcessNamespaces = true
                }.parse(xmlWithNamespace)
            }

            it("should allow processing namespaces or not") {
                expect(parser!["root"]["table"]["tr"]["td"][0].element?.text).to(equal("Apples"))
            }
        }
    }
}

class SWXMLHashTypeConversionSpecs: QuickSpec {
    override func spec() {
        describe("basic types conversion") {
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
                "</root>"

            beforeEach {
                parser = SWXMLHash.parse(xmlWithBasicTypes)
            }

            describe("when parsing String") {
                it("should convert `value` to non-optional") {
                    let value: String = try! parser!["root"]["string"].value()
                    expect(value) == "the string value"
                }

                it("should convert `empty` to non-optional") {
                    let value: String = try! parser!["root"]["empty"].value()
                    expect(value) == ""
                }

                it("should throw when converting `missing` to non-optional") {
                    expect { try (parser!["root"]["missing"].value() as String) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `value` to optional") {
                    let value: String? = try! parser!["root"]["string"].value()
                    expect(value) == "the string value"
                }

                it("should convert `empty` to optional") {
                    let value: String? = try! parser!["root"]["empty"].value()
                    expect(value) == ""
                }

                it("should convert `missing` to optional") {
                    let value: String? = try! parser!["root"]["missing"].value()
                    expect(value).to(beNil())
                }
            }

            describe("when parsing Int") {
                it("should convert `value` to non-optional") {
                    let value: Int = try! parser!["root"]["int"].value()
                    expect(value) == 100
                }

                it("should throw when converting `empty` to non-optional") {
                    expect { try (parser!["root"]["empty"].value() as Int) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should throw when converting `missing` to non-optional") {
                    expect { try (parser!["root"]["missing"].value() as Int) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `value` to optional") {
                    let value: Int? = try! parser!["root"]["int"].value()
                    expect(value) == 100
                }

                it("should convert `empty` to optional") {
                    expect { try (parser!["root"]["empty"].value() as Int?) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `missing` to optional") {
                    let value: Int? = try! parser!["root"]["missing"].value()
                    expect(value).to(beNil())
                }
            }

            describe("when parsing Double") {
                it("should convert `value` to non-optional") {
                    let value: Double = try! parser!["root"]["double"].value()
                    expect(value) == 100.45
                }

                it("should throw when converting `empty` to non-optional") {
                    expect { try (parser!["root"]["empty"].value() as Double) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should throw when converting `missing` to non-optional") {
                    expect { try (parser!["root"]["missing"].value() as Double) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `value` to optional") {
                    let value: Double? = try! parser!["root"]["double"].value()
                    expect(value) == 100.45
                }

                it("should convert `empty` to optional") {
                    expect { try (parser!["root"]["empty"].value() as Double?) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `missing` to optional") {
                    let value: Double? = try! parser!["root"]["missing"].value()
                    expect(value).to(beNil())
                }
            }

            describe("when parsing Float") {
                it("should convert `value` to non-optional") {
                    let value: Float = try! parser!["root"]["float"].value()
                    expect(value) == 44.12
                }

                it("should throw when converting `empty` to non-optional") {
                    expect { try (parser!["root"]["empty"].value() as Float) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should throw when converting `missing` to non-optional") {
                    expect { try (parser!["root"]["missing"].value() as Float) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `value` to optional") {
                    let value: Float? = try! parser!["root"]["float"].value()
                    expect(value) == 44.12
                }

                it("should convert `empty` to optional") {
                    expect { try (parser!["root"]["empty"].value() as Float?) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `missing` to optional") {
                    let value: Float? = try! parser!["root"]["missing"].value()
                    expect(value).to(beNil())
                }
            }

            describe("when parsing Bool") {
                it("should convert `value` to non-optional") {
                    let value1: Bool = try! parser!["root"]["bool1"].value()
                    let value2: Bool = try! parser!["root"]["bool2"].value()
                    expect(value1) == false
                    expect(value2) == true
                }

                it("should throw when converting `empty` to non-optional") {
                    expect { try (parser!["root"]["empty"].value() as Bool) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should throw when converting `missing` to non-optional") {
                    expect { try (parser!["root"]["missing"].value() as Bool) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `value` to optional") {
                    let value1: Bool? = try! parser!["root"]["bool1"].value()
                    expect(value1) == false
                    let value2: Bool? = try! parser!["root"]["bool2"].value()
                    expect(value2) == true
                }

                it("should convert `empty` to optional") {
                    expect { try (parser!["root"]["empty"].value() as Bool?) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `missing` to optional") {
                    let value: Bool? = try! parser!["root"]["missing"].value()
                    expect(value).to(beNil())
                }
            }

            describe("when parsing BasicItem") {

                let correctBasicItem = BasicItem(name: "the name of basic item", price: 99.14)

                it("should convert `basicItem` to non-optional") {
                    let value: BasicItem = try! parser!["root"]["basicItem"].value()
                    expect(value) == correctBasicItem
                }

                it("should throw when converting `empty` to non-optional") {
                    expect { try (parser!["root"]["empty"].value() as BasicItem) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should throw when converting `missing` to non-optional") {
                    expect { try (parser!["root"]["missing"].value() as BasicItem) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `basicItem` to optional") {
                    let value: BasicItem? = try! parser!["root"]["basicItem"].value()
                    expect(value) == correctBasicItem
                }

                it("should convert `empty` to optional") {
                    expect { try (parser!["root"]["empty"].value() as BasicItem?) }.to(
                        throwError(errorType: XMLDeserializationError.self)
                    )
                }

                it("should convert `missing` to optional") {
                    let value: BasicItem? = try! parser!["root"]["missing"].value()
                    expect(value).to(beNil())
                }
            }
        }

        describe("complex types conversion") {

            var parser: XMLIndexer?
            let xmlWithComplexType = "<root>" +
                "  <complexItem>" +
                "    <name>the name of complex item</name>" +
                "    <price>1024</price>" +
                "    <basicItems>" +
                "       <basicItem>" +
                "          <name>item 1</name>" +
                "          <price>1</price>" +
                "       </basicItem>" +
                "       <basicItem>" +
                "          <name>item 2</name>" +
                "          <price>2</price>" +
                "       </basicItem>" +
                "       <basicItem>" +
                "          <name>item 3</name>" +
                "          <price>3</price>" +
                "       </basicItem>" +
                "    </basicItems>" +
                "  </complexItem>" +
                "  <empty></empty>" +
                "</root>"

            let correctComplexItem = ComplexItem(
                name: "the name of complex item",
                priceOptional: 1024,
                basics: [
                    BasicItem(name: "item 1", price: 1),
                    BasicItem(name: "item 2", price: 2),
                    BasicItem(name: "item 3", price: 3),
                ]
            )

            beforeEach {
                parser = SWXMLHash.parse(xmlWithComplexType)
            }


            it("should convert `complexItem` to non-optional") {
                let value: ComplexItem = try! parser!["root"]["complexItem"].value()
                expect(value) == correctComplexItem
            }

            it("should throw when converting `empty` to non-optional") {
                expect { try (parser!["root"]["empty"].value() as ComplexItem) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting `missing` to non-optional") {
                expect { try (parser!["root"]["missing"].value() as ComplexItem) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should convert `complexItem` to optional") {
                let value: ComplexItem? = try! parser!["root"]["complexItem"].value()
                expect(value) == correctComplexItem
            }

            it("should convert `empty` to optional") {
                expect { try (parser!["root"]["empty"].value() as ComplexItem?) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should convert `missing` to optional") {
                let value: ComplexItem? = try! parser!["root"]["missing"].value()
                expect(value).to(beNil())
            }
        }

        describe("array of primitive types conversion") {

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
                "<empty></empty>" +
                "</root>"

            beforeEach {
                parser = SWXMLHash.parse(xmlWithArraysOfTypes)
            }

            it("should convert array of good Ints to non-optional") {
                let value: [Int] = try! parser!["root"]["arrayOfGoodInts"]["int"].value()
                expect(value) == [0, 1, 2, 3]
            }

            it("should convert array of good Ints to optional") {
                let value: [Int]? = try! parser!["root"]["arrayOfGoodInts"]["int"].value()
                expect(value) == [0, 1, 2, 3]
            }

            it("should convert array of good Ints to array of optionals") {
                let value: [Int?] = try! parser!["root"]["arrayOfGoodInts"]["int"].value()
                expect(value.flatMap({ $0 })) == [0, 1, 2, 3]
            }

            it("should throw when converting array of bad Ints to non-optional") {
                expect { try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int]) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of bad Ints to optional") {
                expect { try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int]?) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of bad Ints to array of optionals") {
                expect { try (parser!["root"]["arrayOfBadInts"]["int"].value() as [Int?]) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of mixed Ints to non-optional") {
                expect { try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int]) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of mixed Ints to optional") {
                expect { try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int]?) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of mixed Ints to array of optionals") {
                expect { try (parser!["root"]["arrayOfMixedInts"]["int"].value() as [Int?]) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should convert empty array of Ints to non-optional") {
                let value: [Int] = try! parser!["root"]["empty"]["int"].value()
                expect(value) == []
            }

            it("should convert empty array of Ints to optional") {
                let value: [Int]? = try! parser!["root"]["empty"]["int"].value()
                expect(value).to(beNil())
            }

            it("should convert empty array of Ints to array of optionals") {
                let value: [Int?] = try! parser!["root"]["empty"]["int"].value()
                expect(value.count) == 0
            }
        }

        describe("array of non-primitive types conversion") {

            var parser: XMLIndexer?
            let xmlWithArraysOfTypes = "<root>" +
                "<arrayOfGoodBasicItems>" +
                "   <basicItem>" +
                "      <name>item 1</name>" +
                "      <price>1</price>" +
                "   </basicItem>" +
                "   <basicItem>" +
                "      <name>item 2</name>" +
                "      <price>2</price>" +
                "   </basicItem>" +
                "   <basicItem>" +
                "      <name>item 3</name>" +
                "      <price>3</price>" +
                "   </basicItem>" +
                "</arrayOfBadBasicItems>" +
                "   <basicItem>" +
                "      <name>item 1</name>" +
                "      <price>1</price>" +
                "   </basicItem>" +
                "   <basicItem>" +  // it's missing the `name` node
                "      <price>2</price>" +
                "   </basicItem>" +
                "   <basicItem>" +
                "      <name>item 3</name>" +
                "      <price>3</price>" +
                "   </basicItem>" +
                "</arrayOfBadBasicItems>" +
                "</root>"

            let correctBasicItems = [
                BasicItem(name: "item 1", price: 1),
                BasicItem(name: "item 2", price: 2),
                BasicItem(name: "item 3", price: 3),
            ]

            beforeEach {
                parser = SWXMLHash.parse(xmlWithArraysOfTypes)
            }

            it("should convert array of good BasicItems items to non-optional") {
                let value: [BasicItem] = try! parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].value()
                expect(value) == correctBasicItems
            }

            it("should convert array of good BasicItems items to optional") {
                let value: [BasicItem]? = try! parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].value()
                expect(value) == correctBasicItems
            }

            it("should convert array of good BasicItems items to array of optionals") {
                let value: [BasicItem?] = try! parser!["root"]["arrayOfGoodBasicItems"]["basicItem"].value()
                expect(value.flatMap({ $0 })) == correctBasicItems
            }

            it("should throw when converting array of bad BasicItems to non-optional") {
                expect { try (parser!["root"]["arrayOfBadBasicItems"]["basicItem"].value() as [BasicItem]) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of bad BasicItems to non-optional") {
                expect { try (parser!["root"]["arrayOfBadBasicItems"]["basicItem"].value() as [BasicItem]?) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }

            it("should throw when converting array of bad BasicItems to array of optionals") {
                expect { try (parser!["root"]["arrayOfBadBasicItems"]["basicItem"].value() as [BasicItem?]) }.to(
                    throwError(errorType: XMLDeserializationError.self)
                )
            }
        }
    }
}

struct BasicItem: XMLIndexerDeserializable {
    let name: String
    let price: Double


    // MARK: - XMLIndexerDeserializable

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

struct ComplexItem: XMLIndexerDeserializable {
    let name: String
    let priceOptional: Double?
    let basics: [BasicItem]


    // MARK: - XMLIndexerDeserializable

    static func deserialize(node: XMLIndexer) throws -> ComplexItem {
        return try ComplexItem(
            name: node["name"].value(),
            priceOptional: node["price"].value(),
            basics: node["basicItems"]["basicItem"].value()
        )
    }
}

extension ComplexItem: Equatable {}

func == (a: ComplexItem, b: ComplexItem) -> Bool {
    return a.name == b.name && a.priceOptional == b.priceOptional && a.basics == b.basics
}
