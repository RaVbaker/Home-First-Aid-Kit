//: Playground - noun: a place where people can play

import Cocoa
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var fileUrl = "http://pub.rejestrymedyczne.csioz.gov.pl/pobieranie_WS/Pobieranie.ashx?filetype=XMLUpdateFile&regtype=RPL_FILES_GROWTH"

let theUrl = URL(string: fileUrl)

let task = URLSession.shared.dataTask(with: theUrl!) { (data, response, error) in
  if let error = error {
    print(error)
  } else {
    if let content = data {
      response?.className
      print(response?.suggestedFilename ?? "no filename")
      (response as! HTTPURLResponse).allHeaderFields
    }
  }
  PlaygroundPage.current.finishExecution()
}
task.resume()
