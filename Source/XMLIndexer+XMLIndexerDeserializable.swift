//
//  XMLHash+TypeConversion.swift
//  SWXMLHash
//
//  Copyright (c) 2016 Maciek Grzybowskio
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

// swiftlint:disable line_length
// swiftlint:disable file_length

import Foundation

// MARK: - XMLIndexerDeserializable

/// Provides XMLIndexer deserialization / type transformation support
public protocol XMLIndexerDeserializable {
    /// Method for deserializing elements from XMLIndexer
    static func deserialize(_ element: XMLIndexer) throws -> Self
    /// Method for validating elements post deserialization
    func validate() throws
}

/// Provides XMLIndexer deserialization / type transformation support
public extension XMLIndexerDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLIndexer to be deserialized
    - throws: an XMLDeserializationError.implementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(_ element: XMLIndexer) throws -> Self {
        throw XMLDeserializationError.implementationIsMissing(
            method: "XMLIndexerDeserializable.deserialize(element: XMLIndexer)")
    }

    /**
    A default do nothing implementation of validation.
    - throws: nothing
    */
    func validate() throws {}
}

// MARK: - XMLElementDeserializable

/// Provides XMLElement deserialization / type transformation support
public protocol XMLElementDeserializable {
    /// Method for deserializing elements from XMLElement
    static func deserialize(_ element: XMLElement) throws -> Self
    /// Method for validating elements from XMLElement post deserialization
    func validate() throws
}

/// Provides XMLElement deserialization / type transformation support
public extension XMLElementDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.implementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(_ element: XMLElement) throws -> Self {
        throw XMLDeserializationError.implementationIsMissing(
            method: "XMLElementDeserializable.deserialize(element: XMLElement)")
    }

    /**
    A default do nothing implementation of validation.
    - throws: nothing
    */
    func validate() throws {}
}

// MARK: - XMLAttributeDeserializable

/// Provides XMLAttribute deserialization / type transformation support
public protocol XMLAttributeDeserializable {
    /// Method for deserializing elements from XMLAttribute
    static func deserialize(_ attribute: XMLAttribute) throws -> Self
    /// Method for validating elements from XMLAttribute post deserialization
    func validate() throws
}

/// Provides XMLAttribute deserialization / type transformation support
public extension XMLAttributeDeserializable {
    /**
     A default implementation that will throw an error if it is called

     - parameters:
         - attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.implementationIsMissing if no implementation is found
     - returns: this won't ever return because of the error being thrown
     */
    static func deserialize(attribute: XMLAttribute) throws -> Self {
        throw XMLDeserializationError.implementationIsMissing(
            method: "XMLAttributeDeserializable(element: XMLAttribute)")
    }
    /**
    A default do nothing implementation of validation.
    - throws: nothing
    */
    func validate() throws {}
}

// MARK: - XMLIndexer Extensions

