//
//  Medicine.swift
//  pl-meds-db
//
//  Created by Rafal Piekarski on 02/04/2017.
//  Copyright © 2017 ReThink. All rights reserved.
//

import Foundation

struct Medicine {
  var atcId: String
  var name: String
  var substances: [String]
  var type: String
  var ean: String
  var description: String
  var producer: String
  
  static func buildFromXmlElement(_ element: XMLElement) -> [Medicine] {
    let name = element.attribute(forName: "nazwaProduktu")!.stringValue!
    let atcId = element.attribute(forName: "kodATC")?.stringValue ?? "" // can be empty
    
    let substances = element.elements(forName: "substancjeCzynne").flatMap({ (el) -> String in return el.stringValue ?? "" })
    let type = element.attribute(forName: "postac")!.stringValue!
    let variants = element.elements(forName: "opakowania").first?.elements(forName: "opakowanie") ?? Array()
    let description = element.attributes?.lazy
      .filter { return ["postac", "nazwaPowszechnieStosowana", "moc"].contains($0.name!) }
      .map { $0.stringValue! }
      .joined(separator: " ") ?? ""
    let producer = element.attribute(forName: "podmiotOdpowiedzielny")!.stringValue!
    
    return variants.map { variant in
      let variantName = (variant.attribute(forName: "wielkosc")!.stringValue!) + " " + (variant.attribute(forName: "jednostkaWielkosci")?.stringValue ?? "")
      let ean = variant.attribute(forName: "kodEAN")?.stringValue ?? ""
      
      return Medicine(
        atcId: atcId,
        name: name + " " + variantName,
        substances: substances,
        type: type,
        ean: ean,
        description: description,
        producer: producer
      )
    }
  }
}
