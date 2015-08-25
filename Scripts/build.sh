#!/bin/sh

set -ev

xctool -scheme SWXMLHash clean build test -sdk iphonesimulator
