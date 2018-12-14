//
//  SWXMLHashConfigTests.swift
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

class SWXMLHashConfigTests: XCTestCase {
    var parser: XMLIndexer?
    let xmlWithNamespace = """
        <root xmlns:h=\"http://www.w3.org/TR/html4/\"
          xmlns:f=\"http://www.w3schools.com/furniture\">
          <h:table>
            <h:tr>
              <h:td>Apples</h:td>
              <h:td>Bananas</h:td>
            </h:tr>
          </h:table>
        </root>
    """

    override func setUp() {
        super.setUp()
        parser = SWXMLHash.config { conf in
            conf.shouldProcessNamespaces = true
        }.parse(xmlWithNamespace)
    }

    func testShouldAllowProcessingNamespacesOrNot() {
        XCTAssertEqual(parser!["root"]["table"]["tr"]["td"][0].element?.text, "Apples")
    }
}

extension SWXMLHashConfigTests {
    static var allTests: [(String, (SWXMLHashConfigTests) -> () throws -> Void)] {
        return [
            ("testShouldAllowProcessingNamespacesOrNot", testShouldAllowProcessingNamespacesOrNot)
        ]
    }
}
