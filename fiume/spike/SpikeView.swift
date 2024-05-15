import SwiftUI

struct Tree<Value: Hashable>: Hashable {
	let value: Value
	var children: [Tree]? = nil
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
					.init(value: "Slim")
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
	)
]

func makeCategories() -> [Tree<String>] {
	let newLeaf = Tree(value: "Old T-Shirts")
	let newTree = Tree(value: "new tree", children: [])
	
	categories[0].children!.insert(newTree, at: 0)
	categories[0].children![0].children!.append(newLeaf)

	return categories
}

struct SpikeView: View {
	@State private var categories = makeCategories()

	var body: some View {
		List {
			ForEach(categories, id: \.self) { section in
				Section(header: Text(section.value)) {
					OutlineGroup(
						section.children ?? [],
						id: \.value,
						children: \.children
					) { tree in
						Text(tree.value)
							.font(.subheadline)
					}
				}
			}
		}.listStyle(SidebarListStyle())
	}
}


#Preview {
	SpikeView()
}
