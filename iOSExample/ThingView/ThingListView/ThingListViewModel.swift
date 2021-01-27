import Combine
import Foundation

extension ThingListView {
    class ViewModel: ObservableObject {

        @Published var things: [Thing] = []
        @Published var alertPresent = false
        
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
    }
}
