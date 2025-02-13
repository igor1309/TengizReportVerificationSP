//
//  FilesTests.swift
//  TengizReportSPTests
//
//  Created by Igor Malyarov on 28.01.2021.
//

import XCTest
@testable import TextReports

final class FilesTests: XCTestCase {
    func testTextFilesReadable() throws {
        XCTAssertEqual(ContentLoader.allFilenames.count, 12, "Report sample might have been added.")
        
        
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ 2020-06").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ 2020-07").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ август 2020").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ сентябрь 2020 ").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави октябрь").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ ноябрь 2020 ").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ декабрь 2020 ").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "Саперави АМ январь 2021 ").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "ВМ ЩК ноябрь 2020").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "ВМ ЩК декабрь 2020").get().isEmpty, "Can't read Report file content")
        XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: "ВМ ЩК январь 2021").get().isEmpty, "Can't read Report file content")
        
        
        for filename in ContentLoader.allFilenames {
            XCTAssertFalse(try ContentLoader.contentsOfSampleFile(named: filename).get().isEmpty, "Can't read Report file content")
        }
        
        let prefixes: [String] = ["Название объекта: Саперави Аминьевка\nМесяц: июнь2020 (с 24 по 30 июня)\tОборот:26",
                                  "Название объекта: Саперави Аминьевка\nМесяц: июль2020 \tОборот:1.067.807\tСредний п",
                                  "Название объекта: Саперави Аминьевка\nМесяц: август2020 \tОборот:1.738.788\tСредний",
                                  "Название объекта: Саперави Аминьевка\nМесяц: сентябрь2020 \tОборот:2.440.021\tСредн",
                                  "Название объекта: Саперави Аминьевка\nОктябрь2020 \tОборот:2.587.735\tСредний показ",
                                  "Название объекта: Саперави Аминьевка\nНоябрь2020 \tОборот:1.885.280\tСредний показа",
                                  "Название объекта: Саперави Аминьевка\nДекабрь2020 \tОборот:2.318.274\tСредний показ",
                                  "Название объекта: Саперави Аминьевка\nЯнварь2021 \tОборот:2.307.231\tСредний показа",
                                  "Название объекта: Саперави Аминьевка\nФевраль2021\tОборот:2.903.617\tСредний показа",
                                  "Название объекта: Вай Мэ! Щелково\nОктябрь+Ноябрь2020\tОборот факт:141.690+1.238.9",
                                  "Название объекта: Вай Мэ! Щелково\nДекабрь2020\tОборот факт:929.625\tСредний показа",
                                  "Название объекта: Вай Мэ! Щелково\nЯнварь2021\tОборот факт:1.065.575\tСредний показ"]
        
        XCTAssertEqual(12, prefixes.count)
        XCTAssertEqual(ContentLoader.allFilenames.count, prefixes.count)
        
        let contentsPrefixes = try ContentLoader.allFilenames
            .map {
                try ContentLoader.contentsOfSampleFile(named: $0).get()
            }
            .map { String($0.prefix(80)) }
        XCTAssertEqual(contentsPrefixes, prefixes)
        
        for (filename, prefix) in zip(ContentLoader.allFilenames, prefixes) {
            let contents = try ContentLoader.contentsOfSampleFile(named: filename).get()
            XCTAssertEqual([String(contents.prefix(80))], [prefix])
        }
    }
}
