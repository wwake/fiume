import Charts
import SwiftUI

struct ContentView: View {
	@Bindable var plan: Plan

	var body: some View {
		NavigationStack {
			Chart(plan.project(120)) {
				LineMark(
					x: .value("Month", $0.month),
					y: .value("Net Worth", $0.amount)
				)
			}
			.padding()

			PlanListView(plan: plan)
//			StreamListView(plan: plan)
			StreamListViewOriginal(plan: plan)
		}
	}
}

#Preview {
	let plan = Plan()
	plan.add(Stream("Salary", 1_000, last: 60))
	plan.add(Stream("Expenses", -800))
	return ContentView(plan: plan)
}

struct PlanListView: View {
	@Bindable var plan: Plan
	@State var isPresentingSheet = false

	var body: some View {
		List {
			ForEach(plan.contents, id: \.name) { plan in
				Section(header: HStack {
					Text(plan.name)
					Spacer()
					Button(
						" ",
						systemImage: "plus") {
							print("clicked")
						}
				}) {
						OutlineGroup(
							plan.children ?? [],
							id: \.name,
							children: \.children
						) { tree in
							Text(tree.name)
								.font(.subheadline)
						}
					}

				//				StreamView(stream: $0)
				//					.listRowBackground($0.monthlyAmount < 0 ? Color.red : Color.green)
			}
			.onMove { indexSet, offset in
				plan.contents.move(fromOffsets: indexSet, toOffset: offset)
			}
			.onDelete { offsets in
				plan.contents.remove(atOffsets: offsets)
			}
		}
		.listStyle(.grouped)
		.toolbar {
			ToolbarItemGroup {
				Button(
					"Add",
					systemImage: "plus") {
						isPresentingSheet.toggle()
					}
					.sheet(isPresented: $isPresentingSheet) {
						CreateStreamView(plan: plan)
					}
				EditButton()
			}
		}
		.padding()
	}
}

struct StreamListView: View {
	@Bindable var plan: Plan
	@State var isPresentingSheet = false

	var body: some View {
		List {
			ForEach(plan.contents, id: \.name) { plan in
				Section(header: HStack {
					Text(plan.name)
					Spacer()
					Button(
						" ",
						systemImage: "plus") {
							print("clicked")
						}
				}) {
						OutlineGroup(
							plan.children ?? [],
							id: \.name,
							children: \.children
						) { tree in
							Text(tree.name)
								.font(.subheadline)
						}
					}

				//				StreamView(stream: $0)
				//					.listRowBackground($0.monthlyAmount < 0 ? Color.red : Color.green)
			}
			.onMove { indexSet, offset in
				plan.contents.move(fromOffsets: indexSet, toOffset: offset)
			}
			.onDelete { offsets in
				plan.contents.remove(atOffsets: offsets)
			}
		}
		.listStyle(.grouped)
		.toolbar {
			ToolbarItemGroup {
				Button(
					"Add",
					systemImage: "plus") {
						isPresentingSheet.toggle()
					}
					.sheet(isPresented: $isPresentingSheet) {
						CreateStreamView(plan: plan)
					}
				EditButton()
			}
		}
		.padding()
	}
}

struct StreamListViewOriginal: View {
	@Bindable var plan: Plan
	@State var isPresentingSheet = false

	var body: some View {
		List {
			ForEach(plan.streams.reversed()) {
				StreamView(stream: $0)
					.listRowBackground($0.monthlyAmount < 0 ? Color.red : Color.green)
			}
			.onMove { indexSet, offset in
				plan.streams.move(fromOffsets: indexSet, toOffset: offset)
			}
			.onDelete { offsets in
				plan.streams.remove(atOffsets: offsets)
			}
		}
		.toolbar {
			ToolbarItemGroup {
				Button(
					"Add",
					systemImage: "plus") {
						isPresentingSheet.toggle()
					}
					.sheet(isPresented: $isPresentingSheet) {
						CreateStreamView(plan: plan)
					}
				EditButton()
			}
		}
		.padding()
	}
}
