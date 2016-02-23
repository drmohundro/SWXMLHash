# Contributing

## Topics

* [Getting Help](#getting-help)
* [Reporting Issues](#reporting-issues)
* [Development](#development)
* [Thank You!](#thank-you)

## Getting Help

I monitor [StackOverflow](http://stackoverflow.com) under the [SWXMLHash tag](http://stackoverflow.com/questions/tagged/swxmlhash) and try to answer questions there when possible - that is likely a better place to ask questions than in the Issues section here.

## Reporting Issues

When reporting issues, please include:

* Which version of Xcode you're using
* Which OS or platform you're targetting
* Any stack trace or compiler error
* Code snippets that reproduce the behavior

Both bug reports and feature requests are welcome!

## Development

SWXMLHash currently uses [Quick](https://github.com/Quick/Quick) and [Nimble](https://github.com/Quick/Nimble) for its tests. To get these dependencies, you'll need to have [Carthage](https://github.com/Carthage/Carthage) installed. Once it is installed, you should be able to just run `carthage update`.

To run the tests, you can either run them from within Xcode or you can run `rake test`.

The coding style used is dictacted by [SwiftLint](https://github.com/realm/SwiftLint). You can get SwiftLint by running `brew install swiftlint`. To run it, just clone the repository and run `swiftlint`. There is a `.swiftlint.yml` for lint configuration.

Prior to submitting a pull request, please verify that:

* The code compiles
* All tests pass
* SwiftLint reports no issues

## Thank You

Thanks for your interest in contributing to SWXMLHash!
