---
categories: python,pycons
date: 2011/04/14 14:25:00
title: PyCon tutorial slides are up!
---

I've finally managed to get the slides on my site, so
`here <http://mishkovskyi.net/pycon2011>`_ you go!
On an almost unrelated note, here's a tiny cute one-liner that I've used
to create a zip of all the code used in slides::

   grep "\\lstinputlisting" slides.tex | \
   sed 's/.*{\(.*\)}.*/\1/' | \
   zip -@ pycon2011-code.zip
