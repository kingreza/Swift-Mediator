//
//  mechanic.swift
//  Mechanic - Mediator
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class Mechanic{
  let mediator: Mediator
  var location: (Int, Int)
  var name: String
  
  init  (mediator: Mediator, name: String, location: (Int, Int)){
    self.mediator = mediator
    self.name = name
    self.location = location
  }
  
  func send(request: Request){
    mediator.send(request)
  }
  
  func receive(request: Request){
    print("\(name) received request from \(request.mechanic.name): \(request.message)")
    if let parts = request.parts{
      print("request is for parts:")
      for part in parts{
        print(part.name)
      }
    }
    print("******************")
  }
  
  func isCloseTo(mechanic: Mechanic, within distance: Float) -> Bool
  {
    return hypotf(Float(mechanic.location.0 - location.0), Float(mechanic.location.1 - location.1)) <= distance
  }
}