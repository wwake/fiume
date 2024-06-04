import Foundation

private let months = [
  "January", "February", "March",
  "April", "May", "June",
  "July", "August", "September",
  "October", "November", "December",
]

enum Month: Int {
  case jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
}

extension Month: Comparable {
  static func < (left: Month, right: Month) -> Bool {
    left.rawValue < right.rawValue
  }
}

extension Month: CustomStringConvertible {
  var description: String {
    "\(months[self.rawValue])"
  }
}

struct MonthYear: Equatable {
  let month: Month
  let year: Int

  let months = [
    "January", "February", "March",
    "April", "May", "June",
    "July", "August", "September",
    "October", "November", "December",
  ]

  init(_ month: Month, _ year: Int) {
    self.month = month
    self.year = year
  }

  init(date: Date) {
    let calendar = Calendar.current
    self.year = calendar.component(.year, from: date)
    self.month = Month(rawValue: calendar.component(.month, from: date) - 1) ?? .jan
  }
}

extension MonthYear: Comparable {
  static func < (left: MonthYear, right: MonthYear) -> Bool {
    if left.year == right.year {
      return left.month < right.month
    }
    return left.year < right.year
  }
}

extension MonthYear: CustomStringConvertible {
  var description: String {
    "\(month), \(year)"
  }
}

extension MonthYear: Strideable {
  private func toMonthCount() -> Int {
    year * 12 + month.rawValue
  }

  private func toMonthYear(_ months: Int) -> MonthYear {
    MonthYear(Month(rawValue: months % 12)!, months / 12)
  }

  func advanced(by n: Int) -> MonthYear {
    toMonthYear(self.toMonthCount() + n)
  }

  func distance(to other: MonthYear) -> Int {
    other.toMonthCount() - self.toMonthCount()
  }
}
