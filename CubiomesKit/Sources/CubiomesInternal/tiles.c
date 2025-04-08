//
//  tiles.c
//  CubiomesKit
//
//  Created by Marquis Kurt on 31-01-2025.
//

#include "generator.h"
#include "util.h"

void seedGenerator(Generator *g, int mc, uint32_t flags, int64_t seed, int dim)
{
    setupGenerator(g, mc, flags);
    applySeed(g, dim, (uint64_t)seed);
}
