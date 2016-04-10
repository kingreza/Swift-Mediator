//
//  request.swift
//  Mechanic - Mediator
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Request {
  var message: String
  var parts: [Part]?
  var mechanic: Mechanic
  
  init(message: String, mechanic: Mechanic, parts: [Part]?)
  {
    self.message = message
    self.parts = parts
    self.mechanic = mechanic
  }
  
  convenience init(message: String, mechanic: Mechanic){
    self.init(message: message, mechanic: mechanic, parts: nil)
  }
}