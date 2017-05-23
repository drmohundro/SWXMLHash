//
//  XMLParsingTests.swift
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

class XMLParsingTests: XCTestCase {
    let xmlToParse = "<root><header>header mixed content<title>Test Title Header</title>more mixed content</header><catalog><book id=\"bk101\"><author>Gambardella, Matthew</author><title>XML Developer's Guide</title><genre>Computer</genre><price>44.95</price><publish_date>2000-10-01</publish_date><description>An in-depth look at creating applications with XML.</description></book><book id=\"bk102\"><author>Ralls, Kim</author><title>Midnight Rain</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-12-16</publish_date><description>A former architect battles corporate zombies, an evil sorceress, and her own childhood to become queen of the world.</description></book><book id=\"bk103\"><author>Corets, Eva</author><title>Maeve Ascendant</title><genre>Fantasy</genre><price>5.95</price><publish_date>2000-11-17</publish_date><description>After the collapse of a nanotechnology society in England, the young survivors lay the foundation for a new society.</description></book></catalog></root>"

    var xml: XMLIndexer?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        xml = SWXMLHash.parse(xmlToParse)
    }

    func testShouldBeAbleToParseIndividualElements() {
        XCTAssertEqual(xml!["root"]["header"]["title"].xmlElement?.text, "Test Title Header")
    }

    func testShouldBeAbleToParseElementGroups() {
        XCTAssertEqual(xml!["root"]["catalog"]["book"][1]["author"].xmlElement?.text, "Ralls, Kim")
    }

    func testShouldBeAbleToParseAttributes() {
        XCTAssertEqual(xml!["root"]["catalog"]["book"][1].xmlElement?.attributes["id"], "bk102")
        XCTAssertEqual(xml!["root"]["catalog"]["book"][1].xmlElement?.attribute(by: "id")?.text, "bk102")
    }

    func testShouldBeAbleToLookUpElementsByNameAndAttribute() {
        do {
            let value = try xml!["root"]["catalog"]["book"].withAttr("id", "bk102")["author"].xmlElement?.text
            XCTAssertEqual(value, "Ralls, Kim")
        } catch {
            XCTFail("\(error)")
        }

    }

    func testShouldBeAbleToIterateElementGroups() {
        let result = xml!["root"]["catalog"]["book"].all.map({ $0["genre"].xmlElement!.text! }).joined(separator: ", ")
        XCTAssertEqual(result, "Computer, Fantasy, Fantasy")
    }

    func testShouldBeAbleToIterateElementGroupsEvenIfOnlyOneElementIsFound() {
        XCTAssertEqual(xml!["root"]["header"]["title"].all.count, 1)
    }

    func testShouldBeAbleToIndexElementGroupsEvenIfOnlyOneElementIsFound() {
        XCTAssertEqual(xml!["root"]["header"]["title"][0].xmlElement?.text, "Test Title Header")
    }

    func testShouldBeAbleToIterateUsingForIn() {
        var count = 0
        for _ in xml!["root"]["catalog"]["book"] {
            count += 1
        }

        XCTAssertEqual(count, 3)
    }

    func testShouldBeAbleToEnumerateChildren() {
        let result = xml!["root"]["catalog"]["book"][0].children.map({ $0.xmlElement!.name }).joined(separator: ", ")
        XCTAssertEqual(result, "author, title, genre, price, publish_date, description")
    }

    func testShouldBeAbleToHandleMixedContent() {
        XCTAssertEqual(xml!["root"]["header"].xmlElement?.text, "header mixed contentmore mixed content")
    }

    func testShouldBeAbleToIterateOverMixedContent() {
        let mixedContentXml = "<html><body><p>mixed content <i>iteration</i> support</body></html>"
        let parsed = SWXMLHash.parse(mixedContentXml)
        let element = parsed["html"]["body"]["p"].xmlElement
        XCTAssertNotNil(element)
        if let element = element {
            let result = element.children.reduce("") { acc, child in
                switch child {
                case let elm as SWXMLHash.XMLElement:
                    guard let text = elm.text else { return acc }
                    return acc + text
                case let elm as TextElement:
                    return acc + elm.text
                default:
                    XCTAssert(false, "Unknown element type")
                    return acc
                }
            }

            XCTAssertEqual(result, "mixed content iteration support")
        }
    }

    func testShouldBeAbleToRecursiveOutputTextContent() {
        let mixedContentXmlInputs = [
            // From SourceKit cursor info key.annotated_decl
            "<Declaration>typealias SomeHandle = <Type usr=\"s:Su\">UInt</Type></Declaration>",
            "<Declaration>var points: [<Type usr=\"c:objc(cs)Location\">Location</Type>] { get set }</Declaration>",
            // From SourceKit cursor info key.fully_annotated_decl
            "<decl.typealias><syntaxtype.keyword>typealias</syntaxtype.keyword> <decl.name>SomeHandle</decl.name> = <ref.struct usr=\"s:Su\">UInt</ref.struct></decl.typealias>",
            "<decl.var.instance><syntaxtype.keyword>var</syntaxtype.keyword> <decl.name>points</decl.name>: <decl.var.type>[<ref.class usr=\"c:objc(cs)Location\">Location</ref.class>]</decl.var.type> { <syntaxtype.keyword>get</syntaxtype.keyword> <syntaxtype.keyword>set</syntaxtype.keyword> }</decl.var.instance>",
            "<decl.function.method.instance><syntaxtype.keyword>fileprivate</syntaxtype.keyword> <syntaxtype.keyword>func</syntaxtype.keyword> <decl.name>documentedMemberFunc</decl.name>()</decl.function.method.instance>"
        ]

        let recursiveTextOutputs = [
            "typealias SomeHandle = UInt",
            "var points: [Location] { get set }",

            "typealias SomeHandle = UInt",
            "var points: [Location] { get set }",
            "fileprivate func documentedMemberFunc()"
        ]

        for (index, mixedContentXml) in mixedContentXmlInputs.enumerated() {
            XCTAssertEqual(SWXMLHash.parse(mixedContentXml).xmlElement!.recursiveText, recursiveTextOutputs[index])
        }
    }

    func testShouldHandleInterleavingXMLElements() {
        let interleavedXml = "<html><body><p>one</p><div>two</div><p>three</p><div>four</div></body></html>"
        let parsed = SWXMLHash.parse(interleavedXml)

        let result = parsed["html"]["body"].children.map({ $0.xmlElement!.text! }).joined(separator: ", ")
        XCTAssertEqual(result, "one, two, three, four")
    }

    func testShouldBeAbleToProvideADescriptionForTheDocument() {
        let descriptionXml = "<root><foo><what id=\"myId\">puppies</what></foo></root>"
        let parsed = SWXMLHash.parse(descriptionXml)

        XCTAssertEqual(parsed.description, "<root><foo><what id=\"myId\">puppies</what></foo></root>")
    }

    // error handling

    func testShouldReturnNilWhenKeysDontMatch() {
        XCTAssertNil(xml!["root"]["what"]["header"]["foo"].xmlElement?.name)
    }

    func testShouldProvideAnErrorObjectWhenKeysDontMatch() {
        var err: IndexingError?
        defer {
            XCTAssertNotNil(err)
        }
        do {
            let _ = try xml!.byKey("root").byKey("what").byKey("header").byKey("foo")
        } catch let error as IndexingError {
            err = error
        } catch { err = nil }
    }

    func testShouldProvideAnErrorElementWhenIndexersDontMatch() {
        var err: IndexingError?
        defer {
            XCTAssertNotNil(err)
        }
        do {
            let _ = try xml!.byKey("what").byKey("subelement").byIndex(5).byKey("nomatch")
        } catch let error as IndexingError {
            err = error
        } catch { err = nil }
    }

    func testShouldStillReturnErrorsWhenAccessingViaSubscripting() {
        var err: IndexingError? = nil
        switch xml!["what"]["subelement"][5]["nomatch"] {
        case .xmlError(let error):
            err = error
        default:
            err = nil
        }
        XCTAssertNotNil(err)
    }
}

