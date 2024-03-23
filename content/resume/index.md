---
title: Resume
---

## Experience

### Software Engineer at Protocol Labs

March 2021 - December 2023

Co-lead of the open source peer-to-peer networking library [libp2p](https://libp2p.io/) and technical lead of its [Rust implementation](https://github.com/libp2p/rust-libp2p/) with 3 direct reports and [>200 external contributors](https://github.com/libp2p/rust-libp2p/graphs/contributors).

Design, specification and implementation of network protocols.
E.g. [decentralized hole punching without the reliance on central infrastructure](https://research.protocol.ai/publications/decentralized-hole-punching/seemann2022.pdf), a [distributed hash table](https://github.com/libp2p/rust-libp2p/tree/master/protocols/kad) based on the _Kademlia_ research paper and [security handshakes and multiplexing](https://github.com/libp2p/specs/tree/master/webrtc) on top of various web protocols.

Special focus on performance.
E.g. the introduction of an [automated continuous benchmark setup](https://github.com/libp2p/test-plans/blob/master/perf/README.md) cross networks, transports and implementations as well as [multiplexer receive window auto-tuning based on bandwidth-delay-product](https://github.com/libp2p/rust-yamux/pull/176).

Facilitate networking track at conferences (e.g. [FOSDEM 2022](https://archive.fosdem.org/2022/schedule/track/network/) and [libp2p day 2022](https://web.archive.org/web/20240323083808/https://blog.ipfs.tech/2022-11-22-libp2p-day-2022-recap/)) and give [>10 peer-to-peer](https://max-inden.de/tags/talk/) related talks.

Hiring manager for the libp2p team and beyond with ~50 technical interviews.


### Software Engineer at Parity

July 2019 - February 2021

Maintaining Rust peer-to-peer networking library *libp2p* and its usage within the Blockchain framework [*Substrate*](https://github.com/paritytech/substrate/).
Worked on networking stack of the byzantine fault tolerant [consensus protocol](https://arxiv.org/pdf/2007.01560.pdf).
Filling role of hiring manager for team building automated testing infrastructure.
Shepherding (Prometheus) monitoring across the company.


### Freelance Network Engineer at SpaceNet AG

June 2019

Work on multiplexed fiber-optic setup and server migration.
Wrote [Prometheus exporter to monitor data center power modules via Modbus](https://github.com/RichiH/modbus_exporter).
Gained insight into BGP infrastructure.


### Senior Software Engineer at CoreOS / RedHat

January 2017 - May 2019

Systems engineer working on the open source monitoring project **Prometheus** and its integration with the **Kubernetes** ecosystem to monitor cloud-native Linux container infrastructures.
Designing and implementing distributed systems on top of Linux and Kubernetes orchestrator.
Presenting open source work at various IT conferences and champion the Prometheus project as a core maintainer.


### Software Engineer at Innoscale

August 2014 - December 2016

Development of a master data management web application. Involved as a back and
front end JavaScript engineer. Spearheaded the introduction of a full stack
JavaScript testing environment including a continuous integration pipeline to
improve code quality and detect errors early. Coordinated and implemented the
transformation of the UI to ReactJS reducing side effects and code reusability
with a component based approach.  Providing company wide ReactJS workshops to
accelerate the transition.


### Software Engineer / Sales Engineer at Contelligence

February - July 2014

Concept creation, development and sales of a Microsoft Office Add-on to support
compliance processes for the enterprise document management in the finance
sector. Responsible for the application software testing. Introduction of a new
human ressource management framework.


### Associate System Support Analyst at DHL IT-Services

July - September 2013

Working in the IBM AS400 and Linux operation team.
Development of graphical visualization tool to analyse the operation alert
system of the IBM infrastructure. Creating regular server security reports.
Management of a database for internal license management.


### System Administrator at Heuft Systemtechnik

October - November 2009

Supporting the internal IT department in hardware
maintanance, network architecture and software distribution.


## Projects & Achievements

- Implement [receive window auto-tuning (flow-control)](https://github.com/libp2p/rust-yamux/pull/176) in Rust Yamux multiplexer implementation based on bandwidth-delay-product, moving peak throughput from ~30 Mbit/s to 1.3 Gbit/s (2023-11-23).
  In addition [improve flow-control strategy](https://discuss.libp2p.io/t/optimizing-yamux-flow-control-sending-window-update-frames-early/843/1) measuring an additioanl performance increase of 25% in the wild (2021-02-11).

- Creator and maintainer of official [Prometheus Rust client library](https://github.com/prometheus/client_rust) (2022-01-16).

- Design decentralized hole punching without the reliance on central infrastructure ([paper](https://research.protocol.ai/publications/decentralized-hole-punching/seemann2022.pdf)) and [add implementation in rust-libp2p](https://github.com/libp2p/rust-libp2p/issues/2052) (2022-02-09).

- Optimize metric encoding in community [Prometheus Rust client library](https://github.com/tikv/rust-prometheus/pull/327) drastically reducing memory allocations in hot-path (2020-07-19).

- Port partially lock-free Prometheus histogram implementation to the community [Prometheus Rust client library](https://github.com/tikv/rust-prometheus/pull/314) making histogram observe calls atomic across collect calls (2020-07-14).

- Implement lookups over disjoint paths based on the extension research paper [S/Kademlia](http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.68.4986&rep=rep1&type=pdf) in the [Rust libp2p Kademlia implementation](https://github.com/libp2p/rust-libp2p/pull/1473). See as well [libp2p forum post](https://discuss.libp2p.io/t/s-kademlia-lookups-over-disjoint-paths-in-rust-libp2p/571) including a summary and benchmarks. (2020-06-19)

- Kubernetes kube-state-metrics [performance optimization](https://github.com/kubernetes/kube-state-metrics/issues/498) dividing CPU usage by a factor of 6 and memory and response time by a factor of 3 through introducing an intelligent Prometheus metric cache in the code hot path and optimizing memory allocations during response generation (2019-01-11).

- Design, specification and implementation of a [new API (v2)](https://github.com/prometheus/alertmanager/pull/1352) for Prometheus Alertmanager, generated via [OpenAPI](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/2.0.md) (2018-09-04).

- Initiate and organize distributed systems book club covering distributed and decentralized systems research and their real-world applications in [>35 sessions](https://max-inden.de/tags/distributed-systems/) (2018-08-17).

## Volunteer Work

- Tutor and Mentor for Refugee Family | 2018 - 2022

  Tutoring Math, Physics, English and German. Mentoring and assisting with authorities.

- Prometheus Core Member | 2017 - 2020 and 2022 - Now

  Member of the upstream core team of the open source monitoring tool _Prometheus_, developing and maintaining source code, representing the project at tech-conferences and helping adoption in user communities.

- Informationsdienst Umweltrecht e.V. | 2015 - 2021

  Administrator for the non-profit _Informationsdienst Umweltrecht e.V._ for their online presence.

- (Certified) Ski Instructor | 2017 - Now

- Student Council | 2013 -2016

  Member of the _Fachschaft WiWi_ student council, helping students of the faculty in their day-to-day student life, taking the role of the Website Administrator.

- Math, Physics and English Tutor | 2010 - 2013

## Education

**Bachelor at WWU Münster** | 2013 – 2016

Bachelor of Applied Science (B.A.Sc.) in Information systems at the
Westfälische Wilhelms-Universität Münster, combining computer science and
business administration with a special focus on enterprise applications and
architectures. Specialization during bachelor thesis on conception of
datastructure dialects and development of an application for metadata
management.


**Exchange Semester at UIA Kristiansand** | 2015

Participation in the bachelor and master program Information Systems at
Universitetet i Agder with the courses Open Source, development of a mobile
lecture support application, Hands-on-eBusiness for Entrepreneurs, development
of a both mobile and desktop web shop, IT and Management, operational and
strategic management of enterprise information technology, and Consumer
Behaviour, analysis and prediction of psychological, social and cultural
factors that affect consumer behaviour.


**Abitur at Amos Comenius Gymnasium Bonn** | 2004 - 2013


**Exchange year at Lugoff-Elgin High School SC USA** | 2010 - 2011


### Languages

- German (Mothertongue)
- English (Business fluent)




