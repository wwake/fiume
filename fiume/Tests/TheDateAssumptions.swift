@testable import fiume
import fiume_model
import Testing

@Observable
public class DateAssumptions {

}

struct TheDateAssumptions {
  func makeDateAssumptions() -> DateAssumptions {
    DateAssumptions()
  }

//  @Test
//  func zero() {
//    let sut = makeDateAssumptions()
//    sut.wasChanged = false
//
//    sut.add(DateAssumption("Holiday", 2030.jan))
//
//    #expect(sut.wasChanged)
//    #expect(sut.find("Holiday") != nil)
//  }
}
