// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TengizReportVerificationSP",
    platforms: [
        .macOS(.v10_15), .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TengizReportVerificationSP",
            targets: ["Verification"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/igor1309/TengizReportSP", .branch("main")),
        .package(url: "https://github.com/igor1309/TextReports", .branch("main")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Verification",
            dependencies: ["TengizReportSP"]
        ),
        .testTarget(
            name: "VerificationTests",
            dependencies: ["Verification", "TengizReportSP", "TextReports"]
        ),
    ]
)
