import SwiftUI

@Observable
class People: Codable {
  var wasChanged = false
  var people: [Person]

  init() {
    people = [Person]()
  }

  init(_ people: [Person]) {
    self.people = people
  }

  func add(_ person: Person) {
    people.append(person)
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
