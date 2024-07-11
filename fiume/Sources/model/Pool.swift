import Foundation

struct Pool: Identifiable, Codable {
  static var null = Pool(name: "", amount: Money(0), first: .unchanged, last: .unchanged)

  var id = UUID()
  var name: String
  var amount: Money
  var first: DateSpecifier
  var last: DateSpecifier

  var isNonNegative: Bool {
    amount >= 0
  }

  func amount(at month: MonthYear, people: People) -> Money {
    Stream.amount(first: first, last: last, amount: amount, at: month, people: people)
  }

  func update(overriddenBy pool: Pool) -> Pool {
    if self.name != pool.name { return self }

    let newFirst = self.first.update(using: pool.first)
    let newLast = self.last.update(using: pool.last)

    return Pool(name: pool.name, amount: pool.amount, first: newFirst, last: newLast)
  }
}
