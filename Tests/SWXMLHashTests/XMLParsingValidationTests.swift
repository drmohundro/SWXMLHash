//
//  XMLParsingValidationTests.swift
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

extension BasicItem {
    func validate() throws {
       if price < 0 { throw BasicItemValidation.priceOutOfBounds(price) }
   }
}

struct XMLParsingValidationTests {
    let xmlToParseOOB = """
        <root>
          <string>the string value</string>
          <int>100</int>
          <double>100.45</double>
          <float>44.12</float>
          <bool1>0</bool1>
          <bool2>true</bool2>
          <empty></empty>
          <basicItem id="1234">
            <name>the name of basic item</name>
            <price>-99.14</price>
          </basicItem>
          <attr string=\"stringValue\" int=\"200\" double=\"200.15\" float=\"205.42\" bool1=\"0\" bool2=\"true\"/>
          <attributeItem name=\"the name of attribute item\" price=\"19.99\"/>
        </root>
"""
    let xmlToParseIB = """
        <root>
          <string>the string value</string>
          <int>100</int>
          <double>100.45</double>
          <float>44.12</float>
          <bool1>0</bool1>
          <bool2>true</bool2>
          <empty></empty>
          <basicItem id="1234">
            <name>the name of basic item</name>
            <price>99.14</price>
          </basicItem>
          <attr string=\"stringValue\" int=\"200\" double=\"200.15\" float=\"205.42\" bool1=\"0\" bool2=\"true\"/>
          <attributeItem name=\"the name of attribute item\" price=\"19.99\"/>
        </root>
"""

    @Test
    func validatePriceOutOfBounds() {
        do {
            let xml = XMLHash.parse(xmlToParseOOB)
            let _: BasicItem = try xml["root"]["basicItem"].value()
            Issue.record("Unexpected lack of exception.")
        } catch BasicItemValidation.priceOutOfBounds(let price) {
            #expect(price == -99.14, "Unexpected price.")
        } catch {
            Issue.record("Unexpected exception.")
        }
    }

    @Test
    func validatePriceInBounds() {
        do {
            let xml = XMLHash.parse(xmlToParseIB)
            let value: BasicItem = try xml["root"]["basicItem"].value()
            #expect(value.price == 99.14, "Unexpected price.")
        } catch BasicItemValidation.priceOutOfBounds(let price) {
            Issue.record("Unexpected BasicItemValidation, the value of \(price) should be valid.")
        } catch {
            Issue.record("Unexpected exception.")
        }
    }
}
