# Optional Extension Episode: Bibliometrics with OpenAlex

Status: outline only, not yet built. Parked per `active/LC-R Modernization Audit - Issues.md`
(2026-08-08/09 decision: optional extension, core dataset stays books/circulation data).
Real commits to `lc-r` are Tim's per Carpentries human-authorship policy.

Working title: `06-bibliometrics-with-openalex.Rmd` (numbering placeholder — depends on where
it lands relative to the modernization audit's restructuring, per open question #1 in
GENAI_REDESIGN_PLAN.md §23).

Format: single new episode, teaching the same import → clean → visualize → report arc already
taught across ep02-05, applied to OpenAlex data instead of the books/circulation dataset. Live
example is ICPSR (OpenAlex ID `I4387153780`); learners pick their own institution or topic.

Fits the 2-half-day workshop format, not the single tight day (per open question #2).

## Frame story: patron consultation

`index.md` already frames two audiences for this lesson — helping patrons with their data
requests, and the library's own internal workflows. The core books/circulation dataset (ep02-05)
already models the internal-workflow half. Nothing in `lc-r` currently models the patron-facing
half, which is the extension's natural gap to fill: bibliometrics is one of the most common real
reference requests academic libraries field (tenure-file citation profiles, grant-report research
output, department reviews).

**The scenario:** you're at the reference desk and a patron asks a bibliometrics question — *"how
has my department's output changed?"* or *"can you help me pull a citation profile for my tenure
file?"* This episode teaches you to answer that with OpenAlex + R.

- **Instructor demo (institution-level):** ICPSR — framed as a patron researching the history of
  data archives asking about ICPSR's own publication record. Real tie-in: this mirrors the actual
  SSDA/DSC institutional-lineage research happening in parallel (Marvick's 1961 Political Behavior
  Archive → 1962 ICPSR founding membership → 1977 ISSR transfer → 2014 Library MOU).
- **Learner challenges (institution or author):** OpenAlex has both entity types, and a real
  reference interview involves figuring out which one actually answers the patron's question.
  Learners choose:
  - an **institution/department** they care about (mirrors the ICPSR demo), or
  - **themselves as an author** (own name or ORCID) — deliberately avoids the privacy awkwardness
    of profiling a real third-party patron without cause, while still exercising the author-level
    query path a real patron consultation would need.
- Translating "how has my department's output changed" into a scoped, fetchable OpenAlex query
  *is itself the reference-interview skill* this episode is teaching, not just a setup step.

## Design note: cached fixtures, live API optional

Per the modernization audit (`active/LC-R Modernization Audit.md`): a room of 20-30 learners all
hitting the live OpenAlex API at once during a workshop is a real rate-limit/network risk, and a
live-API dependency breaks the "lesson works offline" property the rest of `lc-r` has. Plan: ship
a cached fixture (ICPSR's ~76-work dataset, pre-fetched) as the reliable in-workshop path, with
the live `oa_fetch()` call available as an optional "try it yourself" add-on for anyone with a
working connection. Needs deciding before B1 (child-include spike) / B4 (ep02-style activity)
implementation, not before this outline.

---

## objectives (draft)

- Translate a patron's bibliometrics question into a scoped, fetchable OpenAlex query
  (institution vs. author)
- Query the OpenAlex API from R using `openalexR`
- Register a polite-pool email and understand OpenAlex's open, no-auth access model
- Apply prior data-cleaning skills to nested/list-column API data
- Reuse `ggplot2` patterns from ep04 on a new dataset
- Knit a short reproducible bibliometric report a patron could actually use

## Backward design map

Each objective needs at least one challenge that actually assesses it, not just an
around-the-topic exercise. Working from objective back to challenge, before writing any
explanatory content:

| Objective | Assessing challenge | Stage |
|---|---|---|
| Translate a patron's ask into a scoped query | 1a | Section 1 |
| Query the API with `openalexR` | 1a, 1b | Section 1 |
| Understand the open/no-auth access model | 1c | Section 1 |
| Clean nested/list-column data | 2a, 2b | Section 2 |
| Reuse `ggplot2` patterns on new data | 3a, 3b | Section 3 |
| Produce a report a patron could use | 4a (capstone) | Section 4 |

Fill in solutions/exact code as we go — prompts below are placeholders for you to flesh out
or replace.

## questions (draft)

- A patron asks a bibliometrics question — how do I figure out whether that's an institution
  question or an author question?
- What is OpenAlex and why would a librarian query it directly instead of via a vendor tool?
- How do I pull publication data for an institution or author into R?
- How is API data different from a clean CSV, and how do I tidy it?
- How do the same visualization and reporting skills from earlier episodes transfer to a new dataset?

---

## Section 1 — Setup + import (mirrors ep02)

- Open with the frame story: a patron's bibliometrics ask, and the reference-interview question
  of what they actually need (institution vs. author)
- Briefly frame OpenAlex: free, no auth, CC0, ~250M works
- Register polite-pool email (etiquette / rate-limit best practice, echoes ep02's working-directory setup-discipline framing)
- Instructor live-codes: `oa_fetch(entity = "works", institutions.id = "I4387153780")` for ICPSR
- Sanity-check result size before proceeding (avoid a learner accidentally pulling a huge institution's full corpus)

**Challenge 1a — find your own ID (warm-up, assesses: querying the API).**
Imagine a patron just asked you their bibliometrics question. Decide: does it actually need an
*institution/department* answer, or an *author* answer (their own record)? Then search
`oa_fetch(entity = "institutions", search = ...)` or `oa_fetch(entity = "authors", search = ...)`
accordingly, and confirm you've got the right ID before fetching works. If you're doing the
author path, using your own name/ORCID keeps this from turning into profiling a real third party.
- *Common wrong turn:* picking an ambiguous search term that matches the wrong entity (e.g. a
  university system vs. one campus, or an author name collision) — worth calling out explicitly
  rather than letting learners discover it silently.
- *Teaching point:* this is a reference-interview skill, not just an API-syntax step — the patron
  said "my department," but do they mean the institution as a whole, or a specific author's
  output within it?
- Solution: _fill in_

**Challenge 1b — fetch and eyeball (assesses: querying the API).**
Fetch the works for your chosen institution/topic. Before doing anything else, answer: how many
rows did you get, and does that feel fetchable in a workshop session (see ICPSR's 76 as a
benchmark)? If it's huge, how would you narrow it (date range? `works?filter=` on a subfield)?
- Solution: _fill in_ — decide the actual narrowing pattern we want to teach here
  (`from_publication_date`, `topics.id`, etc.)

**Challenge 1c — discussion, not code (assesses: understanding the access model).**
A patron at the desk needs a citation profile by end of day. OpenAlex is free, no-auth, CC0.
What's different about reaching for this versus a vendor tool's (Scopus/Web of Science) export?
What can you *do* with OpenAlex data on the spot that you couldn't do with a vendor export
(licensing/turnaround), and what are you giving up (coverage, curation, dedup quality)?
- Solution: _fill in_ — this is where the reference-desk framing from the frame story gets
  cashed out concretely

## Section 2 — Clean/transform (mirrors ep03)

- Show the raw structure: list-columns (`authorships`, `concepts`) vs. flat columns (`publication_year`, `cited_by_count`, `display_name`)
- Unnest `concepts` or `authorships` into a tidy long format
- Reuse cleaning vocabulary already taught (filtering, selecting, handling `NA`) on the new shape

**Challenge 2a — spot the shape (warm-up, assesses: reading nested data).**
Before touching any unnesting code: look at your fetched data with `str()` or `glimpse()`
(same functions from ep02). Which columns are flat (usable now) and which are list-columns
(need work first)? This should feel familiar — same inspection habit as ep02, applied to a
shape they haven't seen yet.
- Solution: _fill in_

**Challenge 2b — tidy one nested field (assesses: cleaning nested data).**
Pick one list-column from your own dataset (`authorships` or `concepts` are the two we
demo) and unnest it into a flat, one-row-per-value table. What did you lose or duplicate in
the process (e.g. a work with 5 authors now becomes 5 rows) — is that a problem for what
you want to do next?
- *Teaching point:* the row-explosion-on-unnest gotcha is worth flagging deliberately, it's the
  most likely place learners get a confusing row count and don't know why.
- Solution: _fill in_

## Section 3 — Visualize (mirrors ep04)

- Publications-per-year (bar/line) — direct transfer of ep04's plotting pattern
- Citation-count distribution (histogram or boxplot)
- Top co-institutions or top concepts (bar chart from the unnested table)

**Challenge 3a — transfer the pattern (assesses: reusing `ggplot2` on new data).**
Reproduce the publications-per-year plot for your own institution/topic, starting from your
ep04 notes rather than being handed new code. Where did the pattern transfer cleanly, and
where did you have to adapt it (different column names, different scale)?
- Solution: _fill in_

**Challenge 3b — pick your own question (stretch, assesses: reusing `ggplot2` + judgment).**
Choose citation distribution *or* top co-institutions/concepts for your dataset — whichever
seems more interesting given what you found in Section 2. Justify the choice in one sentence.
This is deliberately open-ended: the point is exercising judgment about which chart answers
a real question, not executing a fixed recipe.
- Solution: _fill in_

## Section 4 — Reproducible report (mirrors ep05)

- Knit a short "bibliometric snapshot" Rmd/qmd: institution name, date range, total works, one plot, one summary sentence
- Reinforces ep05's reproducibility framing (parameterized report, not hand-copied numbers)

**Challenge 4a — capstone (assesses: the whole arc, end to end).**
Knit the bibliometric snapshot as if you were about to hand it to the patron from the frame
story: name, date range, total works, the plot you built in Challenge 3, and one sentence
summarizing what it shows — written for them, not for yourself. Swap reports with a neighbor
playing the patron — can they tell what it's about and what the headline finding is, without
you explaining it?
- *This is the real assessment for the episode* — if a "patron" can read it cold and get their
  answer, the objectives were actually met, not just individually checked off.
- Solution: _fill in_

**Wrap-up discussion prompt (not a coding challenge).**
What would you want to know next about this institution/topic that OpenAlex alone can't tell
you? (surfaces limits of bibliometric data — citation lag, non-English coverage gaps, etc.)

---

## Open before this gets built (unchanged from the audit note)

1. Build now or stay parked — still optional/extension-only per the 2026-08-08 decision
2. Only fits the two-half-days workshop version, not the single tight day
3. Numbering/placement depends on how the modernization audit's restructuring lands (GENAI_REDESIGN_PLAN.md §23, question 1)
