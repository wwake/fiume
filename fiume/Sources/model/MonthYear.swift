struct MonthYear {
  let month: Int
  let year: Int

  let months = [
    "January", "February", "March",
    "April", "May", "June",
    "July", "August", "September",
    "October", "November", "December",
  ]
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
