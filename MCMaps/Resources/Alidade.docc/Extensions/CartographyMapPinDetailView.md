# ``CartographyMapPinDetailView``

### Image Uploading

The pin detail view supports uploading images through the player's Photos
library and file selection from the Finder. On iOS and iPadOS, the Photos
option will appear as the only option, "Add Photos". The state of the photo
picking is handled internally, and the resulting data will be relayed back
to the view model.

#### Selection from Finder

On macOS, the option for selecting a file from disk through the Finder is
available. Both options will appear under an "Add Photos" section, with
each option displayed as buttons: "From Photos", and "From Finder",
respectively. The state of the open panel is handled automatically by the
view, and the resulting data will be relayed back to the view model.
