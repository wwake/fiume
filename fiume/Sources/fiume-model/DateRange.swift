public struct DateRange: Equatable {
  public var first: DateSpecifier
  public var last: DateSpecifier

  public static var null = DateRange(.unchanged, .unchanged)

  public init(_ first: DateSpecifier, _ last: DateSpecifier) {
    self.first = first
    self.last = last
  }

  public func includes(_ month: MonthYear, _ people: People) -> Bool {
    switch first {
    case .unchanged:
      break

    case let .month(startMonth):
      if month < startMonth { return false }

    case let .age(id, age):
      guard let person = people.findById(id) else { return false }
      let birth = person.birth
      let effectiveStart = birth.advanced(byYears: age)
      if month < effectiveStart { return false }
    }

    switch last {
    case .unchanged:
      return true

    case .month(let endMonth):
      if month > endMonth { return false }
      return true

    case let .age(id, age):
      guard let person = people.findById(id) else { return false }
      let birth = person.birth
      let effectiveEnd = birth.advanced(byYears: age)
      if month >= effectiveEnd { return false }
      return true
    }
  }

  public func description(_ people: People) -> String {
    "\(first.description(people))-\(last.description(people))"
  }
}
