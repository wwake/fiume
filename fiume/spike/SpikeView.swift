import SwiftUI

struct Tree<Value: Hashable>: Hashable {
	let value: Value
	var children: [Tree]?

  var count: Int {
    var childCount = 0
    if children != nil {
      childCount = children!.map { $0.count }.reduce(0, +)
    }
    return 1 + childCount
  }
}

var categories: [Tree<String>] = [
	.init(
		value: "Clothing",
		children: [
			.init(value: "Hoodies"),
			.init(value: "Jackets"),
			.init(value: "Joggers"),
			.init(value: "Jumpers"),
			.init(
				value: "Jeans",
				children: [
					.init(value: "Regular"),
					.init(value: "Slim"),
				]
			),
		]
	),
	.init(
		value: "Shoes",
		children: [
			.init(value: "Boots"),
			.init(value: "Sliders"),
			.init(value: "Sandals"),
			.init(value: "Trainers"),
		]
	),
]

func makeCategories() -> [Tree<String>] {
	let newLeaf = Tree(value: "Old T-Shirts")
	let newTree = Tree(value: "new tree", children: [])

	categories[0].children!.insert(newTree, at: 0)
	categories[0].children![0].children!.append(newLeaf)

	return categories
}

struct XView: View {
  @Binding var arg: Tree<String>

  var body: some View {
    Text(arg.value)
      .font(.subheadline)
  }
}
struct SpikeView: View {
	@State private var categories = makeCategories()
  @State private var counter = 0

  var body: some View {
    VStack {
      Text("count=\(categories.count)")

      List {
        ForEach($categories, id: \.self) { section in
          //Section(header: Text(section.value)) {
          OutlineGroup(
            section,  // section.children ?? []
            id: \.value,
            children: \.children
          ) { tree in
            XView(arg: tree)
          }
          //	}
        }
      }.listStyle(SidebarListStyle())

      Button("Add") {
        counter += 1
        categories.append(Tree(value: "My \(counter)"))
      }
    }
  }
}

#Preview {
	SpikeView()
}
