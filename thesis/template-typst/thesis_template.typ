#import "@preview/glossarium:0.4.0": make-glossary, print-glossary, gls, glspl
#show: make-glossary

#let project(
  title: "",
  titleGerman: "",
  degree: "",
  program: "",
  supervisor: "",
  advisors: (),
  author: "",
  startDate: none,
  submissionDate: none,
  body,
) = {
  // set document(title: title, author: author)
  set page(
    margin: (left: 30mm, right: 30mm, top: 40mm, bottom: 40mm),
    numbering: "1",
    number-align: center,
  )

  let body-font = "New Computer Modern"
  let sans-font = "New Computer Modern Sans"

  set text(font: body-font, size: 12pt, lang: "en")

  show math.equation: set text(weight: 400)
  set math.equation(numbering: "(1)")

  // --- Headings ---
  show heading: set block(below: 0.85em, above: 1.75em)
  show heading: set text(font: body-font)
  set heading(numbering: "1.1")
  // Reference first-level headings as "chapters"
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading and el.level == 1 {
      [Chapter ]
      numbering(el.numbering, ..counter(heading).at(el.location()))
    } else {
      it
    }
  }

  // --- Paragraphs ---
  set par(leading: 1em)

  // --- Citations ---
  set cite(style: "american-psychological-association")

  // --- Figures ---
  show figure: set text(font: body-font, size: 0.85em)

  // --- Table of Contents ---
  outline(title: {
    text(font: body-font, 1.5em, weight: 700, "Contents")
    v(15mm)
  }, indent: 2em)

  // List of figures.
  pagebreak()
  heading(numbering: none)[List of Figures]
  outline(title: "", target: figure.where(kind: image))

  // List of tables.
  pagebreak()
  heading(numbering: none)[List of Tables]
  outline(title: "", target: figure.where(kind: table))

  // List of abbreviations.
  pagebreak()
  heading(numbering: none)[List of Abbreviations]

  // create abbreviations
  print-glossary((
    // minimal term
    (key: "LPM", short: "LPM", long: "Linear Probability Model"),
    (key: "FEC", short: "FEC", long: "Federal Election Commission"),
    (key: "PAC", short: "PAC", long: "Political Action Committee"),
    (key: "EPA", short: "EPA", long: "Environmental Protection Agency"),
    (key: "LCV", short: "LCV", long: "League  of  Conservation Votes"),
    (key: "VIF", short: "VIF", long: "Variance Inflation Factor"),
    (key: "DW", short: "DW-Nominate", long: "Dynamic Weighted Nominate"),
    // a term with a long form and a group
  ), show-all: true)

  v(2.4fr)

  // Main body.
  set par(justify: true, first-line-indent: 2em)

  body

  // Appendix.
  pagebreak()
  heading(numbering: none)[Appendix A: Supplementary Material]
  include("thesis_typ/appendix.typ")

  pagebreak()
  bibliography(style: "apa", "thesis.bib")
}
