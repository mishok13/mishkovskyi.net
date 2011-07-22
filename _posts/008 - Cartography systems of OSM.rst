---
categories: osm
date: 2010/03/01 00:00:00
title: Overview of cartography systems for OSM
---

*This post has been featured as research paper on my employee's*
`research page <http://cogniance.com/expertise/research_papers>`_

There have been a lot of talks and new projects built around maps
and cartography services, but it seems like there's not a lot of
interest in building beautiful maps. While I agree that not
every person around has the skills to create perfect map, it's
certainly nice to have tools to do that. This article will try
to highlight current solutions and their highs and lows.
But at first, some theory is necessary.

--------
Overview
--------

+++++++++++
Definitions
+++++++++++

======
Layers
======

Layers are essential part of any cartography style system. By using layers you can combine
data that is contained in different projections or data source. Layers give you ability
of defining the order in which map is rendered. Layers also give you enough abstraction
over the pure data, which means that working with layers is way easier than simply
querying data sources.

=====
Rules
=====

Rules define how certain kind of data should be rendered. For example, rule for primary highways
on "roads" layer could contain description of coloring scheme, width of the rode, width and color
of the border. You could also tune amount of shields rendered or the way corners are rendered.
All of these parameters are described by the corresponding rule. Individual rules are often
combined into so-called rulesets, which are then applied against different layers. This is often
handy when you have several layers which contain similar data (e.g. two layers having different
data sources -- PostGIS and ESRI shape files, both containing POI data).

=======
Summary
=======

So, what defines a good cartography styling?

1. First of all, powerful rules. The more ways
   there're to change the output of the map, the better. One should understand that such power
   doesn't come for free, it requires performance trade-offs. So, we get to the second point

2. rules should be simple enough so we can combine them into rulesets. Simple rules give us a
   bonus point of light performance degradation, while still having the ability to create
   complex rulesets.

3. Third: layers should have the ability to use different data sources. The more
   data sources you can use, the easier it's for the users of the system to build maps.

-------------------
Real-world examples
-------------------

++++++
Mapnik
++++++

.. image:: /images/mapnik.jpg
   :width: 500

========
Overview
========

Mapnik is the rendering engine used by main OpenStreetMap view.
The project was started in 2005 by Artem Pavlenko as a general
map rendering framework. The number one objective of the project
is to create a library that would be able to render beautiful
maps. To achieve this, Anti-Grain Geometry library was chosen
as a backend. Unfortunately, AGG author seems to have stopped
active development of the library. Mapnik is written in C++ and
has quite advanced Python bindings.

============
Style system
============

Mapnik uses XML files to define style of the map. These files
contain two important sections: ``Layers`` and ``Styles``. ``Styles``
section contains named rulesets, where every ``Style`` has several
``Rule``\s that define rules (obviously).
``Layers`` contain description of layers in order of rendering
(first defined -- first rendered). Mapnik layer support is a
great example of abstraction that doesn't leak and IMHO should be
used a reference when designing your own layer system.
One additional note regarding font support in Mapnik. You can
define several fall-back fonts for a given style file, using
``FontSet`` directive. This is used often for fonts with
limited language support (e.g. DejaVu, which doesn't have complete
Asian font support).

===========
Pros & Cons
===========

**Pros**

* Great layer implementation
     Mapnik does layer support in the most correct way possible.
* Font fall-back support
     This feature gives ability to use beautiful maps where appropriate, while still being able to support rendering of all symbols.
* Pattern symbolizing support
     Gives ability to add shields on any geometrical figure the easy way.

**Cons**

* Using XML for style files
     Choosing XML in 2005 may sounded like a good idea, when it was the
     fastest way of serializing data, but now, when we have efficient
     JSON and YAML parsers, sticking to XML is a mistake. Style files
     should be easy for people to comprehend, not computers.
* Limited zoom support
     Mapnik doesn't support extended zoom syntax in ``Rule`` directives
     and thus you have to break DRY principle often when writing Mapnik
     styles.
* Mixing data access and style information (layers and styles)
     Layers and Styles should be defined in different files. This is a
     minor inconvenience for most people, but as an employee of
     CloudMade I feel really strong about this one. Some time in the
     distant past CSS and HTML were mixed up in one file, but humans
     came to realizing the fact this is often wrong, and now most, if
     not all, sites are splitting HTML and CSS into separate files.
     I hope the same will happen to Mapnik's style files someday.


========
See also
========

* `Official Mapnik site and wiki <http://trac.mapnik.org>`_
* `Richard Weait's rant on shield support in Mapnik <http://www.weait.com/content/badges-badges>`_

++++++
MapCSS
++++++

.. image:: /images/mapcss.jpg
   :width: 500

========
Overview
========

MapCSS is the style specifically developed for Halcyon  rendering
engine. The engine itself is being developed by Richard Fairhurst
and is already being used for Potlatch 2 OpenStreetMap editing tool.
The engine is written in ActionScript and uses Flex.