public extension XMLIndexer {
    // MARK: - XMLAttributeDeserializable

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> T {
        switch self {
        case .element(let element):
            return try element.value(ofAttribute: attr)
        case .stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLAttribute \(attr) -> T")
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T?`

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) -> T? {
        switch self {
        case .element(let element):
            return element.value(ofAttribute: attr)
        case .stream(let opStream):
            return opStream.findElements().value(ofAttribute: attr)
        default:
            return nil
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T] {
        switch self {
        case .list(let elements):
            return try elements.map { try $0.value(ofAttribute: attr) }
        case .element(let element):
            return try [element].map { try $0.value(ofAttribute: attr) }
        case .stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLAttribute \(attr) -> [T]")
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]?`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]?` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T]? {
        switch self {
        case .list(let elements):
            return try elements.map { try $0.value(ofAttribute: attr) }
        case .element(let element):
            return try [element].map { try $0.value(ofAttribute: attr) }
        case .stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        default:
            return nil
        }
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T?]`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T?]` value
     */
    func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> [T?] {
        switch self {
        case .list(let elements):
            return elements.map { $0.value(ofAttribute: attr) }
        case .element(let element):
            return [element].map { $0.value(ofAttribute: attr) }
        case .stream(let opStream):
            return try opStream.findElements().value(ofAttribute: attr)
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLAttribute \(attr) -> [T?]")
        }
    }

    // MARK: - XMLElementDeserializable

    /**
    Attempts to deserialize the current XMLElement element to `T`

    - throws: an XMLDeserializationError.nodeIsInvalid if the current indexed level isn't an Element
    - returns: the deserialized `T` value
    */
    func value<T: XMLElementDeserializable>() throws -> T {
        switch self {
        case .element(let element):
            let deserialized = try T.deserialize(element)
            try deserialized.validate()
            return deserialized
        case .stream(let opStream):
            return try opStream.findElements().value()
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLElement -> T")
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> T? {
        switch self {
        case .element(let element):
            let deserialized = try T.deserialize(element)
            try deserialized.validate()
            return deserialized
        case .stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T] {
        switch self {
        case .list(let elements):
            return try elements.map {
                let deserialized = try T.deserialize($0)
                try deserialized.validate()
                return deserialized
            }
        case .element(let element):
            return try [element].map {
                let deserialized = try T.deserialize($0)
                try deserialized.validate()
                return deserialized
            }
        case .stream(let opStream):
            return try opStream.findElements().value()
        default:
            return []
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T]? {
        switch self {
        case .list(let elements):
            return try elements.map {
                let deserialized = try T.deserialize($0)
                try deserialized.validate()
                return deserialized
            }
        case .element(let element):
            return try [element].map {
                let deserialized = try T.deserialize($0)
                try deserialized.validate()
                return deserialized
            }
        case .stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> [T?] {
        switch self {
        case .list(let elements):
            return try elements.map {
                let deserialized = try T.deserialize($0)
                try deserialized.validate()
                return deserialized
            }
        case .element(let element):
            return try [element].map {
                let deserialized = try T.deserialize($0)
                try deserialized.validate()
                return deserialized
            }
        case .stream(let opStream):
            return try opStream.findElements().value()
        default:
            return []
        }
    }

    // MARK: - XMLIndexerDeserializable

    /**
    Attempts to deserialize the current XMLIndexer element to `T`

    - returns: the deserialized `T` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T {
        switch self {
        case .element:
            let deserialized = try T.deserialize(self)
            try deserialized.validate()
            return deserialized
        case .stream(let opStream):
            return try opStream.findElements().value()
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLIndexer -> T")
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T? {
        switch self {
        case .element:
            let deserialized = try T.deserialize(self)
            try deserialized.validate()
            return deserialized
        case .stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T>() throws -> [T] where T: XMLIndexerDeserializable {
        switch self {
        case .list(let elements):
            return try elements.map {
                let deserialized = try T.deserialize( XMLIndexer($0) )
                try deserialized.validate()
                return deserialized
            }
        case .element(let element):
            return try [element].map {
                let deserialized = try T.deserialize( XMLIndexer($0) )
                try deserialized.validate()
                return deserialized
            }
        case .stream(let opStream):
            return try opStream.findElements().value()
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLIndexer -> [T]")
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T]? {
        switch self {
        case .list(let elements):
            return try elements.map {
                let deserialized = try T.deserialize(XMLIndexer($0))
                try deserialized.validate()
                return deserialized
            }
        case .element(let element):
            return try [element].map {
                let deserialized = try T.deserialize(XMLIndexer($0))
                try deserialized.validate()
                return deserialized
            }
        case .stream(let opStream):
            return try opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T?] {
        switch self {
        case .list(let elements):
            return try elements.map {
                let deserialized = try T.deserialize(XMLIndexer($0))
                try deserialized.validate()
                return deserialized
            }
        case .element(let element):
            return try [element].map {
                let deserialized = try T.deserialize(XMLIndexer($0))
                try deserialized.validate()
                return deserialized
            }
        case .stream(let opStream):
            return try opStream.findElements().value()
        case .xmlError(let indexingError):
            throw XMLDeserializationError.nodeIsInvalid(node: indexingError.description)
        default:
            throw XMLDeserializationError.nodeIsInvalid(node: "Unexpected error deserializing XMLIndexer -> [T?]")
        }
    }
}

// MARK: - XMLAttributeDeserializable String RawRepresentable

/*: Provides XMLIndexer XMLAttributeDeserializable deserialization from String backed RawRepresentables
    Added by [PeeJWeeJ](https://github.com/PeeJWeeJ) */
public extension XMLIndexer {
    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T` using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A) throws -> T where A.RawValue == String {
        try value(ofAttribute: attr.rawValue)
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `T?` using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A) -> T? where A.RawValue == String {
        value(ofAttribute: attr.rawValue)
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]` using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]` value
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A) throws -> [T] where A.RawValue == String {
        try value(ofAttribute: attr.rawValue)
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T]?` using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T]?` value
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A) throws -> [T]? where A.RawValue == String {
        try value(ofAttribute: attr.rawValue)
    }

    /**
     Attempts to deserialize the value of the specified attribute of the current XMLIndexer
     element to `[T?]` using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `[T?]` value
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A) throws -> [T?] where A.RawValue == String {
        try value(ofAttribute: attr.rawValue)
    }
}

// MARK: - XMLElement Extensions

extension XMLElement {
    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T`

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    public func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) throws -> T {
        if let attr = self.attribute(by: attr) {
            let deserialized = try T.deserialize(attr)
            try deserialized.validate()
            return deserialized
        } else {
            throw XMLDeserializationError.attributeDoesNotExist(element: self, attribute: attr)
        }
    }

    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T?`

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist.
     */
    public func value<T: XMLAttributeDeserializable>(ofAttribute attr: String) -> T? {
        if let attr = self.attribute(by: attr) {
            let deserialized = try? T.deserialize(attr)
            if deserialized != nil { try? deserialized?.validate() }
            return deserialized
        } else {
            return nil
        }
    }

    /**
     Gets the text associated with this element, or throws an exception if the text is empty

     - throws: XMLDeserializationError.nodeHasNoValue if the element text is empty
     - returns: The element text
     */
    internal func nonEmptyTextOrThrow() throws -> String {
        let textVal = text
        if !textVal.isEmpty {
            return textVal
        }

        throw XMLDeserializationError.nodeHasNoValue
    }
}

