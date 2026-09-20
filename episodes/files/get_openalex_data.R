if (!dir.exists("data"))
    dir.create("data")

# Cached fixture for the instructor's live-coded Public Knowledge Project
# (PKP) example, so the in-workshop demo doesn't depend on the live OpenAlex
# API (rate limits / network reliability with a full room). PKP develops
# free, open-source scholarly-publishing software (Open Journal Systems and
# others) that many libraries actually run, and has no membership gate or
# legal-controversy baggage. Earlier drafts tried ICPSR (a paid-membership
# research consortium) and the Internet Archive (open to everyone, but its
# scholarly-works count is easily confused with its archive holdings) before
# landing here. Learners' own institution/author fetches in the challenges
# stay live by design, with a fallback to this same cached data if their
# fetch is ambiguous, too large, or too slow.
#
# The from_publication_date filter excludes 2 records dated 1969, which
# predate PKP's actual 1998 founding and are almost certainly misattributed.
#
# Regenerate this fixture by deleting the .rds below and re-running this
# script. See the matching *-PROVENANCE.md file for retrieval details.
if (! file.exists("data/pkp-works-2026-09-20.rds")) {
  library(openalexR)
  pkp_works <- oa_fetch(
    entity = "works",
    authorships.institutions.id = "I4387153203",
    from_publication_date = "1998-01-01"
  )
  n <- nrow(pkp_works)
  saveRDS(pkp_works, "data/pkp-works-2026-09-20.rds")
  prov_lines <- c(
    "# Fixture provenance: episodes/data/pkp-works-2026-09-20.rds",
    "",
    "- Source: OpenAlex API (https://api.openalex.org)",
    "- Entity: works",
    "- Filter: authorships.institutions.id = \"I4387153203\" (Public Knowledge Project)",
    "- Additional filter: from_publication_date = \"1998-01-01\" (excludes 2 pre-1998 records that predate PKP's actual 1998 founding, likely misattributed legacy data)",
    paste0("- Retrieved: ", Sys.Date()),
    paste0("- openalexR version: ", as.character(packageVersion("openalexR"))),
    paste0("- Rows retrieved: ", n),
    "- Regenerate with: episodes/files/get_openalex_data.R",
    ""
  )
  writeLines(prov_lines, "data/pkp-works-2026-09-20-PROVENANCE.md")
}
