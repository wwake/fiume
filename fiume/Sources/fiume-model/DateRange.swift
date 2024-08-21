public struct DateRange: Equatable, Codable {
  public var first: DateSpecifier
  public var last: DateSpecifier

  public static var always = DateRange(.unchanged, .unchanged)

  public init(_ first: DateSpecifier, _ last: DateSpecifier) {
    self.first = first
    self.last = last
  }

  public func includes(_ month: MonthYear, _ people: People) -> Bool {
    first.leq(month, people) && last.geq(month, people)
  }

  public func description(_ people: People) -> String {
    if self == DateRange.always {
      return ""
    }
    return "\(first.description)-\(last.description)"
  }
}
