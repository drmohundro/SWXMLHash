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

extension XMLIndexerDeserializable {
    static func deserialize(element: XMLIndexer) throws -> Self {
        throw XMLDeserializationError.MissingDeserializationMethod(method: "XMLIndexerDeserializable.deserialize(element: XMLIndexer)")
    }
}


// MARK: - XMLElementDeserializable

public protocol XMLElementDeserializable {
    static func deserialize(element: XMLElement) throws -> Self
}

extension XMLElementDeserializable {
    static func deserialize(element: XMLElement) throws -> Self {
        throw XMLDeserializationError.MissingDeserializationMethod(method: "XMLElementDeserializable.deserialize(element: XMLElement)")
    }
}


public extension XMLIndexer {
    
    // MARK: - XMLElementDeserializable
    
    func value<T: XMLElementDeserializable>() throws -> T {
        switch self {
        case .Element(let element):
            return try T.deserialize(element)
        default:
            throw XMLDeserializationError.InvalidNode(node: self)
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
            throw XMLDeserializationError.InvalidNode(node: self)
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
            return []
        }
    }
    
    func value<T: XMLIndexerDeserializable>() throws -> [T]? {
        switch self {
        case .List(let elements):
            return try elements.map { try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map { try T.deserialize( XMLIndexer($0) ) }
        default:
            return nil
        }
    }
    
    func value<T: XMLIndexerDeserializable>() throws -> [T?] {
        switch self {
        case .List(let elements):
            return try elements.map{  try T.deserialize( XMLIndexer($0) ) }
        case .Element(let element):
            return try [element].map{ try T.deserialize( XMLIndexer($0) ) }
        default:
            return []
        }
    }
}

private extension XMLElement {
    func nonEmptyTextOrThrow() throws -> String {
        if let text = self.text where text.characters.count > 0 {
            return text
        } else { throw XMLDeserializationError.EmptyNodeValue }
    }
}

public enum XMLDeserializationError: ErrorType, CustomStringConvertible {
    case InvalidNode(node: XMLIndexer)
    case InvalidElement(element: XMLElement)
    case TypeConversion(type: String, element: XMLElement)
    case EmptyNodeValue
    case MissingDeserializationMethod(method: String)
    
    public var description: String {
        switch self {
        case .InvalidNode(let node):
            return "Invalid node: \(node)"
        case .InvalidElement(let element):
            return "Invalid element: \(element)"
        case .TypeConversion(let type, let node):
            return "Can't convert \(node) to \(type)"
        case .EmptyNodeValue:
            return "Empty node value"
        case .MissingDeserializationMethod(let method):
            return "Missing deserialization method: \(method)"
        }
    }
}


// MARK: - Common types deserialization

extension String: XMLElementDeserializable {
    public static func deserialize(element: XMLElement) throws -> String {
        guard let text = element.text
        else { throw XMLDeserializationError.TypeConversion(type: "String", element: element) }
        return text
    }
}

extension Int: XMLElementDeserializable {
    public static func deserialize(element: XMLElement) throws -> Int {
        guard let value = Int(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversion(type: "Int", element: element) }
        return value
    }
}

extension Double: XMLElementDeserializable {
    public static func deserialize(element: XMLElement) throws -> Double {
        guard let value = Double(try element.nonEmptyTextOrThrow())
        else { throw XMLDeserializationError.TypeConversion(type: "Double", element: element) }
        return value
    }
}
