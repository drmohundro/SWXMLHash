//
//  SWXMLHash.swift
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

import Foundation

public class SWXMLHash : NSObject, NSXMLParserDelegate {
    var parsingElement: String = ""

    public override init() {
        currentNode = root
        super.init()
    }

    var lastResults: String = ""

    var root = XMLElement(name: "root")
    var currentNode: XMLElement
    var parentStack = [XMLElement]()

    public func parse(xml: NSString) -> XMLIndexer {
        return parse((xml as NSString).dataUsingEncoding(NSUTF8StringEncoding))
    }

    public func parse(data: NSData) -> XMLIndexer {
        // clear any prior runs of parse... expected that this won't be necessary, but you never know
        parentStack.removeAll(keepCapacity: false)
        root = XMLElement(name: "root")

        parentStack.append(root)

        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()

        return XMLIndexer(root)
    }

    public func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName: String!, attributes attributeDict: NSDictionary!) {

        self.parsingElement = elementName

        currentNode = parentStack[parentStack.count - 1].addElement(elementName, withAttributes: attributeDict)
        parentStack.append(currentNode)

        lastResults = ""
    }

    public func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        lastResults += string
    }

    public func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if !lastResults.isEmpty {
            currentNode.text = lastResults
        }

        parentStack.removeLast()
    }
}

public enum XMLIndexer {
    case Element(XMLElement)
    case List([XMLElement])
    case Error(NSError)

    public var element: XMLElement? {
    get {
        switch self {
        case .Element(let elem):
            return elem
        default:
            return nil
        }
    }
    }

    public var all: [XMLIndexer] {
    get {
        switch self {
        case .List(let list):
            var xmlList = [XMLIndexer]()
            for elem in list {
                xmlList.append(XMLIndexer(elem))
            }
            return xmlList
        default:
            return []
        }
    }
    }

    public init(_ rawObject: AnyObject) {
        switch rawObject {
        case let value as XMLElement:
            self = .Element(value)
        default:
            self = .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: nil))
        }
    }

    public subscript(key: String) -> XMLIndexer {
        get {
            let userInfo = [NSLocalizedDescriptionKey: "XML Element Error: Incorrect key [\"\(key)\"]"]
            switch self {
            case .Element(let elem):
                if let match = elem.elements[key] {
                    if match.count == 1 {
                        return .Element(match[0])
                    }
                    else {
                        return .List(match)
                    }
                }
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            default:
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            }
        }
    }

    public subscript(index: Int) -> XMLIndexer {
        get {
            let userInfo = [NSLocalizedDescriptionKey: "XML Element Error: Incorrect index [\"\(index)\"]"]
            switch self {
            case .List(let list):
                if index <= list.count {
                    return .Element(list[index])
                }
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            default:
                return .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo))
            }
        }
    }
}

extension XMLIndexer: BooleanType {
    public var boolValue: Bool {
        get {
            switch self {
            case .Error:
                return false
            default:
                return true
            }
        }
    }
}

public class XMLElement {
    public var text: String?
    public let name: String
    var elements = [String:[XMLElement]]()
    public var attributes = [String:String]()

    public init(name: String) {
        self.name = name
    }

    func addElement(name: String, withAttributes attributes: NSDictionary) -> XMLElement {
        let element = XMLElement(name: name)

        if var group = elements[name] {
            group.append(element)
            elements[name] = group
        }
        else {
            elements[name] = [element]
        }

        for (keyAny,valueAny) in attributes {
            let key = keyAny as String
            let value = valueAny as String
            element.attributes[key] = value
        }

        return element
    }
}