---
date: 2017-08-18
title: Improving user and developer experience of the Alertmanager UI
type: "posts"
---

Alertmanager deduplicates, groups, and routes alerts from Prometheus to all kinds of paging services. With it comes a dated UI which does not live up to the expectations of the users, nor does it attract new contributors.

From this talk, you will learn how we addressed these issues when building the new UI from scratch. We made it friendlier to users by removing unnecessary domain language noise. In addition we added new power features such as filtering and grouping. As a result, it is now much easier to navigate through thousands of alerts.

We chose to build the new UI with Elm — a functional programming language for web interfaces. Elm enabled us to develop fast and with confidence by keeping a promise of zero runtime errors. It lowered the entry barrier for non-frontend developers and made the project appealing to newcomers.

- [Recording](https://www.youtube.com/watch?v=TpifnbUGXD8&t=1057s)
