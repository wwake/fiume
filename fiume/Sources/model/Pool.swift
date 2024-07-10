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
}
