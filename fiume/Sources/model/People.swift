import SwiftUI

@Observable
class People {
  var people = [Person]()

  func add(_ person: Person) {
    people.append(person)
  }

  var count: Int {
    people.count
  }
}
