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
