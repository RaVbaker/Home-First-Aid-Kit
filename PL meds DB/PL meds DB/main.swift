//
//  main.swift
//  PL meds DB
//
//  Created by Rafal Piekarski on 18/03/2017.
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

class ConsoleApp {
  let basePath = "file:///Users/ravbaker/Code/Home-First-Aid-Kit"
  
  var list: [Medicine] = []
  
  init(_ args: [String]) {
    var source = "default"
    if args.count == 2 {
      source = args[1]
      
      if source == "-h" {
        print("Usage: ./\"PL meds DB\" [datasource] [-h]")
        print("                       datasource - (changes latest [fast] full)")
        return
      }
    }
    let theUrl = URL(string: dataSource(source))
    let xml = try! XMLDocument.init(contentsOf: theUrl!, options: 0)
    list = MedsParser(xml).parse()
    
    print("Znaleziono: \(list.count) leków")
  }
  
  func dataSource(_ source: String) -> String {
    switch source {
    case "changes":
      return "http://pub.rejestrymedyczne.csioz.gov.pl/pobieranie_WS/Pobieranie.ashx?filetype=XMLUpdateFile&regtype=RPL_FILES_GROWTH"
    case "latest":
      return "http://pub.rejestrymedyczne.csioz.gov.pl/pobieranie_WS/Pobieranie.ashx?filetype=XMLFile&regtype=RPL_FILES_BASE"
    case "fast", "default":
      return "\(self.basePath)/samples/sample.xml"
    case "slow", "full":
      return "\(self.basePath)/samples/full-sample.xml"
    default:
      fputs("ERROR: unsupported datasource parameter", stderr)
      exit(1)
    }
  }
}


let app = ConsoleApp(CommandLine.arguments)
