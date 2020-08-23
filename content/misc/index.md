---
title: Misc
menu: main
weight: 6
---

# Projects & Achievements

- _2020-07-14_ - Port partially lock-free Prometheus histogram implementation to
  the [Prometheus Rust client
  library](https://github.com/tikv/rust-prometheus/pull/314) making histogram
  observe calls atomic across collect calls.

- _2020-06-19_ - Implement lookups over disjoint paths based on the extension
  research paper
  [S/Kademlia](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.68.4986&rep=rep1&type=pdf)
  in the [Rust libp2p Kademlia
  implementation](https://github.com/libp2p/rust-libp2p/pull/1473). (See as well
  [libp2p forum
  post](https://discuss.libp2p.io/t/s-kademlia-lookups-over-disjoint-paths-in-rust-libp2p/571)
  including a summary and benchmarks.)

- _2020-05-08_ - Maintainer of the [Rust Prometheus client
  library](https://github.com/tikv/rust-prometheus/).

- _2019-10-06_ - Maintainer of the [Rust libp2p
  implementation](https://github.com/libp2p/rust-libp2p/).

- _2019-01-16_ to _2019-08-02_ - Maintainer of [Kubernetes
  kube-state-metrics](https://github.com/kubernetes/kube-state-metrics).

- _2019-01-15_ - Joining [Kubernetes
  organisation](https://github.com/kubernetes/org/issues/364).

- _2019-01-11_ - Kubernetes kube-state-metrics [performance
  optimization](https://github.com/kubernetes/kube-state-metrics/issues/498)
  dividing CPU usage by a factor of 6 and memory and response time by a factor
  of 3 through introducing an intelligent Prometheus metric cache in the code
  hot path and optimizing memory allocations during response generation.

- _2018-09-04_ - Design, specification and implementation of a [new API
  (v2)](https://github.com/prometheus/alertmanager/pull/1352) for Prometheus
  Alertmanager, generated via
  [OpenAPI](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md).

- _2018-08-17_ - Initiate and organize distributed systems book club covering
  distributed and decentralized systems research and their real-world
  applications.

- _2018-08-13_ to _2020-01-06_ - Maintainer of [Prometheus
  Alertmanager](https://github.com/prometheus/alertmanager).

- _2017-11-12_ to _2020-03-13_ - Part of [Prometheus
  organisation](https://prometheus.io/governance/#team-members).


# Resources worth sharing

## Books

- Kurose, J. F., & Ross, K. W. (2017). **Computer networking: a top-down
  approach** (Vol. 7). Boston, USA: Addison Wesley.

- Herlihy, Maurice, and Nir Shavit. **The Art of Multiprocessor Programming**,
  revised first edition. Morgan Kaufmann, 2012.

- Kleppmann, M. (2017). **Designing data-intensive applications**: The big ideas
  behind reliable, scalable, and maintainable systems. " O'Reilly Media, Inc.".

- Klabnik, Steve, and Carol Nichols. **The Rust Programming Language**. No
  Starch Press, 2018.

- Tanenbaum, A. S., & Van Steen, M. (2017). **Distributed systems**: principles and
  paradigms.

- Gregg, B. (2013). **Systems performance: enterprise and the cloud**. Pearson
  Education.

- Cooper, Keith, and Linda Torczon. **Engineering a compiler**. Elsevier, 2011.

- Cox-Buday, Katherine. **Concurrency in Go: Tools and Techniques for
  Developers.** " O'Reilly Media, Inc.", 2017.

- Lipovaca, M. (2011). **Learn you a haskell for great good!**: a beginner's
  guide. no starch press.

- Grigorik, I. (2013). **High Performance Browser Networking**: What every web
  developer should know about networking and web performance. " O'Reilly Media,
  Inc.".

- Love, R. (2005). **Linux Kernel Development** (Novell Press). Novell Press.

- Beyer, B., Jones, C., Petoff, J., & Murphy, N. R. (2016). **Site Reliability
  Engineering: How Google Runs Production Systems**. " O'Reilly Media, Inc.".

- Silberschatz, Abraham, Henry F. Korth, and Shashank Sudarshan. **Database
  system concepts.** Vol. 7. New York: McGraw-Hill, 2019.


## Papers

### Databases

- Howard, Heidi. (2018). **Distributed consensus revised.**

- Fischer, Michael J., Nancy A. Lynch, and Michael S. Paterson. **Impossibility
  of distributed consensus with one faulty process.** No. MIT/LCS/TR-282.
  Massachusetts Inst of Tech Cambridge lab for Computer Science, 1982.

- Levandoski, Justin J., David B. Lomet, and Sudipta Sengupta. **"The Bw-Tree: A
  B-tree for new hardware platforms."** 2013 IEEE 29th International Conference
  on Data Engineering (ICDE). IEEE, 2013.

- Thomson, Alexander, et al. **"Calvin: fast distributed transactions for
  partitioned database systems."** Proceedings of the 2012 ACM SIGMOD
  International Conference on Management of Data. ACM, 2012.


### Lock-free data structures

- Hendler, Danny, Nir Shavit, and Lena Yerushalmi. **"A scalable lock-free stack
  algorithm."** Proceedings of the sixteenth annual ACM symposium on Parallelism
  in algorithms and architectures. 2004.

- Hart, Thomas Edward. **Comparative performance of memory reclamation strategies
  for lock-free and concurrently-readable data structures**. University of
  Toronto, 2005.

- Kogan, Alex, and Erez Petrank. **"A methodology for creating fast wait-free
  data structures."** ACM SIGPLAN Notices. Vol. 47. No. 8. ACM, 2012.

- Herlihy, Maurice, Victor Luchangco, and Mark Moir. **"Obstruction-free
  synchronization: Double-ended queues as an example."** 23rd International
  Conference on Distributed Computing Systems, 2003. Proceedings.. IEEE, 2003.


### Hardware synchronization

- David, Tudor, Rachid Guerraoui, and Vasileios Trigonakis. **"Everything you
  always wanted to know about synchronization but were afraid to ask."**
  Proceedings of the Twenty-Fourth ACM Symposium on Operating Systems
  Principles. ACM, 2013.


### Networking

- Lamport, Leslie. **"Time, clocks, and the ordering of events in a distributed
  system."** Communications of the ACM 21.7 (1978): 558-565.

- Chandy, K. Mani, and Leslie Lamport. **"Distributed snapshots: Determining
  global states of distributed systems."** ACM Transactions on Computer Systems
  (TOCS) 3.1 (1985): 63-75.

- Shapiro, Marc, et al. **"A comprehensive study of convergent and commutative
  replicated data types."** (2011).

- Cardwell, Neal, et al. **"BBR: Congestion-based congestion control."** Queue
  14.5 (2016): 20-53.

- Shreedhar, Madhavapeddi, and George Varghese. **"Efficient fair queuing using
  deficit round-robin."** IEEE/ACM Transactions on networking 4.3 (1996):
  375-385.

- Van Renesse, Robbert, et al. **"Efficient reconciliation and flow control for
  anti-entropy protocols."** proceedings of the 2nd Workshop on Large-Scale
  Distributed Systems and Middleware. ACM, 2008.


#### Peer to peer

- Cohen, Bram. **"Incentives build robustness in BitTorrent."** Workshop on
  Economics of Peer-to-Peer systems. Vol. 6. 2003.

##### Gossip / epidemic broadcast

- Leitao, Joao, Jose Pereira, and Luis Rodrigues. **"Epidemic broadcast
  trees."** 2007 26th IEEE International Symposium on Reliable Distributed
  Systems (SRDS 2007). IEEE, 2007.


##### Distributed hash table

- Maymounkov, Petar, and David Mazieres. **"Kademlia: A peer-to-peer information
  system based on the xor metric."** International Workshop on Peer-to-Peer
  Systems. Springer, Berlin, Heidelberg, 2002.


##### Membership protocol

- Das, Abhinandan, Indranil Gupta, and Ashish Motivala. **"Swim: Scalable
  weakly-consistent infection-style process group membership protocol."**
  Proceedings International Conference on Dependable Systems and Networks. IEEE,
  2002.

- Bortnikov, Edward, et al. **"Brahms: Byzantine resilient random membership
  sampling."** Computer Networks 53.13 (2009): 2340-2359.
