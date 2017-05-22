//
//  MedsParserTests.swift
//  MedsParserTests
//
//  Created by Rafal Piekarski on 20/05/2017.
//  Copyright © 2017 ReThink. All rights reserved.
//

import XCTest

class MedsParserTests: XCTestCase {
  
  var testBundle: Bundle?
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    if testBundle == nil {
      testBundle = Bundle(for: type(of: self))
    }
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testParseTotalCount() {
    let parsedMedsCount = parse().count
    XCTAssertEqual(parsedMedsCount, 284)
  }
  
  func testThatRecordsAreMedicinesWithProperProperties() {
    let records: [Medicine] = self.parse()
    let medicine = records[2] // taking this one cause it has another variant
    
    XCTAssertEqual(medicine.atcId, "J01MA06")
    XCTAssertEqual(medicine.name, "Nolicin 10 tabl.")
    XCTAssertEqual(medicine.substances, ["Norfloxacinum"])
    XCTAssertEqual(medicine.type, "tabletki powlekane")
    XCTAssertEqual(medicine.ean, "5909990085316")
    XCTAssertEqual(medicine.description, "Norfloxacinum 400 mg tabletki powlekane")
    XCTAssertEqual(medicine.producer, "Krka, d.d., Novo mesto")
  }
  
  func testThatOtherVariantOfSameMedicineHasSimilarProperties() {
    let records: [Medicine] = self.parse()
    let medicine = records[3]
    
    XCTAssertEqual(medicine.atcId, "J01MA06")
    XCTAssertEqual(medicine.name, "Nolicin 20 tabl.")
    XCTAssertEqual(medicine.substances, ["Norfloxacinum"])
    XCTAssertEqual(medicine.type, "tabletki powlekane")
    XCTAssertEqual(medicine.ean, "5909990085323")
    XCTAssertEqual(medicine.description, "Norfloxacinum 400 mg tabletki powlekane")
    XCTAssertEqual(medicine.producer, "Krka, d.d., Novo mesto")
  }
  
  func testThereAreNoNonHumanMedsParsed() {
    let fullXMLDocument = sampleXMLDocument()
    let fetchNonHumanMed = fullXMLDocument.rootElement()!.elements(forName: "produktLeczniczy")
    .filter { $0.attribute(forName: "rodzajPreparatu")?.stringValue != "ludzki" }.first!
    let sampleATC = fetchNonHumanMed.attribute(forName: "kodATC")!.stringValue!
    
    let foundNonHumanMed = self.parse().filter({
      $0.atcId == sampleATC
      }).first
    XCTAssertNil(foundNonHumanMed, "We found a non human med in medicines list!")
  }
  
  func testSamplePerformance() {
    // This is an example of a performance test case.
    self.measure {
      _ = self.parse()
    }
  }
  
  func testFullSamplePerformance() {
    // This is an example of a performance test case.
    self.measure {
      _ = self.parse("full-sample")
    }
  }
  
  private
  func parse(_ sampleName: String = "sample") -> Array<Medicine> {
    let sut = MedsParser(sampleXMLDocument(sampleName))
    return sut.parse()
  }
  
  func sampleXMLDocument(_ sampleName: String = "sample") -> XMLDocument {
    let fileURL = testBundle!.url(forResource: sampleName, withExtension: "xml")
    return try! XMLDocument.init(contentsOf: fileURL!, options: 0)
  }
  
}
