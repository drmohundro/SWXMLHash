//
//  XMLHash.swift
//  SWXMLHash
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
//

import Foundation
#if canImport(FoundationXML)
import FoundationXML
#endif

let rootElementName = "SWXMLHash_Root_Element"

/// Simple XML parser
public class XMLHash {
    let options: XMLHashOptions

    private init(_ options: XMLHashOptions = XMLHashOptions()) {
        self.options = options
    }

    /**
    Method to configure how parsing works.

    - parameters:
        - configAction: a block that passes in an `XMLHashOptions` object with
        options to be set
    - returns: an `XMLHash` instance
    */
    class public func config(_ configAction: (XMLHashOptions) -> Void) -> XMLHash {
        let opts = XMLHashOptions()
        configAction(opts)
        return XMLHash(opts)
    }

    /**
    Begins parsing the passed in XML string.

    - parameters:
        - xml: an XML string. __Note__ that this is not a URL but a
        string containing XML.
    - returns: an `XMLIndexer` instance that can be iterated over
    */
    public func parse(_ xml: String) -> XMLIndexer {
        guard let data = xml.data(using: options.encoding) else {
            return .xmlError(.encoding)
        }
        return parse(data)
    }

    /**
    Begins parsing the passed in XML string.

    - parameters:
        - data: a `Data` instance containing XML
        - returns: an `XMLIndexer` instance that can be iterated over
    */
    public func parse(_ data: Data) -> XMLIndexer {
        let parser: SimpleXmlParser = options.shouldProcessLazily
            ? LazyXMLParser(options)
            : FullXMLParser(options)
        return parser.parse(data)
    }

    /**
    Method to parse XML passed in as a string.

    - parameter xml: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func parse(_ xml: String) -> XMLIndexer {
        XMLHash().parse(xml)
    }

    /**
    Method to parse XML passed in as a Data instance.

    - parameter data: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func parse(_ data: Data) -> XMLIndexer {
        XMLHash().parse(data)
    }

    /**
    Method to lazily parse XML passed in as a string.

    - parameter xml: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func lazy(_ xml: String) -> XMLIndexer {
        config { conf in conf.shouldProcessLazily = true }.parse(xml)
    }

    /**
    Method to lazily parse XML passed in as a Data instance.

    - parameter data: The XML to be parsed
    - returns: An XMLIndexer instance that is used to look up elements in the XML
    */
    class public func lazy(_ data: Data) -> XMLIndexer {
        config { conf in conf.shouldProcessLazily = true }.parse(data)
    }
}

protocol SimpleXmlParser {
    init(_ options: XMLHashOptions)
    func parse(_ data: Data) -> XMLIndexer
}

#if os(Linux)

extension XMLParserDelegate {
    func parserDidStartDocument(_ parser: XMLParser) { }
    func parserDidEndDocument(_ parser: XMLParser) { }

    func parser(_ parser: XMLParser,
                foundNotationDeclarationWithName name: String,
                publicID: String?,
                systemID: String?) { }

    func parser(_ parser: XMLParser,
                foundUnparsedEntityDeclarationWithName name: String,
                publicID: String?,
                systemID: String?,
                notationName: String?) { }

    func parser(_ parser: XMLParser,
                foundAttributeDeclarationWithName attributeName: String,
                forElement elementName: String,
                type: String?,
                defaultValue: String?) { }

    func parser(_ parser: XMLParser,
                foundElementDeclarationWithName elementName: String,
                model: String) { }

    func parser(_ parser: XMLParser,
                foundInternalEntityDeclarationWithName name: String,
                value: String?) { }

    func parser(_ parser: XMLParser,
                foundExternalEntityDeclarationWithName name: String,
                publicID: String?,
                systemID: String?) { }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) { }

    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) { }

    func parser(_ parser: XMLParser,
                didStartMappingPrefix prefix: String,
                toURI namespaceURI: String) { }

    func parser(_ parser: XMLParser,
                didEndMappingPrefix prefix: String) { }

    func parser(_ parser: XMLParser,
                foundCharacters string: String) { }

    func parser(_ parser: XMLParser,
                foundIgnorableWhitespace whitespaceString: String) { }

    func parser(_ parser: XMLParser,
                foundProcessingInstructionWithTarget target: String,
                data: String?) { }

    func parser(_ parser: XMLParser,
                foundComment comment: String) { }

    func parser(_ parser: XMLParser,
                foundCDATA CDATABlock: Data) { }

    func parser(_ parser: XMLParser,
                resolveExternalEntityName name: String,
                systemID: String?) -> Data? { nil }

    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) { }

    func parser(_ parser: XMLParser,
                validationErrorOccurred validationError: Error) { }
}

#endif
