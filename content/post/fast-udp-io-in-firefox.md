---
date: 2025-09-14
title: Fast UDP IO in Firefox
tags: [tech, quic, firefox]
---

{{ .TableOfContents }}

## Motivation

Firefox uses [NSPR](https://www-archive.mozilla.org/projects/nspr/) for most of its network IO. When it comes to UDP IO, NSPR only offers a limited set of dated APIs, most relevant here [`PR_SendTo`](https://firefox-source-docs.mozilla.org/nspr/reference/pr_sendto.html) and [`PR_RecvFrom`](https://firefox-source-docs.mozilla.org/nspr/reference/pr_recvfrom.html), wrappers around POSIX's `sendto` and `recvfrom`. The N in NSPR stands for Netscape, giving you a hint of its age.

Operating systems have evolved since. Many offer multi-message APIs like `sendmmsg` and `recvmmsg`. Some offer segmentation offloading like GSO (Generic Segmentation Offload) and GRO (Generic Receive Offload). Each of these promises significant performance improvements for UDP IO.

Around 20% of Firefox's HTTP traffic is using HTTP/3. HTTP/3 uses the transport protocol QUIC. QUIC uses UDP. In short, Firefox does a lot of UDP IO. Can Firefox benefit from using modern UDP IO system calls?

## Overview

This project started mid 2024. We set out to rewrite Firefox's QUIC UDP IO stack in Rust, using modern system calls across operating systems.

Instead of starting from scratch, we built on top of [`quinn-udp`](https://github.com/quinn-rs/quinn/tree/main/quinn-udp), the UDP IO library of the Quinn project, a QUIC implementation in Rust. This sped up our development efforts significantly. Operating system calls are complex, with a myriad of idiosyncrasies, especially across versions. Firefox is multi-platform, focusing on Windows, Android, MacOS and Linux as [tier 1](https://firefox-source-docs.mozilla.org/build/buildsystem/supported-configurations.html#supported-build-targets). The main complexity though stems from Firefox supporting ancient versions of each of them, e.g. Android 5.

One year later, i.e. mid 2025, this project is now rolling out to the majority of Firefox users. Performance benchmark results are promising. In extreme cases, on purely CPU bound benchmarks, we're seeing a jump from < 1Gbit/s to 4 Gbit/s. Looking at CPU flamegraphs, the majority of CPU time is now spent in IO system calls and cryptography code. Below are the many improvements we were able to land, plus the ones we weren't. I hope other projects in need of fast UDP IO can benefit from our work.

## The basics

### Single datagram

Previously Firefox would send (and receive) single UDP datagrams to (and from) the OS via `sendto` (and `recvfrom`). The OS would send (and receive) that UDP datagram to (and from) the network interface card (NIC). The NIC would send (and receive) it to (and from) *the Internet*.

Thus each datagram would require leaving user space which is cheap for one UDP datagram, but [expensive when sending at say a 500 Mbit/s rate](/post/2020-06-19-latencies/). In addition all user space and kernel space overhead independent of the number of bytes sent and received, is payed per datagram, i.e. per < 1500 bytes.

```
+------------------+
|     Firefox      |
|  +-----------+   |
|  |   QUIC    |   |
|  +-----------+   |
+------------------+
        |
   [ datagram ]
        |
== User / Kernel ==
        |
   [ datagram ]
        |
+------------------+
|       OS         |
+------------------+
        |
   [ datagram ]
        |
+------------------+
|       NIC        |
+------------------+
        |
   [ datagram ]
        |
+------------------+
|    Internet      |
+------------------+

```

### Batch of datagrams

Instead of sending a single datagram at a time, most operating systems nowadays offer multi-message system calls, e.g. on Linux `sendmmsg` and `recvmmsg`. The idea is simple. Send and receive multiple UDP datagrams at once, save on the costs independent of the number of bytes send and received.

```
+------------------+
|     Firefox      |
|  +-----------+   |
|  |   QUIC    |   |
|  +-----------+   |
+------------------+
        |
   [ datagram, datagram, datagram ]
        |
== User / Kernel ==
        |
   [ datagram, datagram, datagram ]
        |
+------------------+
|       OS         |
+------------------+
        |
   [ datagram, datagram, datagram ]
        |
+------------------+
|       NIC        |
+------------------+
        |
   [ datagram, datagram, datagram ]
        |
+------------------+
|    Internet      |
+------------------+
```

### Large segmented datagram 

Some modern operating systems and network interface cards also support UDP segmentation offloading. Instead of sending multiple UDP datagrams, it enables the application to send a single large UDP datagram, i.e. larger than the Maximum Transmission Unit, to the kernel. Next, either the kernel, but really ideally the network interface card, will automatically segment it into multiple smaller packets, add aheader to each and calculates the UDP checksum. The reverse happens on the receive path, where multiple incoming packets can be coalesced into a single large UDP datagram delivered to the application all at once.

```
+------------------+
|     Firefox      |
|  +-----------+   |
|  |   QUIC    |   |
|  +-----------+   |
+------------------+
        |
   [ large datagram ]
        |
== User / Kernel ==
        |
   [ large datagram ]
        |
+------------------+
|       OS         |
+------------------+
        |
   [ large datagram ]
        |
+------------------+
|       NIC        |
+------------------+
        |
   [ datagram, datagram, datagram ]
        |
+------------------+
|    Internet      |
+------------------+
```

If you are looking for an analysis of the performance characteristics of each of these, I recommend [Cloudflare's excellent post on it](https://blog.cloudflare.com/accelerating-udp-packet-transmission-for-quic/).

## Introducing quinn-udp into Firefox

Batching and segmentation offloading aside for now, first step in the project was to replace usage of NSPR with quinn-udp, still sending and receiving one UDP datagram at a time. We updated the [Mozilla QUIC client and server test implementation](https://github.com/mozilla/neqo/pull/1604), then [integrated quinn-udp into Firefox itself](https://phabricator.services.mozilla.com/D216308).

Next we rewrote the UDP datagram processing pipeline in the Mozilla QUIC implementation to [send](https://github.com/mozilla/neqo/pull/2184) and [receive](https://github.com/mozilla/neqo/pull/2184) batches of datagrams. This is done in a way, such that we can leverage both the multi-message style system calls, as well as the segmentation offloading style, if available.

So far so good. This was the easy part. Up next, the edge cases by operating system and version.

## Windows

- Windows offers https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-wsasendmsg?redirectedfrom=MSDN and https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms741687(v=vs.85)

- https://bugzilla.mozilla.org/show_bug.cgi?id=1916558
- https://github.com/quinn-rs/quinn/issues/2041#issuecomment-2478732695
- https://github.com/quinn-rs/quinn/pull/2126
- https://github.com/quinn-rs/quinn/pull/2092
- GSO on windows high packet loss https://bugzilla.mozilla.org/show_bug.cgi?id=1979279
  - Crashing network driver https://bugzilla.mozilla.org/show_bug.cgi?id=1978821
- GRO on windows https://bugzilla.mozilla.org/show_bug.cgi?id=1916558

Buying the same device, same color.
## MacOS

- sendmsg_x recvmsg_x
  - https://github.com/quinn-rs/quinn/issues/2214
  - https://github.com/quinn-rs/quinn/pull/2216
  - https://github.com/quinn-rs/quinn/pull/2154
- https://github.com/quinn-rs/quinn/issues/2383
- decode_recv https://bugzilla.mozilla.org/show_bug.cgi?id=1987606

- fast apple datapath
  - https://github.com/mozilla/neqo/pull/2302
  - https://github.com/quinn-rs/quinn/pull/2216
  - https://github.com/mozilla/neqo/issues/2279
  - https://github.com/mozilla/neqo/pull/2638

## Linux

- No sendmmsg, only GSO https://github.com/quinn-rs/quinn/pull/1729#issuecomment-1866939467

## Android

Biggest take-away from the project - Android is not Linux.

- https://github.com/quinn-rs/quinn/issues/1947
- https://github.com/quinn-rs/quinn/pull/1975
- Ongoing issue with Android ang GSO (and some VPN?)
- Android x86 syscalls https://bugzilla.mozilla.org/show_bug.cgi?id=1916412

## Performance impact

- 
## ECN

 A nice additional benefit is the ability to send and receive anxilary data like [ECN](https://en.wikipedia.org/wiki/Explicit_Congestion_Notification) marks.
 Failure on Android due to missing TOS support https://github.com/quinn-rs/quinn/pull/2079
 Show ECN results

## Next steps

- Take a look at segmentation metrics
- Optimize GSO size
- Conflict with pacing?
- Windows GSO GRO
- What about MacOS sendmsg_x and recvmsg_x

## Misc

- https://blog.cloudflare.com/accelerating-udp-packet-transmission-for-quic/
- https://github.com/quinn-rs/quinn/pull/1765/
- Solaris support https://bugzilla.mozilla.org/show_bug.cgi?id=1898185
- OpenBSD https://bugzilla.mozilla.org/show_bug.cgi?id=1952304
- Allowing new syscall https://bugzilla.mozilla.org/show_bug.cgi?id=1903621
  - sandboxing needs updating https://hg-edge.mozilla.org/integration/autoland/rev/5f3a2655d2f4
- No wireshark support with GSO https://bugzilla.mozilla.org/show_bug.cgi?id=1925017 see also mode.org