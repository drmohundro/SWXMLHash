//
//  SWXMLHash+TypeConversion.swift
//  SWXMLHash
//
//  Created by Maciek Grzybowski on 29.02.2016.
//
//

import Foundation

// MARK: - XMLIndexerDeserializable

/// Provides XMLIndexer deserialization / type transformation support
public protocol XMLIndexerDeserializable {
    static func deserialize(element: XMLIndexer) throws -> Self
}

/// Provides XMLIndexer deserialization / type transformation support
public extension XMLIndexerDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLIndexer to be deserialized
    - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(element: XMLIndexer) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLIndexerDeserializable.deserialize(element: XMLIndexer)")
    }
}


// MARK: - XMLElementDeserializable

/// Provides XMLElement deserialization / type transformation support
public protocol XMLElementDeserializable {
    static func deserialize(element: XMLElement) throws -> Self
}

/// Provides XMLElement deserialization / type transformation support
public extension XMLElementDeserializable {
    /**
    A default implementation that will throw an error if it is called

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.ImplementationIsMissing if no implementation is found
    - returns: this won't ever return because of the error being thrown
    */
    static func deserialize(element: XMLElement) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(
            method: "XMLElementDeserializable.deserialize(element: XMLElement)")
    }
}


public extension XMLIndexer {

    // MARK: - XMLElementDeserializable

    /**
    Attempts to deserialize the current XMLElement element to `T`

    - throws: an XMLDeserializationError.NodeIsInvalid if the current indexed level isn't an Element
    - returns: the deserialized `T` value
    */
    func value<T: XMLElementDeserializable>() throws -> T {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        case .Stream(let opStream):
            return try! opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLElement element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLElementDeserializable>() throws -> T? {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        case .Stream(let opStream):
            return try! opStream.findElements().value()
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
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try! opStream.findElements().value()
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
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try! opStream.findElements().value()
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
        case .List(let elements):
            return try elements.map { try T.deserialize($0) }
        case .Element(let element):
            return try [element].map { try T.deserialize($0) }
        case .Stream(let opStream):
            return try! opStream.findElements().value()
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
        case .Element:
            return try T.deserialize(self)
        case .Stream(let opStream):
            return try! opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `T?`

    - returns: the deserialized `T?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> T? {
        switch self {
        case .Element:
            return try T.deserialize(self)
        case .Stream(let opStream):
            return try! opStream.findElements().value()
        default:
            return nil
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]`

    - returns: the deserialized `[T]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T where T: XMLIndexerDeserializable>() throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try! opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T]?`

    - returns: the deserialized `[T]?` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try! opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }

    /**
    Attempts to deserialize the current XMLIndexer element to `[T?]`

    - returns: the deserialized `[T?]` value
    - throws: an XMLDeserializationError is there is a problem with deserialization
    */
    func value<T: XMLIndexerDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map {  try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        case .Stream(let opStream):
            return try! opStream.findElements().value()
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
}

private extension XMLElement {
    func nonEmptyTextOrThrow() throws -> String {
        if let text = self.text where !text.characters.isEmpty {
            return text
        } else { throw XMLDeserializationError.NodeHasNoValue }
    }
}

/// The error that is thrown if there is a problem with deserialization
public enum XMLDeserializationError: ErrorType, CustomStringConvertible {
    case ImplementationIsMissing(method: String)
    case NodeIsInvalid(node: XMLIndexer)
    case NodeHasNoValue
    case TypeConversionFailed(type: String, element: XMLElement)

    /// The text description for the error thrown
    public var description: String {
        switch self {
        case .ImplementationIsMissing(let method):
            return "This deserialization method is not implemented: \(method)"
        case .NodeIsInvalid(let node):
            return "This node is invalid: \(node)"
        case .NodeHasNoValue:
            return "This node is empty"
        case .TypeConversionFailed(let type, let node):
            return "Can't convert node \(node) to value of type \(type)"
        }
    }
}


// MARK: - Common types deserialization

extension String: XMLElementDeserializable {
    /**
    Attempts to deserialize XML element content to a String

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized String value
    */
    public static func deserialize(element: XMLElement) throws -> String {
        guard let text = element.text
        else {
            throw XMLDeserializationError.TypeConversionFailed(type: "String", element: element)
        }
        return text
    }
}

extension Int: XMLElementDeserializable {
    /**
    Attempts to deserialize XML element content to a Int

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Int value
    */
    public static func deserialize(element: XMLElement) throws -> Int {
        guard let value = Int(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversionFailed(type: "Int", element: element) }
        return value
    }
}

extension Double: XMLElementDeserializable {
    /**
    Attempts to deserialize XML element content to a Double

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Double value
    */
    public static func deserialize(element: XMLElement) throws -> Double {
        guard let value = Double(try element.nonEmptyTextOrThrow())
        else {
            throw XMLDeserializationError.TypeConversionFailed(type: "Double", element: element)
        }
        return value
    }
}

extension Float: XMLElementDeserializable {
    /**
    Attempts to deserialize XML element content to a Float

    - parameters:
        - element: the XMLElement to be deserialized
    - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
    - returns: the deserialized Float value
    */
    public static func deserialize(element: XMLElement) throws -> Float {
        guard let value = Float(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversionFailed(type: "Float", element: element) }
        return value
    }
}

extension Bool: XMLElementDeserializable {
    /**
     Attempts to deserialize XML element content to a Bool. This uses NSString's 'boolValue' described
     [here](https://developer.apple.com/library/mac/documentation/Cocoa/Reference/Foundation/Classes/NSString_Class/#//apple_ref/occ/instp/NSString/boolValue)

     - parameters:
     - element: the XMLElement to be deserialized
     - throws: an XMLDeserializationError.TypeConversionFailed if the element cannot be deserialized
     - returns: the deserialized Bool value
     */
    public static func deserialize(element: XMLElement) throws -> Bool {
        let value = Bool(NSString(string: try element.nonEmptyTextOrThrow()).boolValue)
        return value
    }
}
