//
//  WhiteSpaceParsingTests.swift
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

import Foundation
import SWXMLHash
import XCTest

// swiftlint:disable line_length
// swiftlint:disable force_try

class WhiteSpaceParsingTests: XCTestCase {
    var xml: XMLIndexer?

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
#if SWIFT_PACKAGE
        let path = NSString.path(withComponents: NSString(string: #file).pathComponents.dropLast() + ["test.xml"])
#else
        let bundle = Bundle(for: WhiteSpaceParsingTests.self)
        let path = bundle.path(forResource: "test", ofType: "xml")!
#endif
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        xml = SWXMLHash.parse(data)
    }

    // issue #6
    func testShouldBeAbleToPullTextBetweenElementsWithoutWhitespace() {
        XCTAssertEqual(xml!["niotemplate"]["section"][0]["constraint"][1].element?.text, "H:|-15-[title]-15-|")
    }

    func testShouldBeAbleToCorrectlyParseCDATASectionsWithWhitespace() {
        XCTAssertEqual(xml!["niotemplate"]["other"].element?.text, "\n        \n  this\n  has\n  white\n  space\n        \n    ")
    }
}

extension WhiteSpaceParsingTests {
    static var allTests: [(String, (WhiteSpaceParsingTests) -> () throws -> Void)] {
        return [
            ("testShouldBeAbleToPullTextBetweenElementsWithoutWhitespace", testShouldBeAbleToPullTextBetweenElementsWithoutWhitespace),
            ("testShouldBeAbleToCorrectlyParseCDATASectionsWithWhitespace", testShouldBeAbleToCorrectlyParseCDATASectionsWithWhitespace)
        ]
    }
}
