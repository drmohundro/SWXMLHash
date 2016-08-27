import XCTest

@testable import SWXMLHashTests

XCTMain([
    testCase(LazyTypesConversionTests.allTests),
    testCase(LazyWhiteSpaceParsingTests.allTests),
    testCase(LazyXMLParsingTests.allTests),
    testCase(MixedTextWithXMLElementsTests.allTests),
    testCase(SWXMLHashConfigTests.allTests),
    testCase(TypeConversionArrayOfNonPrimitiveTypesTests.allTests),
    testCase(TypeConversionBasicTypesTests.allTests),
    testCase(TypeConversionComplexTypesTests.allTests),
    testCase(TypeConversionPrimitypeTypesTests.allTests),
    testCase(WhiteSpaceParsingTests.allTests),
    testCase(XMLParsingTests.allTests),
    ])
