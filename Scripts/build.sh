#!/bin/sh

set -ev

#xctool -scheme "SWXMLHash iOS" clean build test -sdk iphonesimulator
set -o pipefail && xcodebuild -workspace SWXMLHash.xcworkspace -scheme "SWXMLHash iOS" clean build test -sdk iphonesimulator | xcpretty
