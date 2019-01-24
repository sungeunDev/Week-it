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

    static var christmas = ColorSet(id: -2, name: "christmas", colors: ["086F55", "E5E5E1", "D21725", "FAFAFA"])
    static var christmasLight = ColorSet(id: -1, name: "christmas Light", colors: ["6B9E42", "F8E19E", "FF563F", "FAFAFA"])
    
  static var basic = ColorSet(id: 0, name: "basic", colors: ["bae89b", "fff1a7", "ffcdc7", "f8f8f8"])
  static var sunset = ColorSet(id: 1, name: "sunset", colors: ["d1ed7d", "ffe87c", "fdb66b", "f8f8f8"])
  static var macaron = ColorSet(id: 2, name: "macaron", colors: ["ccf3f5", "fff5d8", "fec3bf", "f8f8f8"])
  static var redblue = ColorSet(id: 3, name: "redblue", colors: ["a8dee9", "d0d0d0", "faa198", "f8f8f8"])
  static var jejuOcean = ColorSet(id: 4, name: "jejuOcean", colors: ["d3efe8", "fdefd3", "f8b27a", "f8f8f8"])
  static var cherryBlossom = ColorSet(id: 5, name: "cherryBlossom", colors: ["ffe0e2", "ff9fa7", "f48187", "f8f8f8"])
  static var orange = ColorSet(id: 6, name: "orange", colors: ["fff1c4", "ffcd68", "ffaa39", "f8f8f8"])
  static var heaven = ColorSet(id: 7, name: "heaven", colors: ["d1f0f9", "b4e2e6", "4cbad5", "f8f8f8"])
  static var cookieCream = ColorSet(id: 8, name: "cookieCream", colors: ["e8e8e8", "ababab", "565656", "f8f8f8"])
}
