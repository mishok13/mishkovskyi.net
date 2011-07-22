---
categories: python
date: 2010/09/02 09:30:00
title: Priority Queue for Twisted
---

In the past three months I've in a process of moving good old piece of
shitty, but working code I wrote from using threading to twisted. If
you don't count that one nasty deferToThread call which wraps blocking
rendering code (mapnik.render that is) I've been quite successful. But
there are several things that I had to rewrite completely in order to
make them non-blocking. One of those is PriorityQueue. You know,
`this one <http://docs.python.org/library/queue.html#Queue.PriorityQueue>`_\.
Now, Twisted *does* have an implementation of Queue (which is of course
called DeferredQueue, as if anything in Twisted is not deferred, but
anyway) and it quite successfully mimics API of the standard one, but
still no PriorityQueue. Let's take a look at how DeferredQueue is implemented::

   class DeferredQueue(object):

       def __init__(self, size=None, backlog=None):
           self.waiting = []
           self.pending = []
           self.size = size
           self.backlog = backlog

       def _cancelGet(self, d):
           self.waiting.remove(d)

       def put(self, obj):
           if self.waiting:
               self.waiting.pop(0).callback(obj)
           elif self.size is None or len(self.pending) < self.size:
               self.pending.append(obj)
           else:
               raise QueueOverflow()

       def get(self):
           if self.pending:
               return succeed(self.pending.pop(0))
           elif self.backlog is None or len(self.waiting) < self.backlog:
               d = Deferred(canceller=self._cancelGet)
               self.waiting.append(d)
               return d
           else:
               raise QueueUnderflow()

Pretty simple, eh? Well, it's simple for those of you familiar with
twisted. If you're not one of them, considering reading excellent
`"Twisted in 60 seconds" <http://jcalderone.livejournal.com/tag/sixty%20seconds>`_
tutorials from JP Calderone.

Due to the nature of the software I don't need limits on the size of the
queue as well I don't care how many deferreds are in waiting list, so I
can safely ignore these in my implementation::

   class DeferredPriorityQueue(DeferredQueue):

       def __init__(self):
           DeferredQueue.__init__(self, None, None)

       def put(self, obj):
           if self.waiting:
               self.waiting.pop(0).callback(obj)
	   else
               self.pending.append(obj)

       def get(self):
           if self.pending:
               return succeed(self.pending.pop(0))
           else
               d = Deferred(canceller=self._cancelGet)
               self.waiting.append(d)
               return d

The code becomes quite short. Now, to make items prioritized, we'll use
wonderful heapq module::

   class DeferredPriorityQueue(DeferredQueue):

       def __init__(self):
           DeferredQueue.__init__(self, None, None)

       def put(self, obj):
           if self.waiting:
               self.waiting.pop(0).callback(obj)
	   else
               heapq.heappush(self.pending, obj)

       def get(self):
           if self.pending:
               return succeed(heapq.heappop(self.pending))
           else
               d = Deferred(canceller=self._cancelGet)
               self.waiting.append(d)
               return d

Not that hard, isn't it? Now, the latest things, adding qsize() methods
to mimic original stdlib Queue API and peek() method, which returns
the highest priority item, without removing it from the queue (as Wikipedia
`page on the subject <http://en.wikipedia.org/wiki/Priority_queue>`_ suggests)::

   from twisted.internet.defer import Deferred, DeferredQueue, succeed
   import heapq

   class DeferredPriorityQueue(DeferredQueue):

       def __init__(self):
           DeferredQueue.__init__(self, None, None)

       def put(self, obj):
           if self.waiting:
               self.waiting.pop(0).callback(obj)
	   else
               heapq.heappush(self.pending, obj)

       def get(self):
           if self.pending:
               return succeed(heapq.heappop(self.pending))
           else
               d = Deferred(canceller=self._cancelGet)
               self.waiting.append(d)
               return d

       def peek(self):
           return succeed(heap[0])

       def qsize(self):
           return succeed(len(self.pending))

If you're wondering why I'm posting this, considering how simple it is
to implement on your own, here's the answer -- yesterday I've implemented
DeferredPriorityQueue for the third time, simply because google couldn't
find anything relevant when queried with "priorityqueue twisted" and I
forgot that I wrote this code twice before.

P.S. I'm not a fan of comment-less code, but the code is short and simple
and should be understood without any comment.
