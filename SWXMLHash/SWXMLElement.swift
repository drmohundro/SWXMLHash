//
//  SWXMLElement.swift
//  SWXMLHash
//
//  Created by David Mohundro on 7/8/14.
//
//

import UIKit

class SWXMLElement {
    var elements = Dictionary<String, Array<SWXMLElement>>()

    var error: NSError?
    var text: String?
    let name: String

    init(name: String) {
        self.name = name
    }

    func addElement(name: String) -> SWXMLElement {
        let element = SWXMLElement(name: name)

        if var group = elements[name] {
            group.append(element)
            elements[name] = group
        }
        else {
            elements[name] = [element]
        }

        return element
    }

    subscript(key: String) -> SWXMLElement {
        get {
            if elements[key] {
                return elements[key]![0]
            }
            return SWXMLElement.errorElementFor(self, withKey: key)
        }
    }

    func group(key: String) -> Array<SWXMLElement> {
        if elements[key] {
            return elements[key]!
        }
        return [SWXMLElement.errorElementFor(self, withKey: key)]
    }

    class func errorElementFor(parentElement: SWXMLElement, withKey mismatchedKey: String) -> SWXMLElement {
        let userInfo = [
            NSLocalizedDescriptionKey: "XML Element Error: Incorrect element \"\(mismatchedKey)\"",
            "MismatchedKey": mismatchedKey,
            "ParentElement": parentElement
        ]
        userInfo["parentElement"]
        let error = NSError(domain: "SWXMLDomain", code: 1000, userInfo: userInfo)
        let errorElem = SWXMLElement(name: "error")
        errorElem.error = error
        return errorElem
    }
}