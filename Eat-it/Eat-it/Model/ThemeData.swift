//
//  ThemeData.swift
//  Eat-it
//
//  Created by sungnni on 2018. 6. 13..
//  Copyright © 2018년 sungeun. All rights reserved.
//

import Foundation
import UIKit

struct ColorSet {
  
  var id: Int!
  var name: String!
  
  var good: UIColor!
  var soso: UIColor!
  var bad: UIColor!
  var background: UIColor!
  
  var colors: [UIColor] = []
  
  init(id: Int, name: String, colors: [String]) {
    
    self.id = id
    self.name = name
    
    for color in colors {
      let colorTemp = UIColor(hex: color)
      self.colors.append(colorTemp)
    }
    
    self.good = self.colors[0]
    self.soso = self.colors[1]
    self.bad = self.colors[2]
    self.background = self.colors[3]
  }
  
  
//  static var basic = ColorSet(id: 0, name: "basic", colors: ["73cac4", "e3e546", "f2788f", "f5f5f5"])
//  static var helsinki = ColorSet(id: 1, name: "helsinki", colors: ["abc5e8", "fbf7ae", "fad2da", "f5f5f5"])
//  static var marseille = ColorSet(id: 2, name: "marseille", colors: ["8cdbd6", "fff9a4", "f9b8bc", "f5f5f5"])
//  static var newyork = ColorSet(id: 3, name: "newyork", colors: ["1dace6", "ffd938", "90909a", "f5f5f5"])
//  static var horizon = ColorSet(id: 4, name: "horizon", colors: ["fdd8dd", "eebbcc", "d7c4e0", "fff7f5"])
//  static var orange = ColorSet(id: 5, name: "orange", colors: ["ffaa39", "ffcd68", "fff1c4", "fff8eb"])
//  static var heaven = ColorSet(id: 6, name: "heaven", colors: ["b6e2e6", "9ddae3", "93cad6", "f5f5f5"])
  
  static var basic = ColorSet(id: 0, name: "basic", colors: ["bae89b", "fff1a7", "ffcdc7", "f8f8f8"])
  static var sunset = ColorSet(id: 1, name: "sunset", colors: ["d1ed7d", "ffe87c", "fdb66b", "f8f8f8"])
  static var macaron = ColorSet(id: 2, name: "macaron", colors: ["ccf3f5", "fff5d8", "fec3bf", "f8f8f8"])
  static var redblue = ColorSet(id: 3, name: "redblue", colors: ["a8dee9", "d0d0d0", "faa198", "f8fbfb"])
  static var jejuOcean = ColorSet(id: 4, name: "jejuOcean", colors: ["d3efe8", "fdefd3", "f8b27a", "f8fbfb"])
  
  
  static var cherryBlossom = ColorSet(id: 5, name: "cherryBlossom", colors: ["ffe0e2", "ff9fa7", "f48187", "f8f8f8"])
  static var orange = ColorSet(id: 6, name: "orange", colors: ["fff1c4", "ffcd68", "ffaa39", "fff8eb"])
  static var heaven = ColorSet(id: 7, name: "heaven", colors: ["d1f0f9", "b4e2e6", "4cbad5", "f8f8f8"])
  static var cookieCream = ColorSet(id: 8, name: "cookieCream", colors: ["e8e8e8", "ababab", "565656", "f8f8f8"])
  
}

extension ColorSet: CustomStringConvertible {
  
  public var description: String {
    
    var str = ""
    let colors = self.colors
    for color in colors {
      str += color.description + "/"
    }
    
    return str
  }
}
