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
            return elements[key]![0]
        }
    }

    func group(key: String) -> Array<SWXMLElement> {
        return elements[key]!
    }
}
