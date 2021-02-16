//
//  FilesTests.swift
//  TengizReportSPTests
//
//  Created by Igor Malyarov on 28.01.2021.
//

import XCTest

final class FilesTests: XCTestCase {
    func testTextFilesReadable() throws {
        XCTAssertEqual(SampleFiles.filenames.count, 11, "Report sample might have been added.")

        try SampleFiles.filenames
            .forEach {
                XCTAssertFalse(try $0.contentsOfFile().isEmpty, "Can't read Report file content")
            }
    }
}

extension String {
    func contentsOfFile() throws -> String {
        enum TestErrors: Error {
            case noFile(String)
        }

        guard let filepath = Bundle.module.path(forResource: self, ofType: "txt") else { throw TestErrors.noFile(self) }
        return try String(contentsOfFile: filepath)
    }

}
