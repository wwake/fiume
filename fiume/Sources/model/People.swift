import SwiftUI

@Observable
class People: Codable {
  var wasChanged: Bool
  var people: [Person]

  init() {
    people = [Person]()
    wasChanged = false
  }

  init(_ people: [Person]) {
    self.people = people
    wasChanged = false
  }

  func add(_ person: Person) {
    people.append(person)
    wasChanged = true
  }

  var count: Int {
    people.count
  }
}

extension People: Sequence {
  func makeIterator() -> some IteratorProtocol {
    people.makeIterator()
  }
}
