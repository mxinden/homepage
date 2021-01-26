---
title: Misc
menu: main
weight: 6
type: "page"
---

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

- Ferguson, Niels, Bruce Schneier, and Tadayoshi Kohno. "**Cryptography
  engineering.**" Design Princi (2010).

- Gregg, B. (2013). **Systems performance: enterprise and the cloud**. Pearson
  Education.

- Brady, Edwin. **Type-driven development with Idris**. Manning Publications
  Company, 2017.

- Cooper, Keith, and Linda Torczon. **Engineering a compiler**. Elsevier, 2011.

- Cox-Buday, Katherine. **Concurrency in Go: Tools and Techniques for
  Developers.** " O'Reilly Media, Inc.", 2017.

- Lipovaca, M. (2011). **Learn you a haskell for great good!**: a beginner's
  guide. no starch press.

- Grigorik, I. (2013). **High Performance Browser Networking**: What every web
  developer should know about networking and web performance. " O'Reilly Media,
  Inc.".

- Tanenbaum, A. S., & Van Steen, M. (2017). **Distributed systems**: principles and
  paradigms.

- Love, R. (2005). **Linux Kernel Development** (Novell Press). Novell Press.

- Beyer, B., Jones, C., Petoff, J., & Murphy, N. R. (2016). **Site Reliability
  Engineering: How Google Runs Production Systems**. " O'Reilly Media, Inc.".

- Silberschatz, Abraham, Henry F. Korth, and Shashank Sudarshan. **Database
  system concepts.** Vol. 7. New York: McGraw-Hill, 2019.


## Papers

### Consensus

- Howard, Heidi. (2018). **Distributed consensus revised.**

- Yin, Maofan, et al. **"Hotstuff: Bft consensus in the lens of blockchain."**
  arXiv preprint arXiv:1803.05069 (2018).

- Fischer, Michael J., Nancy A. Lynch, and Michael S. Paterson. **Impossibility
  of distributed consensus with one faulty process.** No. MIT/LCS/TR-282.
  Massachusetts Inst of Tech Cambridge lab for Computer Science, 1982.

- Nakamoto, Satoshi. Bitcoin: **A peer-to-peer electronic cash system**.
  Manubot, 2019.

- Castro, Miguel, and Barbara Liskov. **"Practical Byzantine fault tolerance."**
  OSDI. Vol. 99. No. 1999. 1999.

- Miller, Andrew, et al. **"The honey badger of BFT protocols."** Proceedings of
  the 2016 ACM SIGSAC Conference on Computer and Communications Security. 2016.

- Chan, Benjamin Y., and Elaine Shi. **"Streamlet: Textbook Streamlined
  Blockchains."** IACR Cryptol. ePrint Arch. 2020 (2020): 88.


### Databases

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

- Malhotra, Aanchal, et al. **"Attacking the Network Time Protocol."** NDSS.
  2016.

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

- Vyzovitis, Dimitris, et al. **"GossipSub: Attack-Resilient Message Propagation
  in the Filecoin and ETH2. 0 Networks."** arXiv preprint arXiv:2007.02754
  (2020).

- Leitao, Joao, Jose Pereira, and Luis Rodrigues. **"Epidemic broadcast
  trees."** 2007 26th IEEE International Symposium on Reliable Distributed
  Systems (SRDS 2007). IEEE, 2007.


##### Distributed hash table

- Maymounkov, Petar, and David Mazieres. **"Kademlia: A peer-to-peer information
  system based on the xor metric."** International Workshop on Peer-to-Peer
  Systems. Springer, Berlin, Heidelberg, 2002.

- Baumgart, Ingmar, and Sebastian Mies. **"S/kademlia: A practicable approach
  towards secure key-based routing."** 2007 International Conference on Parallel
  and Distributed Systems. IEEE, 2007.


##### Membership protocol

- Das, Abhinandan, Indranil Gupta, and Ashish Motivala. **"Swim: Scalable
  weakly-consistent infection-style process group membership protocol."**
  Proceedings International Conference on Dependable Systems and Networks. IEEE,
  2002.

- Bortnikov, Edward, et al. **"Brahms: Byzantine resilient random membership
  sampling."** Computer Networks 53.13 (2009): 2340-2359.


### Programming

- Hughes, John. **"QuickCheck testing for fun and profit."** International
  Symposium on Practical Aspects of Declarative Languages. Springer, Berlin,
  Heidelberg, 2007.
