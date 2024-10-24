//
//  Template.swift
//  ProjectDescriptionHelpers
//
//  Created by Supermove on 10/30/23.
//

import ProjectDescription

let layerAttribute: Template.Attribute = .required("layer")
let nameAttribute: Template.Attribute = .required("name")

let exampleContents = """
import Foundation

struct \(nameAttribute) { }
"""

let testContents = """
import Foundation
import XCTest

final class \(nameAttribute)Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_example() {
        // Add your test here
    }

}
"""

let testingContents = """
import Foundation
import \(nameAttribute)

public final class \(nameAttribute)Testing {
    public init() { }
}
"""

let targetPath = "Projects/\(layerAttribute)/\(nameAttribute)"

let template = Template(
    description: "Framework template",
    attributes: [
        layerAttribute,
        nameAttribute, .optional("platform", default: "iOS")
    ],
    items: [
        [
            .file(path: "\(targetPath)/Example/Sources/AppDelegate.swift",
                  templatePath: "Example/contents_example_appdelegate.stencil"),
            .file(path: "\(targetPath)/Example/Resources/Assets.xcassets/contents.json",
                  templatePath: "Example/contents_xcassets.stencil"),
            .file(path: "\(targetPath)/Example/Resources/Assets.xcassets/AppIcon.appiconset/contents.json",
                  templatePath: "Example/contents_xcassetsAppIcon.stencil"),
            .file(path: "\(targetPath)/Example/Resources/LaunchScreen.storyboard",
                  templatePath: "Example/LaunchScreen.stencil"),
        ],
        [
            .string(path: "\(targetPath)/Interface/\(nameAttribute)Interface.swift", contents: exampleContents),
            .string(path: "\(targetPath)/Sources/\(nameAttribute).swift", contents: exampleContents),
            .string(path: "\(targetPath)/Testing/\(nameAttribute)Testing.swift", contents: testingContents),
            .string(path: "\(targetPath)/Tests/\(nameAttribute)Tests.swift", contents: testContents),
            .file(path: "\(targetPath)/Project.swift", templatePath: "project.stencil"),
        ]
    ].flatMap { $0 }
)
