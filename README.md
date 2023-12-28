# RatingControl

`RatingControl` is a SwiftUI "rating" control (pretty self-explanatory). Anything can be used for empty and filled images (they can really be any type of view, not just `Image`s).

Be default, each icon's frame is set by the size of the empty icon so changes to each icon's state doesn't change the overall position of the control. This can be changed with the `.controlSizingMode(_:)` modifier.

## To-Do's

- [ ] Figure out how to do partial values
    - change bound value from `Int` to `Double` (use `Slider`'s initializers as reference for generic number)
    - use `.mask` modifier?
