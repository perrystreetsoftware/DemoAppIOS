# DemoAppIOS
Demo architecture for iOS with SwiftUI and layers.

We have 4 layers for SwiftUI

## Adapter
Converts from a ViewModel to a UIState object

## Page
Top-most SwiftUI component (after the adapter) that is the logical container for all of the content on the page

## Content
Inner-view that has a piece of the total content on the page. Only uses bindings and lambdas.

## UIState
Mapping of @Published properties on ViewModel to necessary properties to render the UI. Comes with a static constructor as well for Previews.
