@testable import fiume
import Foundation
import Testing

struct AMonthYear {
  @Test
  func compares_year_if_one_is_less() {
    let a = MonthYear(month: 3, year: 2000)
    let b = MonthYear(month: 5, year: 1999)
    #expect (a > b)
    #expect (b < a)
  }

  @Test
  func compares_month_if_years_are_equal() {
    let a = MonthYear(month: 3, year: 2020)
    let b = MonthYear(month: 5, year: 2020)
    #expect (a < b)
    #expect (b > a)
  }

  @Test
  func is_same_only_if_month_and_year_are_the_same() {
    let a = MonthYear(month: 3, year: 2020)
    let b = MonthYear(month: 5, year: 2020)
    #expect((a) == a)
    #expect(a != b)
  }

  @Test
  func initializes_from_date() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM"
    dateFormatter.locale = Locale(identifier: "en_US")

    let date = dateFormatter.date(from: "2016-10")
    let sut = MonthYear(date: date!)
    #expect(sut.year == 2016)
    #expect(sut.month == 9)
    #expect(sut.description == "October, 2016")
  }
}
