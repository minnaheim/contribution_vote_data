#let abstract_en() = {
  set page(
    margin: (left: 30mm, right: 30mm, top: 40mm, bottom: 40mm),
    numbering: none,
    number-align: center,
  )

  let body-font = "New Computer Modern"
  let sans-font = "New Computer Modern Sans"

  set text(font: body-font, size: 12pt, lang: "en")

  set par(leading: 1em, justify: true)

  // --- Abstract (DE) ---
  v(1fr)
  align(center, text(font: body-font, 1em, weight: "semibold", "Abstract"))

  text[Wealthy donors such as the Koch brothers of Koch Industries have contributed
    over 27 million USD to various congressional candidates in the 2022 election.
    This paper analyses whether contributions from anti-environmental interest
    groups such as Koch Industries influence congressional voting on environmental
    issues. Building on the work of #cite(<stratmann-2002>, form: "prose"), it
    examines repeated roll-call votes on methane pollution and the corresponding
    campaign contributions received by US representatives within six months of these
    votes. Applying a causal identification strategy, the analysis attempts to
    determine the impact of pro- and anti-environmental contributions on voting
    behavior. The analysis shows that pro-(anti-)environmental contributions have a
    positive (negative) effect on environmental voting behavior, although no causal
    relationship can be definitively established due to the small number of
    representatives who change their voting behavior.]

  v(1fr)
}

// Note:
// 1. *paragraph:* What is the motivation of your thesis? Why is it interesting from a scientific point of view? Which main problem do you like to solve?
// 2. *paragraph:* What is the purpose of the document? What is the main content, the main contribution?
// 3. *paragraph:* What is your methodology? How do you proceed?

// first version
// Wealthy donors such as the Koch brothers, of the fossil fuel conglomerate Koch Industries, have contributed more than 27 million USD to various congressional candidates in the 2022 congressional elections. What are these contributions achieving? Are anti-environmental interest groups like Koch Industries contributing to the campaigns of congressional candidates to change their votes on environmental issues? These issues are discussed and analysed in this paper. Building on the work of Stratmann (2002), the paper analyses repeated rollcall votes on methane pollution and the corresponding campaign contributions received by US representatives within six months prior to these votes, using a causal identification strategy approach to identify the relationship between pro-environmental votes and pro-(anti)-environmental contributions, and whether these contributions are able to significantly change voting behaviour. This paper finds that pro (anti) environmental contributions positively (negatively) affect pro-environmental voting behaviour, although no causal relationship can be inferred given the small number of representatives who change their pro-environmental voting behaviour.