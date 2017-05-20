//
//  ConsoleApp.swift
//  pl-meds-db
//
//  Created by Rafal Piekarski on 02/04/2017.
//  Copyright © 2017 ReThink. All rights reserved.
//

import Foundation

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
