//
//  MedsParser.swift
//  pl-meds-db
//
//  Created by Rafal Piekarski on 02/04/2017.
//  Copyright © 2017 ReThink. All rights reserved.
//

import Foundation

class MedsParser {
  let document: XMLDocument
  init(_ xml: XMLDocument) {
    self.document = xml
  }
  
  func parse() -> [Medicine] {
    let list = document.rootElement()!.elements(forName: "produktLeczniczy").lazy
      .filter { $0.attribute(forName: "rodzajPreparatu")?.stringValue == "ludzki" }
      .flatMap { element -> [Medicine] in return Medicine.buildFromXmlElement(element) }
    return Array(list)
  }
}
