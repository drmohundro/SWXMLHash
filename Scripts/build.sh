#!/bin/sh

set -ev

#xctool -scheme "SWXMLHash iOS" clean build test -sdk iphonesimulator
set -o pipefail && xcodebuild -workspace SWXMLHash.xcworkspace -scheme "SWXMLHash iOS" -destination "OS=11.0,name=iPhone 7" clean build test -sdk iphonesimulator | xcpretty
