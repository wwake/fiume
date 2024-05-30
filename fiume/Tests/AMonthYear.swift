@testable import fiume
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
}
