# Validation prompt: OpenAlex bibliometrics episode (Library Carpentry `lc-r`)

Paste this to ChatGPT along with the uploaded episode file
(`episodes/06-bibliometrics-with-openalex.Rmd`).

---

## Context

`lc-r` is a Library Carpentry lesson ("Introduction to R") teaching librarians and library
professionals, most with little or no prior R experience, to use R for the data work their job
actually involves: importing, cleaning, and visualizing data, then producing a reproducible
report. It runs as a single- or two-half-day workshop, live-coding plus hands-on challenges, not
self-paced reading. The five existing episodes build one shared dataset end to end: a library
circulation/books CSV (10,000 rows, no PII), progressing setup → import → clean → visualize →
report.

I'm attached is a draft sixth episode: an **optional extension**, not a core-curriculum
replacement. It reapplies the same import→clean→visualize→report arc to a different, real
dataset — scholarly publication metadata from the [OpenAlex](https://openalex.org/) API (free,
no-auth, CC0) — instead of circulation data. This is meant to teach the same R skills transfer to
a second, realistic library-adjacent domain, and to demonstrate `R`'s package ecosystem
(`openalexR`) as a payoff for the skills already taught.

## What's already decided — don't relitigate these

- **Optional extension, not core.** The books/circulation dataset stays the lesson's spine; this
  episode is additive.
- **Frame story: patron consultation**, not an internal-library-workflow scenario. The existing
  episodes already model internal library workflows (analyzing circulation data). This episode
  fills the *other* half of the lesson's own stated audience (`index.md`): helping patrons with
  their data requests. Concretely: a faculty member or grad student asks a bibliometrics question
  — *"how has my department's output changed?"* or *"can you help me pull a citation profile for
  my tenure file?"*
- **Institution vs. author as a taught decision, not just an API argument.** OpenAlex has
  distinct `institutions` and `authors` entity types. The episode treats picking between them as
  a reference-interview skill: the patron's vague ask has to be translated into a scoped,
  fetchable query.
- **Cached fixture for the instructor demo, live API for the learner's own choice.** A room of
  20-30 learners all hitting the live API for the *same* institution at once during a workshop is
  a real rate-limit/reliability risk, and the rest of `lc-r` is designed to work offline. So: the
  instructor's worked example (ICPSR, an existing research data archive, chosen because it ties
  to unrelated real institutional-history research the author is doing) is a pre-fetched, cached
  dataset (76 works, fetched live from OpenAlex, confirmed reproducible). Learners' own
  challenge-exercise fetches (their own institution, or themselves as an author via name/ORCID)
  are live, individually, which is a much smaller load than one shared query.
- **Author-path uses the learner's own identity, not a real third party.** To avoid the ethics
  problem of profiling a real patron's citation record without their consent as a classroom
  exercise, the "author" path has learners search their own name/ORCID rather than a hypothetical
  patron.

## Real data facts grounding the episode (verified, not estimated)

- Live `oa_fetch(entity = "works", institutions.id = "I4387153780")` for ICPSR returns exactly
  **76 works** (verified twice, weeks apart).
- The raw fetch includes list-columns (`authorships`, `concepts`, each holding a nested data
  frame per row) alongside flat columns (`id`, `display_name`, `publication_year`,
  `cited_by_count`, etc.).
- A naive `unnest(concepts)` (no `names_sep`) throws a real error: `id` and `display_name` exist
  both in the outer table and inside each nested `concepts` row, so `unnest()` refuses to guess
  which is which. Fixing it with `unnest(concepts, names_sep = "_")` works and produces
  **1,094 rows** (76 works × their concepts). This is presented in the episode as a genuine,
  documented "common wrong turn," not an invented pitfall.
- Top-level (`concepts_level == 0`) concepts for ICPSR, by work count: Computer science (51),
  Political science (30), Sociology (23), Medicine (14), Business (13) — used as the worked
  example for a "top concepts" bar chart.

## Episode structure (what's in the file you're reviewing)

Objectives/questions block → frame story + polite-pool-email callout → Setup/import section
(institution-vs-author decision, live-coded ICPSR fetch, two challenges: "find your own ID,"
"fetch and eyeball") → discussion challenge ("why query this directly vs. a vendor tool like
Scopus/Web of Science?") → Clean/transform section (`glimpse()`, the real unnest error + fix, two
challenges: "spot the shape," "tidy one nested field") → Visualize section (two real `ggplot2`
charts: publications-per-year, top concepts; two challenges: "transfer the pattern," "pick your
own question") → Report section (inline-`` `r` `` summary sentence, capstone challenge: knit a
snapshot as if handing it to the patron, swap with a neighbor playing the patron and see if they
can read it cold) → wrap-up discussion (what can't OpenAlex tell you) → keypoints.

Teaching time budget: 45 min teaching / 15 min exercises (same as the other episodes in this
lesson, each roughly similar length).

## What I want you to actually challenge

Don't just say "looks good" — give me a confidence score (0-100) on whether this episode is
workshop-ready as designed, and be specific about failure modes:

1. **Scope-to-time fit.** Setup, cleaning (including a real debugging moment), two chart types,
   and a knit-a-report capstone, inside 45/15 minutes — is that realistic, or does something
   need to be cut? What's the first thing you'd cut if a live workshop ran over?
2. **The patron-consultation frame — authentic or contrived?** Does casting learners as
   "librarian fields a bibliometrics request" add real pedagogical value over just "explore an
   API," or does it add narrative overhead without teaching anything the plain framing wouldn't?
3. **Live-API reliability risk for the learner-choice challenges.** Even individually (not all
   76 learners hitting the same query), is having each learner run a *live, unbounded* search
   against a real API during a timed workshop exercise still too fragile (network flakiness,
   an ambiguous search returning a huge or zero-row result, conference wifi)? What's a more
   robust fallback if a learner's live fetch fails mid-exercise?
4. **The self-profile (author) path — any concerns?** Is having learners search their own
   name/ORCID and look at their own citation counts pedagogically fine, or does it risk being
   uncomfortable/exposing for a learner with a thin or nonexistent publication record, especially
   library staff who aren't primarily researchers themselves?
5. **The "solution" divs for personalized challenges.** Because the right answer depends on each
   learner's own chosen institution/author, the solutions in the draft show the ICPSR example as
   a worked model ("substitute your own") rather than a fixed answer key. Is that adequate
   scaffolding, or does it leave too much for learners to improvise without a real safety net?
6. **The capstone's assessment design.** "Swap reports with a neighbor playing the patron" —
   does this actually assess the stated objectives, or is it too soft/subjective to function as
   a real check that the episode's core skill landed?
7. Anything else genuinely wrong or missing that a Carpentries-style lesson reviewer would flag
   (accessibility, technical accuracy of the R code as described, pedagogical sequencing).

Give concrete corrections, not vibes — if something needs to change, say what to change it to.