extension XMLParsingTests {
    static var allTests: [(String, (XMLParsingTests) -> () throws -> Void)] {
        return [
            ("testShouldBeAbleToParseIndividualElements", testShouldBeAbleToParseIndividualElements),
            ("testShouldBeAbleToParseElementGroups", testShouldBeAbleToParseElementGroups),
            ("testShouldBeAbleToParseAttributes", testShouldBeAbleToParseAttributes),
            ("testShouldBeAbleToLookUpElementsByNameAndAttribute", testShouldBeAbleToLookUpElementsByNameAndAttribute),
            ("testShouldBeAbleToIterateElementGroups", testShouldBeAbleToIterateElementGroups),
            ("testShouldBeAbleToIterateElementGroupsEvenIfOnlyOneElementIsFound", testShouldBeAbleToIterateElementGroupsEvenIfOnlyOneElementIsFound),
            ("testShouldBeAbleToIndexElementGroupsEvenIfOnlyOneElementIsFound", testShouldBeAbleToIndexElementGroupsEvenIfOnlyOneElementIsFound),
            ("testShouldBeAbleToIterateUsingForIn", testShouldBeAbleToIterateUsingForIn),
            ("testShouldBeAbleToEnumerateChildren", testShouldBeAbleToEnumerateChildren),
            ("testShouldBeAbleToHandleMixedContent", testShouldBeAbleToHandleMixedContent),
            ("testShouldBeAbleToIterateOverMixedContent", testShouldBeAbleToIterateOverMixedContent),
            ("testShouldBeAbleToRecursiveOutputTextContent", testShouldBeAbleToRecursiveOutputTextContent),
            ("testShouldHandleInterleavingXMLElements", testShouldHandleInterleavingXMLElements),
            ("testShouldBeAbleToProvideADescriptionForTheDocument", testShouldBeAbleToProvideADescriptionForTheDocument),
            ("testShouldReturnNilWhenKeysDontMatch", testShouldReturnNilWhenKeysDontMatch),
            ("testShouldProvideAnErrorObjectWhenKeysDontMatch", testShouldProvideAnErrorObjectWhenKeysDontMatch),
            ("testShouldProvideAnErrorElementWhenIndexersDontMatch", testShouldProvideAnErrorElementWhenIndexersDontMatch),
            ("testShouldStillReturnErrorsWhenAccessingViaSubscripting", testShouldStillReturnErrorsWhenAccessingViaSubscripting)
        ]
    }
}
