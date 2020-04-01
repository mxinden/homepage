---
date: 2020-04-01T00:00:00Z
tags: [tech, paper, lock-free, multithreaded, concurrent, rust, crossbeam]
title:  Elimination back-off stack performance
type: "posts"
---

I recently stumbled upon the idea of an *Elimination Back-off Stack* promising
to be a **parallel**, linearizable and lock-free stack. In case you are not
familiar with it, I would suggest either reading my [previous
post](/blog/2020-03-28-elimination-backoff-stack/) or the corresponding paper
[1] itself. Being quite intrigued by the ideas of the above stack I wrote [my
own implementation](https://github.com/mxinden/elimination-backoff-stack/) in
Rust with a *little* help from
[crossbeam](https://github.com/crossbeam-rs/crossbeam).

In this post I will compare my implementation to other stack implementation.
In particular I want to dive into some performance characteristics and their
behavior in regards to the amount of threads (≤ 128) accessing the
datastructure.

**Take this with a grain of salt. This is a hobby project, thus in no way
sophisticated let alone ready for production.**


## Stacks of the day

### Simplest stack in the world

A Rust [`Vec`](https://doc.rust-lang.org/std/vec/struct.Vec.html) implements
both `push` and `pop`, wrapping it in a `Mutex` for mutual exclusion and an
`Arc` for shared ownership makes it a *concurrent* stack. Let's see whether an
`Arc<Mutex<Vec<_>>>` outperforms any of the more sophisticated implementations
below. Rephrased: *At which point is lock-free programming worth the complexity
coming alongside with it?*

### Plain lock-free Treiber stack

A lock-free stack, also often referred to as a [Treiber
stack](https://en.wikipedia.org/wiki/Treiber_stack) [2] due to Kent Treiber,
operates on top of a lock-free linked list. The entry point of the stack is an
atomic pointer which is either pointing to the node on the very top of the stack
or is `null` in case of an empty stack.

The stack linearizes concurrent access through that single atomic `head` pointer
on which `push` and `pop` operations loop trying to `compare_and_set` it. Let's
see how much the single serialization point (`head`) hurts performance.


### Elimination back-off stack

A lock-free elimination back-off stack wraps a lock-free Treiber stack, but
instead of simply exponentially backing off on `compare_and_set` failures, it
uses something called an elimination array to back-off in space instead of time.
Again for details please either read my [previous
post](/blog/2020-03-28-elimination-backoff-stack/) or the corresponding paper
[1] itself. I will be waiting here.


#### Switching back-and-forth

#### Backing-off in space





    - switching back-and-forth between the wrapped Treiber stack and an
      elimination array on failure

    - Exponentially backing-off from the Treiber stack to the elimination stack
      [in space instead of
      time](/blog/2020-03-28-elimination-backoff-stack/#backing-off-in-space-instead-of-time)




---

## References

[1] Hendler, Danny, Nir Shavit, and Lena Yerushalmi. "A scalable lock-free stack
algorithm." Proceedings of the sixteenth annual ACM symposium on Parallelism in
algorithms and architectures. 2004.


[2] Treiber, R. Kent. Systems programming: Coping with parallelism. New York:
International Business Machines Incorporated, Thomas J. Watson Research Center,
1986.
