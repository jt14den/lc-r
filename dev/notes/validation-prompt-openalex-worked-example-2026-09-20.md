# Validation prompt: choosing the worked-example organization for an OpenAlex episode

Paste this to ChatGPT (or another external model). No file upload needed, everything relevant
is inline below.

---

## Context

`lc-r` is a Library Carpentry lesson ("Introduction to R") teaching librarians and library
professionals, most with little or no prior R experience, to use R for real library data work.
Five existing episodes teach import, clean, visualize, and report on a shared circulation/books
dataset. I'm adding an optional sixth episode that reapplies the same workflow to scholarly
publication metadata from the [OpenAlex](https://openalex.org/) API (free, no-auth, CC0),
framed as a patron consultation: a director of some organization asks the librarian for an
exploratory snapshot of how the organization's publication output and research emphasis have
changed over time.

The episode needs one small, real organization to serve as the **instructor's live-coded
worked example** (learners then repeat the pattern on their own choice of institution or
author). I need help picking, or validating, that organization.

## What's already decided — don't relitigate these

- The worked example must be a **real organization with its own distinct OpenAlex institution
  entity** (not an author, not a department without one), because the episode's teaching point
  is exactly the distinction between those cases.
- It must be **small enough to fetch and inspect live during a workshop**: roughly 50-150
  works is the sweet spot (large enough to show real messiness, small enough that a room can
  read through results without it taking forever). A full university (tens of thousands of
  works) is explicitly ruled out.
- It should be **accessible to everyone, not gated behind institutional membership** (a
  paid-membership consortium implicitly favors learners whose institutions belong to it, which
  cuts against a lesson meant to work the same for any librarian in the room, anywhere).
- It should be a genuinely real, verifiable organization, not a fictional one. The instructor
  demo's numbers get baked into a cached data fixture and quoted directly in the lesson text
  (row counts, year ranges, top research fields), so whatever is chosen has to actually exist
  in OpenAlex with real, checkable data.
- The rest of the episode design (cached fixture for the demo, live API for learners' own
  choices, three-case framing of author/organization/department, a capstone report with a
  starter template) is settled and out of scope for this question.

## What was tried and rejected

The first draft used **ICPSR** (Inter-university Consortium for Political and Social Research),
a real research data archive: 76 works in OpenAlex, spanning 1979-2026, cleanly reproduces a
real `tidyr::unnest()` name-collision bug worth teaching. Rejected because ICPSR is a
paid-membership academic consortium: most public/community libraries, and many academic
libraries, aren't members. Using it as the shared worked example quietly assumes an audience
that already has access to something not everyone in the room has, which runs against the
"accessible to everyone" criterion above.

## Current candidate

**Internet Archive** (the nonprofit digital library), OpenAlex institution ID
`I4210124753`. Verified live against the real API today:

- **81 works**, years 2003-2026
- Same real `unnest()` name-collision bug reproduces identically on OpenAlex's `topics` field
  (an `id`/`display_name` collision between the outer work and the nested topic)
- Row count after unnesting: 760
- Top research fields by work count: Computer Science (93), Arts and Humanities (28), Social
  Sciences (25), Decision Sciences (12)
- Open to everyone, no membership or account required to use the actual archive itself

## What I want you to actually challenge

Don't just say "sounds fine." Give a confidence score (0-100) on whether Internet Archive is a
good choice for this specific purpose, and be concrete:

1. **Is there a real downside to Internet Archive specifically that I'm missing?** It's a
   nonprofit with real name recognition, but it's also a party to ongoing, high-profile
   copyright litigation (the Hachette v. Internet Archive case over controlled digital
   lending, among others). Does using an organization currently in active legal controversy as
   a neutral teaching example create a distraction or an unintended political statement in a
   library lesson, even though the lesson itself says nothing about the litigation?
2. **Propose 3-5 alternative real organizations** that would satisfy the criteria above at
   least as well, ideally better. For each: why it fits, and any real coverage/controversy risk
   like the one above. Think about organizations with genuine, uncomplicated public-interest
   standing: examples of the shape I mean (not proposals) could be a well-known open-access
   publisher, a public research infrastructure body, a major library or archive without
   membership gates, or a well-known open-science nonprofit, but I want your actual research,
   not a list I've pre-approved.
3. **Sanity-check the "accessible to everyone" framing itself.** Is picking any single named
   real organization as the shared example ever fully neutral, or does any choice implicitly
   privilege whichever learners already know that organization? Would a fictional-but-realistic
   composite, or letting the *instructor* pick a locally relevant real example each time
   instead of hardcoding one into the lesson, solve this more robustly than swapping one real
   name for another?
4. If you land on a genuinely better candidate, give me enough to verify it myself: the
   organization's name and, if you can find it, an approximate OpenAlex works count, so I can
   confirm the real numbers before adopting anything.

Give concrete corrections, not vibes. If Internet Archive is actually fine, say why with more
than reassurance, tell me what would have to be true for it to be a bad choice, and confirm
those things aren't true here.

---

## Outcome (2026-09-20)

External response recommended **Public Knowledge Project** (ID `I4387153203`) over Internet
Archive, and separately caught a real bug: the episode's field-count chart was counting
topic-tag occurrences, not distinct works (a work with 2 topics both mapping to "Computer
Science" was counted twice).

Verified independently before adopting anything:
- All 5 proposed candidate IDs (PKP, Carpentries, DOAJ, Educopia, Open Book Publishers) resolve
  to the correct organization names, and all reported work counts matched exactly on a live
  fetch (91, 116, 49, 48, 106 respectively).
- PKP's pre-1998 outlier records (2 works dated 1969) are real; `from_publication_date =
  "1998-01-01"` narrows to 87, matching the claim exactly.
- The real `unnest()` name-collision bug reproduces identically on PKP's `topics` field.
- The double-counting bug: reran the naive vs. `distinct(id, field)` calculation on our own
  data, got the exact same corrected numbers the external response reported (46/20/19/10/8 for
  Internet Archive; confirmed the same pattern independently exists on PKP: 33/31/16/13).

Adopted: swapped Internet Archive to PKP throughout the episode, fixed the field-chart
double-counting with `distinct(id, topics_display_name)` before `count()`. Not adopted: the
"accessible to everyone" criterion was reframed (per the response) to mean "learners can
understand and reproduce the query," not "the org itself has no membership model" -- kept as
guidance, not written verbatim into the lesson.
