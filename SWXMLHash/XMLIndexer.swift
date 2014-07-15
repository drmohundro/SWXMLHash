//
//  XMLIndexer.swift
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

enum XMLIndexer {
    case Element(XMLElement)
    case List(Array<XMLElement>)
    case Error(NSError)

    var element: XMLElement? {
    get {
        switch self {
        case .Element(let elem):
            return elem
        default:
            return nil
        }
    }
    }

    var all: Array<XMLIndexer> {
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

    init(_ rawObject: AnyObject) {
        switch rawObject {
        case let value as XMLElement:
            self = .Element(value)
        default:
            self = .Error(NSError(domain: "SWXMLDomain", code: 1000, userInfo: nil))
        }
    }

    subscript(key: String) -> XMLIndexer {
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

    subscript(index: Int) -> XMLIndexer {
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