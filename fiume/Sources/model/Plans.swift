import Foundation

@Observable
class Plans: Codable {
  var plans = [Plan.makeAnd("My Finances")]

//  init(_ people: [Person]) {
//    self.people = people
//  }

  func append(_ plan: Plan) {
    plans.append(plan)
  }

  func removeAll() {
    plans.removeAll()
  }
}

//extension People: Sequence {
//  func makeIterator() -> some IteratorProtocol {
//    people.makeIterator()
//  }
//}
