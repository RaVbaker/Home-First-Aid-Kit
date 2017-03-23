//: Playground - noun: a place where people can play

import Cocoa


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


var fileUrl = "http://pub.rejestrymedyczne.csioz.gov.pl/pobieranie_WS/Pobieranie.ashx?filetype=XMLUpdateFile&regtype=RPL_FILES_GROWTH"

let theUrl = URL(string: fileUrl)
let xml = try XMLDocument.init(contentsOf: theUrl!, options: 0)
let list = MedsParser(xml).parse()
let randIndex = Int(arc4random_uniform(UInt32(list.count)) + 1)
list[randIndex]
