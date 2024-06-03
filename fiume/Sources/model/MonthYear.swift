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
