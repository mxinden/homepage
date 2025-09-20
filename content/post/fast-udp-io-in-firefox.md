---
date: 2025-09-14
title: Fast UDP I/O for Firefox in Rust
tags: [tech, quic, firefox, rust, networking]
ShowToc: true
TocOpen: false
---

## Motivation

Firefox uses [NSPR](https://www-archive.mozilla.org/projects/nspr/) for most of its network I/O. When it comes to UDP I/O, NSPR only offers a limited set of dated APIs, most relevant here [`PR_SendTo`](https://firefox-source-docs.mozilla.org/nspr/reference/pr_sendto.html) and [`PR_RecvFrom`](https://firefox-source-docs.mozilla.org/nspr/reference/pr_recvfrom.html), wrappers around POSIX's `sendto` and `recvfrom`. The N in NSPR stands for Netscape, giving you a hint of its age.

Operating systems have evolved since. Many offer multi-message APIs like `sendmmsg` and `recvmmsg`. Some offer segmentation offloading like GSO (Generic Segmentation Offload) and GRO (Generic Receive Offload). Each of these promise significant performance improvements for UDP I/O.

Around 20% of Firefox's HTTP traffic now uses HTTP/3, which runs over QUIC, which in turn runs over UDP. This translates to substantial UDP I/O activity. Can Firefox benefit from replacing its aging UDP I/O stack with modern system calls?

## Overview

This project began in mid-2024 with the goal of rewriting Firefox's QUIC UDP I/O stack in Rust using modern system calls across all supported operating systems.

Instead of starting from scratch, we built on top of [`quinn-udp`](https://github.com/quinn-rs/quinn/tree/main/quinn-udp), the UDP I/O library of the Quinn project, a QUIC implementation in Rust. This sped up our development efforts significantly. Big thank you to the Quinn project. Operating system calls are complex, with a myriad of idiosyncrasies, especially across versions. Firefox is multi-platform, focusing on Windows, Android, MacOS and Linux as [tier 1](https://firefox-source-docs.mozilla.org/build/buildsystem/supported-configurations.html#supported-build-targets). The main complexity though stems from Firefox supporting ancient versions of each of them, e.g. Android 5.

One year later, i.e. mid 2025, this project is now rolling out to the majority of Firefox users. Performance benchmark results are promising. In extreme cases, on purely CPU bound benchmarks, we're seeing a jump from < 1Gbit/s to 4 Gbit/s. Looking at CPU flamegraphs, the majority of CPU time is now spent in I/O system calls and cryptography code.

Below are the many improvements we were able to land, plus the ones we weren't. I hope other projects in need of fast UDP I/O can benefit from our work.

## The basics

To understand the improvements, it's helpful to first examine how UDP I/O traditionally works and how modern optimizations change this picture.

### Single datagram

Previously Firefox would send (and receive) single UDP datagrams to (and from) the OS via `sendto` (and `recvfrom`) system call family. The OS would send (and receive) that UDP datagram to (and from) the network interface card (NIC). The NIC would send (and receive) it to (and from) *the Internet*.

Thus each datagram would require leaving user space which is cheap for one UDP datagram, but [expensive when sending at say a 500 Mbit/s rate](/post/2020-06-19-latencies/). In addition all user space and kernel space overhead independent of the number of bytes sent and received, is payed per datagram, i.e. per < 1500 bytes.

```
    +----------------------+
    |       Firefox        |
    |    +-----------+     |
    |    |   QUIC    |     |
    |    +-----------+     |
    +----------------------+
              |
         [ datagram ]
              |
    === User / Kernel ===
              |
         [ datagram ]
              |
    +----------------------+
    |         OS           |
    +----------------------+
              |
         [ datagram ]
              |
    +----------------------+
    |         NIC          |
    +----------------------+
              |
         [ datagram ]
              |
    +----------------------+
    |      Internet        |
    +----------------------+
```

### Batch of datagrams

Instead of sending a single datagram at a time, some operating systems nowadays offer multi-message system call families, e.g. on Linux `sendmmsg` and `recvmmsg`. The idea is simple. Send and receive multiple UDP datagrams at once, save on the costs that are independent of the number of bytes send and received.

```
    +--------------------------+
    |         Firefox          |
    |      +-----------+       |
    |      |   QUIC    |       |
    |      +-----------+       |
    +--------------------------+
                  |
  [ datagram, datagram, datagram ]
                  |
    ===== User / Kernel =====
                  |
  [ datagram, datagram, datagram ]
                  |
    +--------------------------+
    |           OS             |
    +--------------------------+
                  |
  [ datagram, datagram, datagram ]
                  |
    +--------------------------+
    |           NIC            |
    +--------------------------+
                  |
  [ datagram, datagram, datagram ]
                  |
    +--------------------------+
    |        Internet          |
    +--------------------------+
```

### Large segmented datagram 

Some modern operating systems and network interface cards also support system call families with UDP segmentation offloading, e.g. `GSO` and `GRO` on Linux. Instead of sending multiple UDP datagrams in a batch, it enables the application to send a single large UDP datagram, i.e. larger than the Maximum Transmission Unit, to the kernel. Next, either the kernel, but really ideally the network interface card, will segment it into multiple smaller packets, add a header to each and calculates the UDP checksum. The reverse happens on the receive path, where multiple incoming packets can be coalesced into a single large UDP datagram delivered to the application all at once.

```
    +------------------------------+
    |           Firefox            |
    |        +-----------+         |
    |        |   QUIC    |         |
    |        +-----------+         |
    +------------------------------+
                    |
      [ large segmented datagram ]
                    |
      ====== User / Kernel ======
                    |
      [ large segmented datagram ]
                    |
    +------------------------------+
    |             OS               |
    +------------------------------+
                    |
      [ large segmented datagram ]
                    |
    +------------------------------+
    |             NIC              |
    +------------------------------+
                    |
    [ datagram, datagram, datagram ]
                    |
    +------------------------------+
    |          Internet            |
    +------------------------------+
```

*Note: Unfortunately, [Wireshark does not yet support GSO](https://gitlab.com/wireshark/wireshark/-/issues/19109), making network-level debugging more challenging when these optimizations are active.*

For performance analysis of these different approaches, [Cloudflare's comprehensive study](https://blog.cloudflare.com/accelerating-udp-packet-transmission-for-quic/) provides excellent benchmarks and detailed explanations.

## Replacing NSPR in Firefox

Batching and segmentation offloading aside for now, first step in the project was to replace usage of NSPR with quinn-udp, still sending and receiving one UDP datagram at a time. We updated the [Mozilla QUIC client and server test implementation](https://github.com/mozilla/neqo/pull/1604), then [integrated quinn-udp into Firefox itself](https://phabricator.services.mozilla.com/D216308).

Next we rewrote the UDP datagram processing pipeline in the Mozilla QUIC implementation to [send](https://github.com/mozilla/neqo/pull/2184) and [receive](https://github.com/mozilla/neqo/pull/2184) batches of datagrams. This is done in a way, such that we can leverage both the multi-message style system calls, as well as the segmentation offloading style, if available.

So far so good. This was the easy part. Up next, the edge cases by operating system and version.

## Platform details

### Windows

Windows offers [`WSASendMsg`](https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-wsasendmsg?redirectedfrom=MSDN) and [`WSARecvMsg`](https://learn.microsoft.com/en-us/previous-versions/windows/desktop/legacy/ms741687(v=vs.85)) to send and receive a single UDP datagram. That UDP datagram can either be a classic MTU size datagram, or a large segmented datagram. For the latter, what Linux calls `GSO` and `GRO`, Windows call [`USO`](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/udp-segmentation-offload-uso-) and [`URO`](https://learn.microsoft.com/en-us/windows-hardware/drivers/network/udp-rsc-offload). As described above, we started off rolling out quinn-udp using single-datagram system calls only. This went without issues on Windows.

Next we tested `WSARecvMsg` with `URO`, i.e. receiving a batch of inbound datagrams as a single large segmented datagram, but got [the following bug report](https://bugzilla.mozilla.org/show_bug.cgi?id=1916558):

> fosstodon.org doesn't load with network.http.http3.use_nspr_for_io=false on ARM64 Windows

fosstodon is a Mastodon server. It is hosted behind the CDN provider Fastly. Fastly is a heavy user of Linux's GSO, i.e. sends larger UDP datagram trains, perfect to be coalesced into a single large segmented UDP datagram when Firefox receives it. Why would Window's `URO` prevent Firefox from loading the site?

After many hours of back and forth with the reporter, luckily a Mozilla employee as well, I ended up buying the exact same laptop , **same color**, in a desperate attempt to reproduce the issue. Without much luck at first, I eventually needed a Linux command line tool, thus installed WSL, and to my surprise, that triggered the bug ([reproducer](https://github.com/quinn-rs/quinn/issues/2041#issuecomment-2495419003)). Turns out, on Windows on ARM, with WSL enabled, a `WSARecvMsg` call with `URO` would not return a segment size, thus Firefox was unable to differentiate a single datagram, from a single segmented datagram. QUIC short header packets don't carry a length, thus there is no way to tell where one QUIC packet ends and another starts, leading to the above page load failures.

We have been in touch with Microsoft since. No progress thus far. Thereby we are keeping [`URO` on Windows disabled](https://github.com/quinn-rs/quinn/pull/2092) in Firefox for now.

After `URO` we started using `WSASendMsg` `USO`, i.e. sending a single large segmented datagram per system call. But this too we rolled back quickly, seeing [increased packet loss on Firefox Windows installations](https://bugzilla.mozilla.org/show_bug.cgi?id=1979279). In addition, we have at least one report of a user, seeing their network driver crash [due to Firefox's usage of `USO`](https://bugzilla.mozilla.org/show_bug.cgi?id=1978821). More debugging needed.

### MacOS

The transition on MacOS from NSPR to quinn-udp for HTTP/3 QUIC UDP I/O involved switching from the system calls `sendto` and `recvfrom` to the system calls `sendmsg` and `recvmsg`. As with Windows, no issues on this first step, ignoring one [report](https://bugzilla.mozilla.org/show_bug.cgi?id=1987606) where MacOS 10.15 might be seeing [IP packets other than v4 and v6](https://github.com/quinn-rs/quinn/pull/2387) (fixed since).

Unfortunately MacOS does not offer UDP segmentation offloading, neither on the send, nor on the receive side. What it does offer though are two undocumented system calls, namely [`sendmsg_x`](https://github.com/apple-oss-distributions/xnu/blob/94d3b452840153a99b38a3a9659680b2a006908e/bsd/sys/socket.h#L1457-L1487) and [`recvmsg_x`](https://github.com/apple-oss-distributions/xnu/blob/94d3b452840153a99b38a3a9659680b2a006908e/bsd/sys/socket.h#L1425-L1455), allowing a user to send and receive batches of UDP datagrams at once. Lars from Mozilla added it to quinn-udp, exposed behind the `fast-apple-datapath` Rust feature, off by default. After multiple iterations with smaller bugfixes ([#2154](https://github.com/quinn-rs/quinn/pull/2154), [#2214](https://github.com/quinn-rs/quinn/issues/2214), [#2216](https://github.com/quinn-rs/quinn/pull/2216) ...) we decided to [not ship it to users](https://github.com/mozilla/neqo/pull/2638), not knowing how MacOS would behave, in case Apple ever decides to remove it, but with Firefox still calling it. 

### Linux

Linux provides the most comprehensive and mature UDP optimization support, offering both multi-message APIs (`sendmmsg`/`recvmmsg`) and segmentation offloading (GSO/GRO). The quinn-udp library makes a deliberate choice to [prioritize GSO over `sendmmsg`](https://github.com/quinn-rs/quinn/pull/1729#issuecomment-1866939467) for transmission, as GSO typically provides superior performance with diminishing returns when both techniques are combined. Thus far, this has proven the right choice for Firefox as well.

In addition to segmentation offloading being superior in the first place, Firefox uses one UDP socket per connection in order to improve privacy. As each socket gets its own source port it is harder to correlate connections. Why is this relevant here? `GSO` (and `GRO`) can only segment (and coalesce)  datagrams from the same 4-tuple (src IP, src port, dst IP, dst port), `sendmmsg` and `recvmmsg`  on the other hand can send and receive across 4 tuples. Given that Firefox uses one socket per connection, it can not make use of that destinct benefit of `sendmmsg` (and `recvmmsg`), making segmentation offloading yet again the obvious choice for Firefox.

Ignoring minor changes required to [Firefox's optional network sandboxing](https://hg-edge.mozilla.org/integration/autoland/rev/5f3a2655d2f4), replacing Firefox's QUIC UDP I/O stack on Linux has been without issues, now enjoying all the benefits of segmentation offloading.

### Android

During the time of this project I learned quickly that (a) Android is not Linux and (b) that [Firefox still supports Android 5](https://support.mozilla.org/en-US/kb/will-firefox-work-my-mobile-device), ..., on x86 (32 bit).

On x86, [Android dispatches advanced socket calls through `socketcall` system call](https://github.com/quinn-rs/quinn/pull/1964) instead of calling e.g. `sendmsg` directly. In addition Android has various default seccomp filters, crashing an app when e.g. not going through the required `socketcall` system call. [The combination of the two](https://github.com/quinn-rs/quinn/pull/1966) did cost me a couple of days, resulting in [this (basically single line) change in quinn-udp](https://github.com/quinn-rs/quinn/pull/1966).

On Android API level 25 and below, calling `sendmsg` with an ECN bit set [results in an error `EINVAL`](https://github.com/quinn-rs/quinn/pull/1975). [quinn-udp will now simply retry on `EINVAL`](https://github.com/quinn-rs/quinn/pull/2079) disabling various optional settings (e.g. ECN) on the second attempt.

Great benefit of the Quinn community is that Firefox will benefit from any improvements made to quinn-udp. For example [this excellent find by Thomas](https://github.com/quinn-rs/quinn/pull/2050) where Android in some cases would complain if we did a `GSO` with a single segment only.

## Explicit congestion notifications (ECN)

With Firefox using modern system calls across all major operating systems, a nice additional benefit is the ability to send and receive ancillary data like [IP ECN](https://en.wikipedia.org/wiki/Explicit_Congestion_Notification). This too [came with some minor surprises](https://github.com/quinn-rs/quinn/pull/1765/), but QUIC ECN in Firefox is well on its way now. Firefox Nightly telemetry shows around [50% of all QUIC connections running on ECN outbound capable paths](https://glam.telemetry.mozilla.org/fog/probe/networking_http_3_ecn_path_capability/explore?). With [L4S](https://datatracker.ietf.org/doc/rfc9330/) and thus ECN becoming more and more relevant in today's Internet, this is a great step forward.

## Summary

We successfully replaced Firefox's QUIC UDP I/O stack with a modern Rust-based implementation using quinn-udp. Instead of limited and dated system calls like `sendto` and `recvfrom`, Firefox now uses modern OS specific system calls across all major platforms, resulting in HTTP/3 QUIC throughput improvements when CPU bound, and enabling QUIC ECN support across devices.