import SwiftUI

struct AgeSelector: View {
  @Binding var dateSpec: DateSpecifier

  @State var age = 50

  func updateValues() {
    dateSpec = .age(Person(name: "Bob", birth: 2000.jan, death: nil), age)
  }

  var body: some View {
    GeometryReader { geometry in
      HStack {
        Picker("Age", selection: self.$age) {
          ForEach(1...100, id: \.self) {
            Text(verbatim: "\($0)")
              .tag($0)
          }
        }
        .halfSize(geometry.size)
        .onChange(of: age) {
          updateValues()
        }
      }
    }
  }
}

#Preview {
  @State var dateSpec = DateSpecifier.unchanged
  return AgeSelector(dateSpec: $dateSpec)
}
