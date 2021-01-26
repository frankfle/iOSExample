import Combine
import Foundation

extension ThingListView {
    class ViewModel: ObservableObject {

        @Published var things: [Thing] = []
        @Published var alertPresent = false
        
        var pipe: AnyCancellable?

        let thingGetter: GetThingsUsecase = LocalThingsDatastore.default
        let thingCreater: CreateThingUsecase = LocalThingsDatastore.default
        let thingErrorer: CreateThingFailureUsecase = LocalThingsDatastore.default
        let thingUpdater: UpdateThingVisibilityUsecase = LocalThingsDatastore.default

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

        func receivedNewThings(newThings: [Thing]) {
            things = newThings
        }
    }
}
