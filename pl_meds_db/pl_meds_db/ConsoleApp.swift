//
//  ConsoleApp.swift
//  pl-meds-db
//
//  Created by Rafal Piekarski on 02/04/2017.
//  Copyright © 2017 ReThink. All rights reserved.
//

import Foundation

class ConsoleApp {
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
  
  private
  
  func dataSource(_ source: String) -> String {
    switch source {
    case "changes":
      return "http://pub.rejestrymedyczne.csioz.gov.pl/pobieranie_WS/Pobieranie.ashx?filetype=XMLUpdateFile&regtype=RPL_FILES_GROWTH"
    case "latest":
      return "http://pub.rejestrymedyczne.csioz.gov.pl/pobieranie_WS/Pobieranie.ashx?filetype=XMLFile&regtype=RPL_FILES_BASE"
    case "fast", "default":
      return resourcePath(for: "sample")
    case "slow", "full":
      return resourcePath(for: "full-sample")
    default:
      fputs("ERROR: unsupported datasource parameter", stderr)
      exit(1)
      
    }
  }
  
  func resourcePath(for name: String) -> String {
    return Bundle.main.url(forResource: name, withExtension: "xml")!.absoluteString
  }
}