// MARK: String RawRepresentable

/*: Provides XMLElement XMLAttributeDeserializable deserialization from String backed RawRepresentables
    Added by [PeeJWeeJ](https://github.com/PeeJWeeJ) */
public extension XMLElement {
    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T`
     using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - throws: an XMLDeserializationError if there is a problem with deserialization
     - returns: The deserialized `T` value
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A)  throws -> T where A.RawValue == String {
        try value(ofAttribute: attr.rawValue)
    }

    /**
     Attempts to deserialize the specified attribute of the current XMLElement to `T?`
     using a String backed RawRepresentable (E.g. `String` backed `enum` cases)

     - Note:
     Convenience for value(ofAttribute: String)

     - parameter attr: The attribute to deserialize
     - returns: The deserialized `T?` value, or nil if the attribute does not exist.
     */
    func value<T: XMLAttributeDeserializable, A: RawRepresentable>(ofAttribute attr: A) -> T? where A.RawValue == String {
        value(ofAttribute: attr.rawValue)
    }
}

/// The error that is thrown if there is a problem with deserialization
// MARK: - Common types deserialization

extension String: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a String

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.typeConversionFailed if the element cannot be deserialized
    - returns: the deserialized String value
    */
    public static func deserialize(_ element: XMLElement) -> String {
        element.text
    }

    /**
     Attempts to deserialize XML Attribute content to a String

     - parameter attribute: the XMLAttribute to be deserialized
     - returns: the deserialized String value
     */
    public static func deserialize(_ attribute: XMLAttribute) -> String {
        attribute.text
    }

    public func validate() {}
}

extension Int: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Int

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.typeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Int value
    */
    public static func deserialize(_ element: XMLElement) throws -> Int {
        guard let value = Int(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.typeConversionFailed(type: "Int", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to an Int

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.attributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Int value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Int {
        guard let value = Int(attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(
                type: "Int", attribute: attribute)
        }
        return value
    }

    public func validate() {}
}

extension Double: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Double

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.typeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Double value
    */
    public static func deserialize(_ element: XMLElement) throws -> Double {
        guard let value = Double(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.typeConversionFailed(type: "Double", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Double

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.attributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Double value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Double {
        guard let value = Double(attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(
                type: "Double", attribute: attribute)
        }
        return value
    }

    public func validate() {}
}

extension Float: XMLElementDeserializable, XMLAttributeDeserializable {
    /**
    Attempts to deserialize XML element content to a Float

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.typeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Float value
    */
    public static func deserialize(_ element: XMLElement) throws -> Float {
        guard let value = Float(try element.nonEmptyTextOrThrow()) else {
            throw XMLDeserializationError.typeConversionFailed(type: "Float", element: element)
        }
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Float

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.attributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Float value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Float {
        guard let value = Float(attribute.text) else {
            throw XMLDeserializationError.attributeDeserializationFailed(
                type: "Float", attribute: attribute)
        }
        return value
    }

    public func validate() {}
}

extension Bool: XMLElementDeserializable, XMLAttributeDeserializable {
    // swiftlint:disable line_length
    /**
     Attempts to deserialize XML element content to a Bool. This uses NSString's 'boolValue'
     described [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameters:
        - element: the XMLElement to be deserialized
     - throws: an XMLDeserializationError.typeConversionFailed if the element cannot be deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(_ element: XMLElement) throws -> Bool {
        let value = Bool(NSString(string: try element.nonEmptyTextOrThrow()).boolValue)
        return value
    }

    /**
     Attempts to deserialize XML attribute content to a Bool. This uses NSString's 'boolValue'
     described [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameter attribute: The XMLAttribute to be deserialized
     - throws: an XMLDeserializationError.attributeDeserializationFailed if the attribute cannot be
               deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(_ attribute: XMLAttribute) throws -> Bool {
        let value = Bool(NSString(string: attribute.text).boolValue)
        return value
    }
    // swiftlint:enable line_length

    public func validate() {}
}
