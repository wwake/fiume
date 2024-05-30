import SwiftUI

@Observable
class Family {
  var people = [Person]()

  func add(_ person: Person) {
    people.append(person)
  }
}
