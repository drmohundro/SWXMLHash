// Playground - noun: a place where people can play

import SWXMLHash
import UIKit

let xmlWithNamespace = "<root xmlns:h=\"http://www.w3.org/TR/html4/\"" +
"  xmlns:f=\"http://www.w3schools.com/furniture\">" +
"  <h:table>" +
"    <h:tr>" +
"      <h:td>Apples</h:td>" +
"      <h:td>Bananas</h:td>" +
"    </h:tr>" +
"  </h:table>" +
"  <f:table>" +
"    <f:name>African Coffee Table</f:name>" +
"    <f:width>80</f:width>" +
"    <f:length>120</f:length>" +
"  </f:table>" +
"</root>"

var xml = SWXMLHash.parse(xmlWithNamespace)

// one root element
let count = xml["root"].all.count

// "Apples"
xml["root"]["h:table"]["h:tr"]["h:td"][0].element!.text!
