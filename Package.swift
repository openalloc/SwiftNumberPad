// swift-tools-version: 5.7

import PackageDescription

let package = Package(name: "SwiftNumberPad",
                      platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9)],
                      products: [
                          .library(name: "NumberPad",
                                   targets: ["NumberPad"]),
                      ],
                      dependencies: [
                      ],
                      targets: [
                          .target(name: "NumberPad",
                                  dependencies: [
                                  ],
                                  path: "Sources",
                                  resources: [
                                      .process("Resources"),
                                  ]),
                          .testTarget(name: "NumberPadTests",
                                      dependencies: ["NumberPad"],
                                      path: "Tests"),
                      ])
