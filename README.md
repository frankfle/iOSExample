#iOS Example

This is a small example project to demonstrate SwiftUI/Combine in an archetecture inspired by [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) by Robert Martin.

The app has a small number of features:
1.  A list of Things
2.  Create a Thing
3.  A thing can be "visible" or "invisible" which is indicated in the list.
4.  We can fail at creating a Thing
5.  There is a detail view in which a Thing's visibility can be changed

The View is accomplished in SwiftUI.  There is a ListView, a ListItem, and a DetailView for Thing.  Functionality
has been abstracted out from the view code into the ViewModel, which is defined as an extention to the ListView
in order to scope it (so the type is `ThingListView.ViewModel`).

The ViewModel is an `ObservableObject`, which means it has `@Published` properties to which SwiftUI
can directly bind.  It also has functionality which can easily be called from SwiftUI actions.  This ViewModel
is a little overloaded, so it can not only list Things, but update them.  This functionality is implemented
in the DetailView, so it will need to know about the ViewModel.  This is done by the `@EnvironmentObject` in
the ThingListView.  It is created and passed in by the owner of the ListView, and is then available as an
`@EnvironmentObject` to any decendent.  Note how it's used in the ListView and the DetailView, but not in
the intermediat ListItem.

The ViewModel accomplishes its goals by using UseCases and Entities.  There is one simple Entity for this
app called Things, and there are several use cases for listing, creating, modifying the Things, and also
one to simulate an error.

This app contains a single data store to manage the Things.  This is obviously a trivially simple implementation,
but normally this is where service code or disk storage code would go.  In more complex situations, it may
be advantageous to use a Repository to manage multiple data stores. 

The ViewModel and the Datastore are both fully unit tested, but the SwiftUI views are not unit tested.  Unit
tests on view code are of lower value and more difficult, even with the view being written in SwiftUI than
other code.

##Mobile Component Architecture
<img src="docs/mca.png" alt="Mobile Component Architecture"/>
