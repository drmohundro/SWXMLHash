//
//  SWXMLHash+TypeConversion.swift
//  SWXMLHash
//
//  Created by Maciek Grzybowski on 29.02.2016.
//
//


// MARK: - XMLIndexerDeserializable

public protocol XMLIndexerDeserializable {
    static func deserialize(element: XMLIndexer) throws -> Self
}

public extension XMLIndexerDeserializable {
    static func deserialize(element: XMLIndexer) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(method: "XMLIndexerDeserializable.deserialize(element: XMLIndexer)")
    }
}


// MARK: - XMLElementDeserializable

public protocol XMLElementDeserializable {
    static func deserialize(element: XMLElement) throws -> Self
}

public extension XMLElementDeserializable {
    static func deserialize(element: XMLElement) throws -> Self {
        throw XMLDeserializationError.ImplementationIsMissing(method: "XMLElementDeserializable.deserialize(element: XMLElement)")
    }
}


public extension XMLIndexer {
    
    // MARK: - XMLElementDeserializable
    
    func value<T: XMLElementDeserializable>() throws -> T {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
    
    func value<T: XMLElementDeserializable>() throws -> T? {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        default:
            return nil
        }
    }
    
    func value<T: XMLElementDeserializable>() throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map{ try T.deserialize($0) }
        case .Element(let element):
            return try [element].map{ try T.deserialize($0) }
        default:
            return []
        }
    }
    
    func value<T: XMLElementDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map{ try T.deserialize($0) }
        case .Element(let element):
            return try [element].map{ try T.deserialize($0) }
        default:
            return nil
        }
    }
    
    func value<T: XMLElementDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map{ try T.deserialize($0) }
        case .Element(let element):
            return try [element].map{ try T.deserialize($0) }
        default:
            return []
        }
    }
    
    
    // MARK: - XMLIndexerDeserializable
    
    func value<T: XMLIndexerDeserializable>() throws -> T {
        switch self {
        case .Element:
            return try T.deserialize(self)
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
    
    func value<T: XMLIndexerDeserializable>() throws -> T? {
        switch self {
        case .Element:
            return try T.deserialize(self)
        default:
            return nil
        }
    }
    
    func value<T where T: XMLIndexerDeserializable>() throws -> [T] {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
    
    func value<T: XMLIndexerDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
    
    func value<T: XMLIndexerDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map{  try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map{ try T.deserialize( XMLIndexer($0) ) }
        default:
            throw XMLDeserializationError.NodeIsInvalid(node: self)
        }
    }
}

private extension XMLElement {
    func nonEmptyTextOrThrow() throws -> String {
        if let text = self.text where text.characters.count > 0 {
            return text
        } else { throw XMLDeserializationError.NodeHasNoValue }
    }
}

public enum XMLDeserializationError: ErrorType, CustomStringConvertible {
    case ImplementationIsMissing(method: String)
    case NodeIsInvalid(node: XMLIndexer)
    case NodeHasNoValue
    case TypeConversionFailed(type: String, element: XMLElement)
    
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
    public static func deserialize(element: XMLElement) throws -> String {
        guard let text = element.text
        else { throw XMLDeserializationError.TypeConversionFailed(type: "String", element: element) }
        return text
    }
}

extension Int: XMLElementDeserializable {
    public static func deserialize(element: XMLElement) throws -> Int {
        guard let value = Int(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversionFailed(type: "Int", element: element) }
        return value
    }
}

extension Double: XMLElementDeserializable {
    public static func deserialize(element: XMLElement) throws -> Double {
        guard let value = Double(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversionFailed(type: "Double", element: element) }
        return value
    }
}

extension Float: XMLElementDeserializable {
    public static func deserialize(element: XMLElement) throws -> Float {
        guard let value = Float(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversionFailed(type: "Float", element: element) }
        return value
    }
}
