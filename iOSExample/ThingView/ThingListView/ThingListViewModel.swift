import Combine
import Foundation

extension ThingListView {
    class ViewModel: ObservableObject {

        enum VisibilityFilter {
            case none
            case visible
            case invisible

            var visibility: Bool? {
                switch self {
                case .none: return nil
                case .visible: return true
                case .invisible: return false
                }
            }
        }

        // item management
        private var things: [Thing] = [] {
            didSet {
                resetFilters()
            }
        }
        // current view of items
        @Published var filteredThings: [Thing] = []

        // filters
        @Published var searchText: String = "" {
            didSet {
                resetFilters()
            }
        }
        @Published var visiblityFilter = VisibilityFilter.none {
            didSet {
                resetFilters()
            }
        }

        // view presenters
        @Published var alertPresent = false
        @Published var filterPresent = false


        var pipe: AnyCancellable?

        var thingGetter: GetThingsUsecase = LocalThingsDatastore.default
        var thingCreater: CreateThingUsecase = LocalThingsDatastore.default
        var thingErrorer: CreateThingFailureUsecase = LocalThingsDatastore.default
        var thingUpdater: UpdateThingVisibilityUsecase = LocalThingsDatastore.default

        func addThing() {
            thingCreater.create()
        }

        func addThingError() {
            thingErrorer.createFailure()
        }

        func clearAlert() {
            alertPresent = false
        }

        func updtateVisibility(thing: Thing, visibility: Bool) {
            thingUpdater.updateVisibility(thing: thing, isVisible: visibility)
        }

        func getThings() {
            pipe = thingGetter.getThings().sink(receiveCompletion: { [self] (error) in
                alertPresent = true
            }, receiveValue: { [self] (newThings) in
                things = newThings
            })
        }

        func resetFilters() {
            filteredThings = things

            // 1. filter by text
            if !searchText.isEmpty {
                filteredThings = filteredThings.filter { $0.name.contains(searchText.lowercased()) }
            }

            // 2. filter by visibility
            if let visibility = visiblityFilter.visibility {
                filteredThings = filteredThings.filter { $0.visible == visibility }
            }
        }
    }
}
