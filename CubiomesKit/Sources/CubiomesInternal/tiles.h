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

/// Seeds an existing Minecraft world generator.
/// > Important: This shouldn't be called directly.
///
/// - Parameter g: The Minecraft world generator to seed.
/// - Parameter mc: The Minecraft version applicable to the world.
/// - Parameter flags: Related generator flags.
/// - Parameter seed: The seed applicable to the world.
/// - Parameter dim: The dimension applicable to the world.
void seedGenerator(Generator *g, int mc, uint32_t flags, int64_t seed, int dim);

#endif
