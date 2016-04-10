//
//  concrete_mechanic.swift
//  Mechanic - Mediator
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class ConcreteMechanic: Mechanic{
  override func receive(request: Request) {
    print("\(name) received request from \(request.mechanic.name): \(request.message)")
    if let parts = request.parts{
      print("request is for parts:")
      for part in parts{
        print(part.name)
      }
    }
    print("******************")
  }
}