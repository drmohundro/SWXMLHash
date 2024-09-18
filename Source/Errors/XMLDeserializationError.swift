//
//  XMLDeserializationError.swift
//  SWXMLHash
//
//  Copyright (c) 2016 Maciek Grzybowskio, 2022 David Mohundro
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

/// The error that is thrown if there is a problem with deserialization
public enum XMLDeserializationError: Error {
    case implementationIsMissing(method: String)
    case nodeIsInvalid(node: String)
    case nodeHasNoValue
    case typeConversionFailed(type: String, element: XMLElementSendable)
    case attributeDoesNotExist(element: XMLElementSendable, attribute: String)
    case attributeDeserializationFailed(type: String, attribute: XMLAttribute)
}

/// Implementation for CustomStringConvertible
extension XMLDeserializationError: CustomStringConvertible {
    /// The text description for the error thrown
    public var description: String {
        switch self {
        case .implementationIsMissing(let method):
            return "This deserialization method is not implemented: \(method)"
        case .nodeIsInvalid(let node):
            return "This node is invalid: \(node)"
        case .nodeHasNoValue:
            return "This node is empty"
        case let .typeConversionFailed(type, node):
            return "Can't convert node \(node) to value of type \(type)"
        case let .attributeDoesNotExist(element, attribute):
            return "Element \(element) does not contain attribute: \(attribute)"
        case let .attributeDeserializationFailed(type, attribute):
            return "Can't convert attribute \(attribute) to value of type \(type)"
        }
    }
}

/// Implementation for LocalizedError
extension XMLDeserializationError: LocalizedError {
    /// The textual error description for the error
    public var errorDescription: String? {
        switch self {
        case .implementationIsMissing(let method):
            return "This deserialization method is not implemented: \(method)"
        case .nodeIsInvalid(let node):
            return "This node is invalid: \(node)"
        case .nodeHasNoValue:
            return "This node is empty"
        case let .typeConversionFailed(type, node):
            return "Can't convert node \(node) to value of type \(type)"
        case let .attributeDoesNotExist(element, attribute):
            return "Element \(element) does not contain attribute: \(attribute)"
        case let .attributeDeserializationFailed(type, attribute):
            return "Can't convert attribute \(attribute) to value of type \(type)"
        }
    }
}
