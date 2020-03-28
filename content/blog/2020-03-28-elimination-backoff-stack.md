---
date: 2020-03-28T00:00:00Z
tags: [tech, paper, lock-free, multithreaded, concurrent]
title:  Elimination back-off stack implementation
type: "posts"
---

Reading *The Art of Multiprocessor Programming* [1] I came across the
*Elimination Back-off Stack* [2] datastructure introduced in 2004 by Danny
Hendler, Nir Shavit, and Lena Yerushalmi. It promises to be a **parallel**
lock-free stack.

How can a stack allow parallel operations without going through a single
serialization point, e.g. a Mutex or an Atomic? Let's dive into it.

## A lock-free stack

A lock-free stack, also often referred to as a Treiber stack [3] due to Kent
Treiber, operates on top of a lock-free linked list. The entry point of the
stack is an atomic pointer which is either pointing to the node on the very top
of the stack or is `null` in case of an empty stack.

```Rust
pub struct Stack<T> {
    head: Atomic<Node<T>>,
}
```

Each node on the stack contains its `data` as well as an atomic `next` pointer which is
either `null` in the case where it is the last node of the stack (bottom plate)
or a pointer to the next node.

```Rust
struct Node<T> {
    data: ManuallyDrop<T>,
    next: Atomic<Node<T>>,
}
```

### Push and pop operation

A `push` operation creates a new `Node`, reads the current `head`, sets the
`next` pointer of its new node to `head` and then tries to `compare_and_set`
`head` to point to its new node. It loops until the final `compare_and_set`
succeeds. A `pop` operation reads the current `head`. If the stack is empty
`head` will be `null` thus `pop` can return. If the stack is not empty `head`
will point to the first node. It reads that node and tries to `compare_and_set`
`head` to point to the second node instead of the first one, again looping until
the `compare_and_set` succeeds. On success it returns the `data` field of the
first node.

``` markdown
Empty stack:

+----+
|head| --> null
+----+

Non-empty stack:

+----+     +----+     +----+     +----+
|head| --> |next| --> |next| --> |next| --> null
+----+     |data|     |data|     |data|
           +----+     +----+     +----+
```

### Performance

The lock-free stack implementation above linearizes concurrent access through a
single atomic `head` pointer on which `push` and `pop` operations loop trying to
`compare_and_set` it. This single sequential execution point introduces
contention when multiple threads try to `push` or `pop` at *the same time* thus
making the entire stack implementation scale poorly. One can use exponential
back-off by having a thread wait for a bit on `compare_and_set` failure before
retrying.

*Can we do better?*


## A lock-free elimination back-off stack

A lock-free elimination back-off stack wraps a lock-free Treiber stack, but
instead of simply exponentially backing off on `compare_and_set` failures, it
uses something called an elimination array to back-off in both space and time.


### Elimination Array

A stack allows two operations: `push` and `pop`. A `push` followed by a `pop`
leaves a given stack in the same state as it was before the two operations. Thus
the two operations *cancel out*. An elimination array is a fixed size array
where each slot enables a thread executing a `push` operation to hand its item
over to a thread executing a `pop` operation.


``` markdown
Initial state

+----+     +----+     +----+     +----+
|head| --> |next| --> |next| --> |next| --> null
+----+     |abcd|     |efgh|     |ijkl|
           +----+     +----+     +----+

After push operation

+----+     +----+     +----+     +----+     +----+
|head| --> |next| --> |next| --> |next| --> |next| --> null
+----+     |push|     |abcd|     |efgh|     |ijkl|
           +----+     +----+     +----+     +----+

After pop operation == initial state

+----+     +----+     +----+     +----+
|head| --> |next| --> |next| --> |next| --> null
+----+     |abcd|     |efgh|     |ijkl|
           +----+     +----+     +----+
```

Both `push` and `pop` try to succeed on the lock-free stack first. On contention
an operation's `compare_and_set` is likely to fail. Instead of backing-off by
waiting a bit and retrying on the stack, an operation would try to exchange with
its counterpart on the elimination array instead.

TODO: Explain what backing off in terms of space instead of time means.

The result is a lock-free stack that is both _linearizable_ and _parallel_.



---

## References


[1] Herlihy, Maurice, and Nir Shavit. The art of multiprocessor programming.
Morgan Kaufmann, 2011.

[2] Hendler, Danny, Nir Shavit, and Lena Yerushalmi. "A scalable lock-free stack
algorithm." Proceedings of the sixteenth annual ACM symposium on Parallelism in
algorithms and architectures. 2004.

[3] Treiber, R. Kent. Systems programming: Coping with parallelism. New York:
International Business Machines Incorporated, Thomas J. Watson Research Center,
1986.
