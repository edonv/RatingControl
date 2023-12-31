# RatingControl

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2FRatingControl%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/edonv/RatingControl)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fedonv%2FRatingControl%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/edonv/RatingControl)

`RatingControl` is a SwiftUI "rating" control (pretty self-explanatory). Anything can be used for empty and filled images (they can really be any type of view, not just `Image`s).

Be default, each icon's frame is set by the size of the empty icon so changes to each icon's state doesn't change the overall position of the control. This can be changed with the `.ratingControlIconFrameSizingMode(_:)` modifier.

While normal modifiers such as `.foregroundColor(_:)` and `.foregroundStyle(_:)` can be used to color/style the control, the `.ratingControlEmptyIconColor(_:)` and `.ratingControlFilledIconColor(_:)` modifiers can be used to color each type of icon separately. 

## To-Do's

- [x] Figure out how to do partial values
    - change bound value from `Int` to `Double` (use `Slider`'s initializers as reference for generic number)
    - use `.mask` modifier?
    - make sure to take into account padding
    - [x] figure out decimal maximumValues
- [ ] for `.dynamic` sizing mode: maybe solution is to make an actual `ViewModifier` with a @State var that reads preferencekey changes and calculates the masking scale and calc's the frame width?
- [ ] add tvOS exclusive modifier that specifies stride/increment
    - [ ] also maybe replace Button with some sort of custom tvOS control where just pressing left/right changes the value by the increment
- [ ] add tappable increment via modifier
- [ ] add increment value to inits or environmentvalue
    - this would affect dragging. if it's `nil`, full decimal values. otherwise, snap to values
    - also maybe alternate initializer that takes `Binding<Int>`?
