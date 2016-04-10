//
//  RequestMediator.swift
//  Mechanic - Mediator
//
//  Created by Reza Shirazian on 2016-04-07.
//  Copyright © 2016 Reza Shirazian. All rights reserved.
//

import Foundation

class RequestMediator: Mediator{
  private let closeDistance: Float = 50.0
  private var mechanics: [Mechanic] = []
  
  func addMechanic(mechanic: Mechanic){
    mechanics.append(mechanic)
  }
  
  func send(request: Request) {
    for oneOfTheMechanics in mechanics{
      if oneOfTheMechanics !== request.mechanic && request.mechanic.isCloseTo(oneOfTheMechanics, within: closeDistance){
        oneOfTheMechanics.receive(request)
      }
    }
  }
}