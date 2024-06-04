import Foundation

struct MonthYear: Equatable {
  let month: Int  // 0-based
  let year: Int   // 1-based

  let months = [
    "January", "February", "March",
    "April", "May", "June",
    "July", "August", "September",
    "October", "November", "December",
  ]

  init(month: Int, year: Int) {
    self.month = month
    self.year = year
  }

  init(date: Date) {
    let calendar = Calendar.current
    self.year = calendar.component(.year, from: date)
    self.month = calendar.component(.month, from: date) - 1
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
    "\(months[month]), \(year)"
  }
}

extension MonthYear: Strideable {
  private func toMonthCount() -> Int {
    year * 12 + month
  }

  private func toMonthYear(_ months: Int) -> MonthYear {
    MonthYear(month: months % 12, year: months / 12)
  }

  func advanced(by n: Int) -> MonthYear {
    toMonthYear(self.toMonthCount() + n)
  }

  func distance(to other: MonthYear) -> Int {
    other.toMonthCount() - self.toMonthCount()
  }
}
