// swift-tools-version:4.2
//___FILEHEADER___

import PackageDescription

let package = Package(
    name: "___PACKAGENAME___",
    dependencies: [
        /* Add your dependencies in here
        .package(url: "https://github.com/AlwaysRightInstitute/cows.git",
                 from: "1.0.0")
        */
    ],
    targets: [
        // "." is because we do not have the sources in Sources,
        .target(name: "___PACKAGENAME___", 
                dependencies: [ 
                    //"cows" 
                ],
                path: "."),
    ]
)
