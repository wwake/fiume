import SwiftData
import SwiftUI

class People {
  var people = [Person]()

  init() { }

  func add(_ person: Person) {
    people.append(person)
  }

  var count: Int {
    people.count
  }
}
