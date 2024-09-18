//
//  LazyTypesConversionTests.swift
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

@Suite("LazyTypesConversionTests")
struct LazyTypesConversionTests {
    var parser: XMLIndexer?
    let xmlWithBasicTypes = """
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
          <attribute int=\"1\"/>
        </root>
    """

    init() {
        parser = XMLHash.config { cfg in cfg.shouldProcessLazily = true }.parse(xmlWithBasicTypes)
    }

    @Test
    func shouldConvertValueToNonOptional() {
        do {
            let value: String = try parser!["root"]["string"].value()
            #expect(value == "the string value")
        } catch {
            Issue.record(error)
        }
    }

    @Test
    func shouldConvertAttributeToNonOptional() {
        do {
            let value: Int = try parser!["root"]["attribute"].value(ofAttribute: "int")
            #expect(value == 1)
        } catch {
            Issue.record(error)
        }
    }

    @Test
    func shouldBeAbleToGetUserInfoDuringDeserialization() {
        let parser = XMLHash.config { config in
            let options = SampleUserInfo(apiVersion: .v1)
            config.userInfo = [ SampleUserInfo.key: options ]
        }.parse(xmlWithBasicTypes)

        do {
            let value: BasicItem = try parser["root"]["basicItem"].value()
            #expect(value.name == "the name of basic item (v1)")
        } catch {
            Issue.record(error)
        }
    }
}
