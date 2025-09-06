# Search for landmarks

Search for relevant landmarks such as biomes, structures, and pinned locations.

@Metadata {
    @TitleHeading("User Guide")
    @PageColor(yellow)
    @Available("Alidade", introduced: "2025.2")
    @PageImage(purpose: icon, source: "Icon-Guide")
}

> Note: On macOS Sequoia and iOS/iPadOS 18, the search bar appears on the
> main window labeled by 'Go To...'.

## Search for structures

When searching for a structure, Alidade will attempt to search within
twenty (20) chunks, relative to your current position. 

1. Go to the Search tab and tap the search bar.
2. Type the name of the structure you'd like to search for. For example, to
   search for a mine shaft, type '`Mineshaft`'.
3. The search results should appear below the search bar. If no results
   were found, you may need to try in a different location.

## Search for biomes

When searching for a biome, Alidade will attempt to search within
eight-thousand (8000) blocks relative to your current position. 

1. Go to the Search tab and tap the search bar.
2. Type the name of the biome you'd like to search for. For example, to
   search for a pale garden, type '`Pale Garden`'.
3. The search results should appear below the search bar. If no results
   were found, you may need to try in a different location.

## Refine search results

Starting with Alidade v2025.2, filters can be applied to refine search
results even further to better find what you're looking for.

### Change where to search from

By default, Alidade will search for biomes and structures based on where
you are on the map. However, you can specify the origin from where to
search with a filter. To change the search origin, type the X and Z
coordinates with `@{x,z}`, where `x` and `z` represent the X and Z
coordinates. For example, to search from X=10, Z=55, type `@{10,55}` in
the search bar. 

You should see a search suggestion appear with the coordinates you
provided, which you can press to activate the filter:

![A search filter with a location](Search-Filter-Location)

### Filter by pin tags

If you have pins with a specific tag you'd like to search for, you can
type the tag into the search bar. You should see a search suggestion
appear that you can use to filter by that tag:

![A search filter with a tag](Search-Filter-Tags)
