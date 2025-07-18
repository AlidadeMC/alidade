//
//  RedWindowPinDeletionRequest.swift
//  MCMaps
//
//  Created by Marquis Kurt on 18-06-2025.
//

/// A request to delete a pin from a given file.
///
/// This type is used in the ``RedWindowEnvironment`` to signal to the environment that the player is requesting to
/// delete pins from the library. This request typically originates from ``RedWindowPinLibraryView`` as the result of
/// a selection.
struct RedWindowPinDeletionRequest {
    /// The indices of the elements to delete from the pin collection.
    var elementIDs: Set<IndexedPinCollection.Element.ID> = []

    /// Whether to display the confirmation alert.
    var presentAlert = false
}
