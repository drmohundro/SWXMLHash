## v4.8.0 (March 6, 2019)

- Added support for using String backed RawRepresentables in place of Strings for revelant APIs (via
  [#204](https://github.com/drmohundro/SWXMLHash/pull/207))

## v4.7.6 (December 11, 2018)

- Fix issue with lazy parsing and multiple calls (via
  [#204](https://github.com/drmohundro/SWXMLHash/pull/204) and
  [#203](https://github.com/drmohundro/SWXMLHash/issues/203))

## v4.7.5 (November 26, 2018)

- Fix cast warning with Swift 4.2 on Linux (via [#201](https://github.com/drmohundro/SWXMLHash/pull/201))

## v4.7.4 (October 15, 2018)

- Add `swift_version` to `SWXMLHash.podspec` (via [#198](https://github.com/drmohundro/SWXMLHash/pull/198))

## v4.7.2 (September 18, 2018)

- Bump `WATCHOS_DEPLOYMENT_TARGET` to `3.0` (via [#193](https://github.com/drmohundro/SWXMLHash/pull/193))

## v4.7.1 (August 4, 2018)

- Bump `SWIFT_VERSION` to `4.0` (via [#191](https://github.com/drmohundro/SWXMLHash/pull/191))

## v4.7.0 (May 7, 2018)

- Added `innerXML` to elements (via
  [#188](https://github.com/drmohundro/SWXMLHash/pull/188) and
  [#168](https://github.com/drmohundro/SWXMLHash/issues/168))

## v4.6.0 (March 10, 2018)

- Added XML validation config option (via
  [#169](https://github.com/drmohundro/SWXMLHash/pull/169) and
  [#141](https://github.com/drmohundro/SWXMLHash/issues/141))

## v4.5.1 (March 8, 2018)

- Swift 4.1 deprecation warnings silenced (via
  [#181](https://github.com/drmohundro/SWXMLHash/pull/181))

## v4.5.0 (February 21, 2018)

- Changed `filter` support to `filterAll` and `filterChildren` (via
  [#178](https://github.com/drmohundro/SWXMLHash/pull/178) and
  [#170](https://github.com/drmohundro/SWXMLHash/issues/170))

## v4.4.1 (February 5, 2018)

- Fix issue with `filter` and deserialization (via
  [#177](https://github.com/drmohundro/SWXMLHash/pull/177))

## v4.4.0 (February 4, 2018)

- Added `filter` support (via
  [#174](https://github.com/drmohundro/SWXMLHash/pull/174) and
  [#170](https://github.com/drmohundro/SWXMLHash/issues/170))

## v4.3.6 (January 21, 2018)

- Fixed CDATA parsing in Linux (via
  [#171](https://github.com/drmohundro/SWXMLHash/pull/175) and
  [#167](https://github.com/drmohundro/SWXMLHash/issues/172))

## v4.3.5 (January 15, 2018)

- Added `userInfo` support (via
  [#171](https://github.com/drmohundro/SWXMLHash/pull/171) and
  [#167](https://github.com/drmohundro/SWXMLHash/issues/167))

## v4.2.5 (November 10, 2017)

- Fix `XMLIndexer.byKey(_:)` bug (fixed in
  [#165](https://github.com/drmohundro/SWXMLHash/pull/165))

## v4.2.4 (November 9, 2017)

- Fix `characters` deprecation (issue
  [#163](https://github.com/drmohundro/SWXMLHash/issues/163) fixed in
  [#164](https://github.com/drmohundro/SWXMLHash/pull/164))

## v4.2.3 (September 21, 2017)

- Fix off by one `byIndex` error (issue
  [#155](https://github.com/drmohundro/SWXMLHash/issues/155) fixed in
  [#156](https://github.com/drmohundro/SWXMLHash/pull/156))

## v4.2.2 (September 21, 2017)

- Xcode 9 related compatibility fixes (via
  [#152](https://github.com/drmohundro/SWXMLHash/pull/152))

## v4.2.1 (September 12, 2017)

- Disable code coverage related to Carthage.

## v4.2.0 (August 27, 2017)

- Added new config option to allow for overriding the string encoding (via
  [#119](https://github.com/drmohundro/SWXMLHash/pull/119))

## v4.1.1 (June 1, 2017)

- Added recommended Xcode 9.3 project settings (via
  [#144](https://github.com/drmohundro/SWXMLHash/pull/144))

## v4.1.0 (June 1, 2017)

- Added `caseInsensitive` lookup options (via
  [#137](https://github.com/drmohundro/SWXMLHash/pull/137))

## v4.0.0 (May 31, 2017)

- Changed all enums to be camel cased (e.g. thisValue versus ThisValue) to match
  the Swift naming recommendations
- Removed `Sequence` from `XMLIndexer` to avoid a conflict with the `element`
  property coming in Swift 4
  - As a result, `for-in` no longer works directly against `XMLIndexer`;
    however, `for-in` works just fine against the `.all` method
- Changed `.text` to no longer be optional

## v3.1.0 (May 15, 2017)

- Added `recursiveText` property which pulls the text property from the
  currently indexed element and all child elements. (see
  [PR #131](https://github.com/drmohundro/SWXMLHash/pull/131))

## v3.0.5 (May 12, 2017)

- Fixed issues related to crashes with Swift 3.1 and Linux. (see
  [PR #130](https://github.com/drmohundro/SWXMLHash/pull/130))

## v3.0.4 (January 31, 2017)

- Fixed compilation issue related to upcoming release of Xcode 8.3.

## v3.0.3 (November 18, 2016)

- Added support for app extensions.

## v3.0.2 (September 13, 2016)

- Correct the CocoaPod support so that it still allows for iOS 8 and OSX 10.9.

## v3.0.0 - 3.0.1 (September 13, 2016)

- Official support for Xcode 8.0 and Swift 3.0
  - See corresponding [PR #78](https://github.com/drmohundro/SWXMLHash/pull/78)
- `XMLIndexer.Error` was renamed to `IndexingError` because of a naming conflict
  with the built-in `Error` type.
- Linux support is partially available and there is a Travis CI build for it as
  well.
  - Currently failing functionality is because of
    https://bugs.swift.org/browse/SR-2301.
- (3.0.1 because I was having trouble publishing the CocoaPod...)

## v2.5.1 (August 23, 2016)

- Support Swift 2.3 on Xcode 8
  - See corresponding [PR #95](https://github.com/drmohundro/SWXMLHash/pull/95)

## v2.5.0 (August 8, 2016)

- Added attribute deserialization support (via `value(ofAttribute:)`).
  - See corresponding
    [issue #74](https://github.com/drmohundro/SWXMLHash/issues/74) and
    [PR #89](https://github.com/drmohundro/SWXMLHash/pull/89)

## v2.4.0 (July 12, 2016)

- Changed from using Quick/Nimble to XCTest (no version bump - only testing
  changes)

## v2.4.0 (July 11, 2016)

- Changed visibility of `children` property on `XMLElement` to be `public`
  - See [issue #82](https://github.com/drmohundro/SWXMLHash/issues/82) and
    [PR #83](https://github.com/drmohundro/SWXMLHash/pull/83).

## v2.3.2 (June 23, 2016)

- Fixed issue with lazy loading and serialization support
  - See [issue #79](https://github.com/drmohundro/SWXMLHash/issues/79).

## v2.3.1 (April 10, 2016)

- Fixed issue with Swift Package Manager
  - See [PR #72](https://github.com/drmohundro/SWXMLHash/pull/72).

## v2.3.0 (April 9, 2016)

- Added built-in bool support for deserialization.
  - See corresponding
    [issue #70](https://github.com/drmohundro/SWXMLHash/issues/70) and
    [pull request #71](https://github.com/drmohundro/SWXMLHash/pull/71).

## v2.2.0 (March 23, 2016)

- Added deserialization / type transformer support.
  - See corresponding
    [issue #10](https://github.com/drmohundro/SWXMLHash/issues/10) and
    [pull request #68](https://github.com/drmohundro/SWXMLHash/pull/68).

## v2.1.0 (January 27, 2016)

- Changed how text elements are parsed - instead of string concatenation,
  they're now added as first class `TextElement` instances.
  - This fixes the problem with mixed text/XML in
    [issue 33](https://github.com/drmohundro/SWXMLHash/issues/33).

## v2.0.4 (November 13, 2015)

- Add explicit `watchOS` and `tvOS` targets to the project for better Carthage
  support

## v2.0.3 (October 25, 2015)

- Added support for Carthage builds with bitcode
- Bumped to `xcode7.1` usage of Quick and Nimble

## v2.0.2 (October 21, 2015)

- Added `tvOS` deployment target for CocoaPods and tvOS support

## v2.0.1 (September 22, 2015)

- Added `watchos` deployment target for CocoaPods and watchOS support

## v2.0.0 (September 16, 2015)

- Added Swift 2.0 / Xcode 7.0 support
  - While API parity should exist between v1 and v2, the library attempts to
    support the new error handling support in Swift 2.0 when you call the
    `byIndex`/`byKey` methods respectively (the subscript methods don't
    currently support throwing exceptions).
  - Note that the existing subscript methods can still be used, though.
- Changed `.Error` to `.XMLError` - this is part of handling Swift 2.0's new
  error handling support.
  - The prior `.Error` case received an `NSError` type whereas the new
    `.XMLError` case receives an `Error` which is an `ErrorType` with various
    cases to show which part of the parsing threw an error (i.e. `Attribute`,
    `AttributeValue`, `Key`, `Index`, or `Init`).

## v1.1.1 (August 3, 2015)

- Changed code signing options on the project to not code sign for OSX and to
  target iOS Developer.

## v1.1.0 (June 20, 2015)

- Add `configure` method off of `SWXMLHash` to allow for setting variable number
  of options.
  - At this time, the only options are `shouldProcessLazily` and
    `shouldProcessNamespaces`.
  - `shouldProcessLazily` provides the same parsing as directly calling `lazy`.
    I'm considering deprecating the top-level `lazy` method in favor of having
    it be set in `configure`, but I'm open to suggestions here (as well as to
    suggestions regarding the `configure` method in general).
  - `shouldProcessNamespaces` provides the functionality requested in
    [issue #30](https://github.com/drmohundro/SWXMLHash/issues/30).

## v1.0.1 (May 18, 2015)

- Quick/Nimble are no longer used via git submodules, but are instead being
  pulled in via Carthage.

## v1.0.0 (April 10, 2015)

- Lazy loading support is available
  ([issue #11](https://github.com/drmohundro/SWXMLHash/issues/11))
  - Call `.lazy` instead of `.parse`
  - Performance can be drastically improved when doing lazy parsing.
- See [PR #26](https://github.com/drmohundro/SWXMLHash/pull/26) for details on
  these:
  - Remove automatic whitespace trimming - that will be a responsibility of the
    caller.
  - Make umbrella header public.
  - Introduce shared schemes.
- Xcode 6.3 and Swift 1.2 support.
- Published version 1.0.0 CocoaPod.

## v0.6.4 (February 26, 2015)

- Fixed bug with interleaved XML (issue #19)
- Published version 0.6.4 CocoaPod.

## v0.6.3 (February 23, 2015)

- Fixed bug where mixed content wasn't supported (i.e. elements with both text
  and child elements).
- Published version 0.6.3 CocoaPod.

## v0.6.2 (February 9, 2015)

- Published version 0.6.2 CocoaPod. (yes, it should have gone with 0.6.1 but I
  tagged it too early)

## v0.6.1 (February 9, 2015)

- Fixed bug with `children` so that XML element order is preserved when
  enumerating XML child elements.
- Only require Foundation.h instead of UIKit.h.

## v0.6.0 (January 30, 2015)

- Added `children` property to allow for enumerating all child elements.
- CocoaPods support is live (see current
  [docset on CocoaPods](http://cocoadocs.org/docsets/SWXMLHash/0.6.0/))

## v0.5.5 (January 25, 2015)

- Added OSX target, should allow SWXMLHash to work in OSX as well as iOS.

## v0.5.4 (November 2, 2014)

- Added the `withAttr` method to allow for lookup by an attribute and its value.
  See README or specs for details.

## v0.5.3 (October 21, 2014)

- XCode 6.1 is out on the app store now and I had to make a minor tweak to get
  the code to compile.

## v0.5.2 (October 6, 2014)

- Fix handling of whitespace in XML which resolves issue #6.
  - Apparently the `foundCharacters` method of `NSXMLParser` also gets called
    for whitespace between elements.
  - There are now specs to account for this issue as well as a spec to document
    CDATA usage, too.

## v0.5.1 (October 5, 2014)

- XCode 6.1 compatibility - added explicit unwrapping of `NSXMLParser`.
- Updated to latest Quick, Nimble for 6.1 compilation.
- Added specs to try to help with issue #6.

## v0.5.0 (September 30, 2014)

- Made `XMLIndexer` implement the `SequenceType` protocol to allow for for-in
  usage over it. The `all` method still exists as an option, but isn't necessary
  for simply iterating over sequences.
- Formally introduced the change log!

## v0.4.2 (August 19, 2014)

- XCode 6 beta 6 compatibility.

## v0.4.1 (August 11, 2014)

- Fixed bugs related to the `all` method when only one element existed.

## v0.4.0 (August 8, 2014)

- Refactored to make the `parse` method class-level instead of instance-level.

## v0.3.1 (August 7, 2014)

- Moved all types into one file for ease of distribution for now.

## v0.3.0 (July 28, 2014)

- XCode 6 beta 4 compatibility.

## v0.2.0 (July 14, 2014)

- Heavy refactoring to introduce enum-based code (based on
  [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)).
- The public `parse` method now takes a string in addition to `NSData`.
- Initial attribute support added.

## v0.1.0 (July 8, 2014)

- Initial release.
- This version is an early iteration to get the general idea down, but isn't
  really ready to be used.
