# Day 1, Module 1 — Live Demo Script + Solution
### DORA Metrics Walkthrough, Built From Scratch

**Purpose:** Run this live in front of the room *before* trainees start
their own Step 1–4 lab exercise (see `day1-01-devops-transformation.md`).
Trainees follow along, filling in their own copy of the same table as you
build it on the board. This script also doubles as the answer key —
Section 2 ("Solution") is what your board should look like at the end.

**Materials:** whiteboard/shared doc, nothing else. No repo or terminal
needed for this module.

**Time:** ~12 minutes, run before Step 1 of the hands-on lab.

---

## 1. Live Demo Script

Narrate this out loud, writing each piece on the board as you say it —
don't reveal the finished table up front. The point is that trainees watch
the four metrics get *derived*, not just presented.

### 1.1 — Start with a blank event log (1 min)

Say: *"We're not going to start from a definition. We're going to start
from raw events, the way you'd actually have them in an issue tracker or
deploy log, and derive the metrics from that."*

Draw an empty two-column table on the board: **Date | Event**. Leave it
empty.

### 1.2 — Add events one at a time, narrating each (3 min)

Add rows one at a time, pausing briefly after each so trainees can copy it:

```text
Day 2   | Deploy #1
Day 2   | Incident: deploy #1 caused a checkout timeout, resolved same day (4 hrs)
Day 9   | Deploy #2
Day 14  | Deploy #3
Day 14  | Incident: deploy #3 caused a data mismatch, resolved next day (18 hrs)
Day 21  | Deploy #4
Day 27  | Deploy #5
```

Say out loud as you write the incident rows: *"Notice these two incidents
are tied to specific deploys, not floating bugs. That's deliberate —
change failure rate is about deploys that cause problems, not a general
bug count."*

State the one fact that isn't in the table itself: *"Each of these five
deploys shipped code that was committed, on average, 3 days before it
deployed."* Write "avg commit→deploy = 3 days" off to the side.

### 1.3 — Derive Deployment Frequency live (2 min)

Say: *"Deployment frequency is just deploys over the time window. Count
the deploys with me."* Count on the board: 1, 2, 3, 4, 5. *"Five deploys.
What's our window?"* — point at Day 2 through Day 27 — *"Call it 30 days
to round cleanly."*

Write: `5 deploys / 30 days ≈ 1 deploy every 6 days`

### 1.4 — Derive Lead Time live (1 min)

Say: *"Lead time we were already given — average time from commit to
deploy, 3 days. In a real pipeline this is something Jenkins timestamps
would let you calculate automatically; today we're given it."*

Write: `Lead Time for Changes = 3 days`

### 1.5 — Derive Change Failure Rate live (2 min)

Say: *"Now count incidents against deploys — not against time."* Count
incidents: 2. Count deploys again: 5.

Write: `Change Failure Rate = 2 / 5 = 40%`

Pause here deliberately. Say: *"Forty percent. Say that number out loud.
Two out of every five times this team deployed, something broke in
production. Hold that thought — we'll come back to it."*

### 1.6 — Derive Time to Restore Service live (2 min)

Say: *"Last one — average how long it took to fix each incident, not how
long it took to notice it."*

Write: `(4 hrs + 18 hrs) / 2 = 11 hrs`

### 1.7 — The turn: classify against the bands (1 min)

Reveal the classification bands table (write it or project it):

| Metric | Elite | High | Medium | Low |
|---|---|---|---|---|
| Deployment Frequency | On-demand (multiple/day) | Weekly–monthly | Monthly–biannually | Fewer than every 6 months |
| Lead Time | < 1 hour | 1 day – 1 week | 1 week – 1 month | > 1 month |
| Change Failure Rate | 0–15% | 16–30% | 16–30% | > 30% |
| Time to Restore | < 1 hour | < 1 day | 1 day – 1 week | > 1 week |

Ask the room, don't answer it yourself yet: *"Deployment frequency of
1-per-6-days — which band? Lead time of 3 days — which band?"* Let two or
three people answer before revealing your own classification in Section 2
below. Then land the point:

Say: *"Here's the thing this exercise is built to teach you: on frequency
and lead time, this team looks decent — High to Medium. But change failure
rate is Low, and that's the metric that should make you the most nervous,
because it's telling you shipping isn't safe, no matter how often you do
it. You cannot judge speed in isolation from stability. That's the one
sentence to carry into your own exercise."*

Hand off to Step 1 of the lab: *"Now do this for your own team — but
you're starting from your own memory, not a clean table I handed you."*

---

## 2. Solution / Answer Key

Use this to check trainee work during Steps 2–4 of the lab, and to
self-check your own live-demo board matches before you run it.

### 2.1 — Completed table

| Date | Event |
|---|---|
| Day 2 | Deploy #1 |
| Day 2 | Incident: deploy #1 caused a checkout timeout, resolved same day (4 hrs) |
| Day 9 | Deploy #2 |
| Day 14 | Deploy #3 |
| Day 14 | Incident: deploy #3 caused a data mismatch, resolved next day (18 hrs) |
| Day 21 | Deploy #4 |
| Day 27 | Deploy #5 |

### 2.2 — Computed metrics

```text
Deployment Frequency = 5 deploys / 30 days       ≈ 1 deploy every 6 days
Lead Time for Changes = given                    = 3 days
Change Failure Rate   = 2 incidents / 5 deploys   = 40%
Time to Restore       = (4 hrs + 18 hrs) / 2       = 11 hrs
```

### 2.3 — Classification against the bands

| Metric | Value | Band |
|---|---|---|
| Deployment Frequency | ~1 / 6 days | **High** (weekly–monthly range) |
| Lead Time for Changes | 3 days | **High** (1 day – 1 week range) |
| Change Failure Rate | 40% | **Low** (> 30%) |
| Time to Restore Service | 11 hrs | **High** (< 1 day) |

Classification string: **High / High / Low / High**

### 2.4 — The takeaway sentence (what a correct Step 3 answer looks like)

A group that correctly completes the *real* lab's Step 3 for their own
team should produce something structurally identical to:

> "Our biggest bottleneck is [Change Failure Rate], and the first thing
> we'd change is [add a pre-deploy automated test/scan gate], measured by
> [% of deploys causing an incident, tracked over the next quarter]."

If a group instead names Deployment Frequency as their bottleneck while
also reporting a high failure rate, that's the exact misconception this
demo is built to preempt — redirect them to the 40%-failure-rate example
above before they finalize their answer.

---

## 3. Facilitator-Only Notes on Running This Demo

- Do **not** show Section 1's numbers before deriving them live — the
  pedagogical point is watching frequency/lead time look "fine" right up
  until change failure rate reframes the whole picture. Revealing the
  table up front kills that beat.
- If a trainee asks "why 30 days and not the actual Day 2–Day 27 span (25
  days)?", that's a good catch — acknowledge it: real deployment frequency
  calculations use a fixed reporting window (e.g. a calendar month), not
  the span between first and last event, which is why 30 is used here
  rather than 25. Don't dodge the question, use it to reinforce that DORA
  metrics are always reported over a fixed window, not a data-dependent one.
- This script assumes ~12 minutes. If the room is slow to answer the
  Section 1.7 classification prompt, don't extend past ~15 minutes total —
  cut the discussion and move straight to the lab's Step 1; the group
  discussion in the lab itself recovers any depth you skip here.
