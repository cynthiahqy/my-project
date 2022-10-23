
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Attempts at visualising panel maps

This repo contains a collection of ggplot experiments for visualising
panel maps use in [`{conformr}`](https://github.com/cynthiahqy/conformr)
documentation

<!-- badges: start -->
<!-- badges: end -->

## Experiments

This is this mapping function I tried to visualise:

    #> # A tibble: 5 × 3
    #>   from  to    weighted
    #>   <chr> <chr>    <dbl>
    #> 1 BLX   BEL        0.5
    #> 2 BLX   LUX        0.5
    #> 3 E.GER DEU        1  
    #> 4 W.GER DEU        1  
    #> 5 AUS   AUS        1

ggplot extensions I experimented with (code in `R/` folder):

-   `{ggraph}`: way too flexible, no sensible way to keep the `from`,
    and `to` nodes lined up. Found some good `{tidygraph}` and
    `{ggraph}` resources though:
    -   <https://mr.schochastics.net/material/netVizR/>

    -   <https://dgarcia-eu.github.io/SocialDataScience/4_SNA/045_Tidygraph/tidygraph.html>
-   [`{ggsankey}`](https://github.com/davidsjoberg/ggsankey): keeps
    `from` and `to` nodes stacked in “stages”, and connects nodes in
    each stage with “flow” ribbons
    -   [sankey diagram defintion and use
        cases](https://www.data-to-viz.com/graph/sankey.html)
    -   [sankey diagram
        gallery/blog](https://www.sankey-diagrams.com/page/2/)
-   [`{ggalluvial}`](https://github.com/corybrunson/ggalluvial):
    terminology in documentation (lodes/alluvia/stratum..) was a bit
    difficult to follow (use
    [cheatsheets!](https://jtr13.github.io/cc21fall2/ggalluvial-cheatsheet.html));
    too rigid for my purposes, and rescaling of `weighted` as flows
    between nodes obscures the weight information
-   [`{ggbump::geom_bump}`](https://github.com/davidsjoberg/ggbump#tutorial):
    removes the “flow” to line-width connection from sankey/alluvials,
    and adds some flexibility for node positioning, but is annoyingly
    restrictive requirements for `aes()` mapping – couldn’t quite map
    data into “rank” format
-   [`{ggbump::geom_sigmoid}`](https://github.com/davidsjoberg/ggbump#sigmoid-curves-examples):
    more flexible geom that probably powers `geom_bump()`, just requires
    calculation of starting and ending x,y coordinates for each
    set/stage of nodes.

Aside on errors when reproducing the map with sigmoid curves from
`ggbump` readme:

-   [original
    code](https://github.com/davidsjoberg/tidytuesday/blob/master/2020w17/2020w17_skript.R)
    vs. [modified code for sf \> 1.0](R/ggbump-sigmoid-map.R)
-   need to turn off s2 spherical geometry using `sf_use_s2(FALSE)` –
    see [github issue](https://github.com/r-spatial/sf/issues/1759)
-   might have been calling the wrong version of `format()` but changing
    `digits = 0` to `digits = 1` seemed to fix the error

## Visualisation Results

labelled bump plot: [code](R/ggbump-sigmoid-graph-edges.R)

-   consider renormalising the nodes/labels to fit within a range

![labelled bump plot](ggbump-sigmoid-graph-edges.jpg)

sankey flow diagram using `{ggsankey}`: [code](R/ggsankey.R)

![sankey flow diagram](ggsankey.png)

alluvial plot using `{ggalluvial}`: [code](R/ggalluvial.R)

<figure>
<img src="ggalluvial.png" width="445" alt="alluvial plot" />
<figcaption aria-hidden="true">alluvial plot</figcaption>
</figure>