============
Style system
============

As seen from the name, MapCSS is a superset of CSS designed
specifically for cartography purposes. The approach to defining
rules is simple -- define selector which defines the subset of data
and then define object properties (e.g. width, opacity, etc.). You
can read about MapCSS selector and properties syntax on the
OpenStreetMap wiki.

===========
Pros & Cons
===========

* Powerful selector syntax
     Defining subsets of data is really easy with MapCSS and should
     regarded as the definite advantage. For example, you can use
     regular expressions in selectors.
* `eval` support
     This gives a lot of opportunities for dynamically changing
     the style of the map. Calling `eval` can be regarded as a
     disadvantage from the performance point of view, but it makes
     defining styles a more pleasant experience.

Cons

* OpenStreetMap API is the only datasource
     This is very unfortunate, but having no way of defining other data
     sources kills MapCSS's usage for anything else but OSM editing.
* No explicit layer support
     This might be merged with the previous point. Having no explicit
     layer support limits areas of application for MapCSS.
* No shield supports
     Shields are not supported yet in MapCSS, but I hope they will be
     there eventually
* No grammar definition
     MapCSS *looks* like CSS, but it's not and it would be very nice to
     have complete description (besides notes on usage in OpenStreetMap
     wiki).

========
See also
========

* `MapCSS description and tips on usage <http://wiki.openstreetmap.org/wiki/MapCSS>`_
* `Halcyon rendering engine <http://geowiki.com/halcyon>`_

+++
GSS
+++

.. image:: /images/gss.jpg
   :width: 500

========
Overview
========

GSS (Geo Style Sheets) is a cartography style sheet
developed by `Cartagen <http://cartagen.org>`_ team.
To cite their wiki::

   Cartagen lets you make beautiful, customized maps with a simple stylesheet


============
Style system
============

GSS is a subset of JavaScript, which tries to look like CSS

===========
Pros & Cons
===========

Pros

* Datasources support through HTTP API
     Any datasource can be added by defining its HTTP API, which
     is simple and convenient at the same time.
* Layers support
     Due to the dynamic nature of GSS, layers are extremely easy
     to add and are indeed built in client library.

Cons

* Targeted at dynamic environments
     It's not often cartographers need dynamic maps, and I regard
     lack of interest to static content as a major disadvantage.

.. * Only OSM as datasource
..      Unlike MapCSS, datasource support is not tied into
..      data model and the only thing GSS cares about is correct HTTP API
..      provider. Unfortunately, only OSM HTTP API is supported now.

++++++++++
Osmarender
++++++++++

.. image:: /images/osmarender.jpg
   :width: 500

========
Overview
========

Osmarender was designed for only one purpose -- that is, rendering OSM data.
The engine itself is a bunch of XSLT scripts, which take OSM files as input
and produce SVG maps as output.

============
Style system
============

Osmarender uses two files to create SVG map -- rules and styles.
Rules file is used to define the subsets of data while styles file
is a CSS which defines the way data will look.

===========
Pros & Cons
===========

**Pros**

* Based on SVG
     SVG is not great, for all I know, but it's an established standard and
     a good example of how a markup language can be used. SVG gives a lot of
     geometry features for free, thus allowing to concentrate on the data
     itself rather than algorithms of its rendering.
* Split of style and data information
     As was mentioned before, splitting data and presentation logic is a
     good thing and Osmarender follows good practices as well.

**Cons**

* Using XML for style files
     That's the same point I raised with Mapnik style files. In short: each
     time you use XML for cartography, god kills a kitten.
* Limited configuration options
     It's more of a problem with Osmarender itself, rather than the style,
     but I have to acknowledge that in order to make something unusual,
     you've got to be extremely knowledgeable about Osmarender internals.
* Lacking projection support
     Osmarender styles don't support any kind of in-style reprojecting,
     which leads to unusual bugs (see below).
* Only OSM files as datasource

========
See also
========

* The infamous `Osmarender bug <http://wiki.openstreetmap.org/wiki/Osmarender_bug>`_

+++++++
Summary
+++++++

So, what defines a really good cartography system? There're several
important characteristics:

* CSS-like properties for styling -- almost all systems get it right
* Good layer support -- this is hard to achieve while retaining
  readability, but I'm sure it will be done some day.
* Support for all kinds of data sources -- building beautiful maps
  while relying only one data source is often frustrating.
* Readability -- style systems should be designed for people, not
  computers.

All of these are essential to any cartography system and should be
targeted at first design iteration. You should also think about
font support, correct positioning of labels and shield, avoidance
of sharp edges and many other things. Designing a good
cartography system is hard, but it was done before and will be
done from time to time.

This covers most popular open source cartography systems currently
available in the wild. You might point to other solutions, such as
Kosmos, pyrender and many others, but as they're not as popular or
rather innovative, I didn't cover them in this article.
