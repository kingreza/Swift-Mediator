<h3>The problem:</h3>
We track the location of all our mobile mechanics when they are working. We have noticed that there are many times when a mobile mechanics might need assistance from another mechanic or a last minute need for a part that someone else might carry. We want to build a system where mechanics can send requests with the option of defining specific parts needed to all mechanics that are close to their location.
<h3>The solution:</h3>
We will define a mediator and have have every mechanics register with it. When a mechanic sends a request, the mediator will detect all close by mechanics and will forward the request to them.

<!--more-->

Link to the repo for the completed project: <a href="https://github.com/kingreza/Swift-Mediator"> Swift - Mediator </a>

Let's Begin

First off let's get the easy stuff out of the way. We begin by defining our parts object:

````swift
import Foundation

class Part{
  var name: String
  var price: Double

  init (name: String, price: Double){
    self.name = name
    self.price = price
  }
}
````

A part will have a name and a price. The class itself has two properties that take care the two values and an initializer that sets them up when a part is created.

Next we'll define our Request object. This will be used by our mechanics and mediator to communicate with each other:

````swift
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
````

A request will have a message, along with an array of parts that could be empty and a mechanic which is the owner of the request.

Here we use the convenience init to have two separate init for cases with empty parts. We can easily just use the first one and pass in nil for parts but I personally like having the class provide its own init for those cases (and it's good practice). For more info on convenience init click here LINK.

Our Mechanic class will be defined as followed

````swift
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
````

A mechanic has a mediator which it uses for sending requests and a location which is defined as tuple of Int. This is the mechanic's hypothetical location on some X,Y coordinate. And of course a mechanic has a name. We set up these properties in the init function.

Next we define our send and receive functions for our mechanic. The send function will simply delegate the task to the mediator. The receive function is where the mechanic deals with the request. For this example the mechanic will simply print out the request it has received.

If we had more actors (customers, customer service, managers, parts team, etc) that we wanted to mediate then it would be best to factor out the mediator property and the send function into a colleague superclass. This will be common among all of them so we wouldn't have to re-implement them for each subsequent actor. But for the sake of brevity and simplicity we will define them all in Mechanic and assume that this will be the only actor within our system that we need to mediate.

Finally we define isCloseTo which takes a mechanic and a float and decides if the distance between the mechanics is less than the float passed.

next we define a protocol for our Mediator.

````swift
import Foundation

protocol Mediator{
  func send(request: Request)
}
````

The Mediator protocol is fairly simple. It requires a send function that takes a request as its parameter.

Finally we define our RequestMediator which implements our Mediator protocol:

````swift
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
````

We first set up the distance which we believe is considered the boundary of being close to another mechanic. Next we define an array of Mechanics that have subscribed to our mediator.

We define a simple addMechanic function which will be used to add mechanics to our collection of mediated mechanics.

Finally we implement the send function. Our mediator iterates through each mechanic in its list of mechanics, if the mechanic is not the same mechanic making the request and is close to the requesting mech it will receive the request.

This is it. Notice that our mechanics, although capable of communicating with each other are not aware of each other. There is no reference to another mechanic in our mechanics class.

Lets test it out

````swift

import Foundation

var requestManager = RequestMediator()

var steve = Mechanic(mediator: requestManager, name: "Steve Akio", location: (23,12))
var joe = Mechanic(mediator: requestManager, name: "Joe Bob", location: (13,12))
var dave = Mechanic(mediator: requestManager, name: "Dave Far", location: (823,632))
var mike = Mechanic(mediator: requestManager, name: "Mike Nearfar", location: (800,604))

requestManager.addMechanic(steve)
requestManager.addMechanic(joe)
requestManager.addMechanic(dave)
requestManager.addMechanic(mike)

steve.send(Request(message: "I can't find this address anyone close by knows where Rengstorff Ave is?", mechanic: steve))

joe.send(Request(message: "I need some brake pads anyone close by has some?", mechanic: joe, parts: [Part(name: "StopIt Brake Pads", price: 35.25)]))

dave.send(Request(message: "Dang it I spilled all my oil, anyone around here got a spare 5 Quart Jug.. and some filters too", mechanic: dave, parts:[Part(name: "Engine Oil SuperPlus", price: 23.33), Part(name: "Filters", price: 4.99)]))

````

First off we create a RequestMediator. Next we define our mechanics, setting their mediator and location.

Next we add all the mechanics to the mediator.

Now we have our mechanics sending request, lets see how mechanics close respond to these request:

````swift
Joe Bob received request from Steve Akio: I can't find this address anyone close by knows where Rengstorff Ave is?
******************
Steve Akio received request from Joe Bob: I need some brake pads anyone close by has some?
request is for parts:
StopIt Brake Pads
******************
Mike Nearfar received request from Dave Far: Dang it I spilled all my oil, anyone around here got a spare 5 Quart Jug.. and some filters too
request is for parts:
Engine Oil SuperPlus
Filters
******************
Program ended with exit code: 0
````

we can see that Steve Akio and Joe Bob are close by so a request by Steve is received by Joe but not by Dave or Mike who are further than 50 units. Conversely a message sent by Mike is received by Dave and not Steve or Joe.

Congratulations you have just implemented the Mediator Design Pattern to sovle a nontrivial problem

The repo for the complete project can be found here:<a href="https://github.com/kingreza/Swift-Mediator"> Swift - Mediator </a> Download a copy of it and play around with it. See if you can find ways to improve it. Here are some ideas to consider:
<ul>
	<li>How can we factor out the necessary part from the Mechanic class to we can extend the mediator for other possible actors that wish to be part of the mediator.</li>
	<li>What can go wrong when two objects reference each other and what can we do prevent it.</li>
	<li>To keep the traffic of request low, have mechanics keep an inventory of parts they have and send the request to the mechanic if and only if they have the spare parts.</li>
</ul>