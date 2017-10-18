// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "SWXMLHash",
  products: [
  	.library(
  	  name: "SWXMLHash",
  	  targets: ["SWXMLHash"]
  	)
  ],
  targets: [
    .target(
  	  name: "SWXMLHash",
  	  path: "Source"
  	),
    .testTarget(
      name: "SWXMLHashTests",
      dependencies: ["SWXMLHash"]
    )
  ]
)
