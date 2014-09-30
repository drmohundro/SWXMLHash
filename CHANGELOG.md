## v0.5.0 (September 30, 2014)

* Made `XMLIndexer` implement the `SequenceType` protocol to allow for for-in usage over it. The `all` method still exists as an option, but isn't necessary for simply iterating over sequences.
* Formally introduced the change log!

## v0.4.2 (August 19, 2014)

* XCode 6 beta 6 compatibility.

## v0.4.1 (August 11, 2014)

* Fixed bugs related to the `all` method when only one element existed.

## v0.4.0 (August 8, 2014)

* Refactored to make the `parse` method class-level instead of instance-level.

## v0.3.1 (August 7, 2014)

* Moved all types into one file for ease of distribution for now.

## v0.3.0 (July 28, 2014)

* XCode 6 beta 4 compatibility.

## v0.2.0 (July 14, 2014)

* Heavy refactoring to introduce enum-based code (based on SwiftJSON).
* The public `parse` method now takes a string in addition to `NSData`.
* Initial attribute support added.

## v0.1.0 (July 8, 2014)

* Initial release.
* This version is an early iteration to get the general idea down, but isn't really ready to be used.
