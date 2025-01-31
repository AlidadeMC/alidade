//
//  tiles.h
//  CubiomesKit
//
//  Created by Marquis Kurt on 31-01-2025.
//

#ifndef TILES_H
#define TILES_H

#include "generator.h"
#include "layers.h"

/// Pre-seeds a generator given a specific Minecraft version and a seed.
/// - Parameter g: The generator to pre-seed.
/// - Parameter mc: The version of Minecraft the generator should use.
/// - Parameter flags: The flags to pass into the generator setup.
/// - Parameter seed: The seed to generate.
/// - Parameter dim: Dimming settings.
void seedGenerator(Generator *g, int mc, uint32_t flags, int64_t seed, int dim);

#endif
