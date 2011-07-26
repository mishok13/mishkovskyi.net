---
categories: general,python
date: 2011/07/26 15:20:00
draft: True
title:
---

This is the first of three blog posts I wanted to write for a long
time after writing `this <http://mishkovskyi.net/blog/2011/01/16/tile-server-implementation>`_
article. This article covers usage of Twisted
at CloudMade as well as overview of other choices. The following two
posts will cover other major Python libraries used by CloudMade.

Rebuttal
========

Previous article caused some raised eyebrows among its readers --
"Why did you select Python when there was Ruby/Perl/Java/whatever?!".
Now, I know many programmers are religious about the language of
their choice, but I consider myself lucky enough to be programming
language atheist. We had very good reasons to choose Python:

* Mapnik, the rendering library behind tiles at CloudMade is written
in C++ with builtin Python bindings. There were exactly 0 (zero)
Perl or Ruby bindings at the time and as of now I know of only one
other good set of Mapnik bindings -- and even they are for
`JavaScript <https://github.com/mapnik/node-mapnik>`_.
Choosing between C++ and Python was a no-brainer, because most of the
work that had to be done was to be tightly tied to I/O.
* Python actually has a very good set of GIS libraries, with Shapely,
pyproj and GDAL binding standing out. Consider existence of libraries like
numpy which is considered one of the best libraries for matrix handling
and there you have it -- Python being on par with both Java with its JTS
and C++ with all the power of GEOS and Proj.4.
So, did we consider Ruby, Perl or any other programming languages? Yes,
we very much did. Were they on par with Python? No, at that time they
weren't. Now I'm going to actually start the article.

Architecture
============

If you're an OpenStreetMap user or developer, there might be a chance
that you've heard about Tirex project. If you did, you might know that
it is a combination of Perl-based utilities for managing multiple rendering
backends. So instead of going into longish description of how CloudMade
internal rendering architecture works I'd suggest looking for Tirex
blogpost describing how it works. If you understand the Tirex design
then there are good news -- triton's design is almost identical! Oh, hey,
I think I saved a good thousand lines by skipping architecture description!

Anyway, triton implements a simple idea of maximizing decoupling of our
tile server elements thus giving us better ways to handle increased load
("scale" that is). You might have guessed that having queue dispatcher
means that each request gets into queue before getting processed by the
rendering backend, which in turn means a lot of I/O for request
processing.

Well, how do you start writing queue dispatcher in Python?
If you're a beginner in Python's networking I/O code but you know that
you have sockets, you type "python socket" in google search and get
a link to socket module documentation. After that you start reading
about sockets, nonblocking, read wonderful "Python Networking HOWTO" write
your first multithreaded socket server and hoorray! You've got yourself
a web-scale server! But no, seriously, you didn't, instead what you've
written can be described a bag of bugs. At first it looks ok, your testing
shows that it handles hundreds, if not thousands requests per second and
it should be enough for you. You complete functionality, test it again and
it works slower, but it's ok, you probably wont need more than 100 requests
per second in production. You push to QA, they deploy to staging servers and
BAM! It fails miserably. So, what happened? Oh, see, the real world is full
of issues, such as failing accept, overrunning TCP stack size, dropping
connections and much much more. Why would you want to care about that?
This is were libraries such as Twisted come in. Twisted is an abstraction
over events and surprisingly enough, network I/O is full of events --
incoming connection, bytes being delivered and sent, connections closing --
which makes Twisted a good choice


Problems
========

Well, you'd think everything is nice and shiny in the kingdom of Twisted,
wouldn't you? No matter how nice Twisted is, the main gripe with it is
its documentation. The situation is improving, but it's still not good
enough to recommend learning Twisted to inexperienced developers.
