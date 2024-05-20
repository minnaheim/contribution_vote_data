#set heading(numbering: none)
== A1. Code

The Data, Code, Analysis and Plots used to construct this paper can be found on
my github profile: https://github.com/minnaheim/contribution_vote_data. This
paper was written using typst, based on the template from the Technical
University of Munich: https://github.com/ls1intum/thesis-template-typst.

== A2. Additional Models
#figure(
  image("../figures/desc-stats.png", width: 90%),
  caption: [the descriptive statistics of the main dataset used for the analysis#footnote(
      "the variable Instance refers to the Votes. The Instances are 3, 4, 51, 52, 6 and 7, where 3 stands for the vote in the 113th congress, 51 stands for the first vote in the 115th congress, 52 for the second vote in the 115th congress, etc. The district variable refers to the district which the legislators represented. Sadly not all representatives had the district information.",
    )
  ],
) <desc-stats>

#figure(
  image("../figures/party_models.png", width: 65%),
  caption: [Column 1: OLS Party, column 2: Conditional Logit Party],
) <party>

#figure(
  image("../figures/lpmpervote.png", width: 110%),
  caption: [the LPM models of each vote, with all relevant contributions leading up to the
    vote.],
)<lpm-per-vote>

#figure(
  image("../figures/log_transformed.png", width: 60%),
  caption: [the logistically transformed LPM models],
) <lpm-log-trafo>

== A3. Declaration of Aids

#table(
  columns: 2,
  [*Type of Aid*],
  [*Use of Aid*],
  [Github Copilot],
  [Used for coding repeatitive things in R],
  [DeepL Write],
  [Applied over entire thesis to improve spelling and wording],
  [ChatGPT],
  [Applied over entire thesis to improve wording],
  [Quillbot],
  [Applied over entire thesis to paraphrase text from sources],
)

== A4. Declaration of Authorship

I hereby declare,
#list(
  indent: 2em,
  [that I have written this thesis independently],
  [that I have written the thesis using only the aids specified in the index;],
  [that all parts of the thesis produced with the help of aids have been precisely
    declared;],
  [that I have mentioned all sources used and cited them correctly according to
    established aca- demic citation rules;],
  [that I have acquired all immaterial rights to any materials I may have used,
    such as images or graphics, or that these materials were created by me;],
  [that the topic, the thesis or parts of it have not already been the object of
    any work or examina- tion of another course, unless this has been expressly
    agreed with the faculty member in ad- vance and is stated as such in the thesis;],
  [that I am aware of the legal provisions regarding the publication and
    dissemination of parts or the entire thesis and that I comply with them
    accordingly;],
  [that I am aware that my thesis can be electronically checked for plagiarism and
    for third-party authorship of human or technical origin and that I hereby grant
    the University of St.Gallen the copyright according to the Examination
    Regulations as far as it is necessary for the administra- tive actions;],
  [that I am aware that the University will prosecute a violation of this
    Declaration of Authorship and that disciplinary as well as criminal consequences
    may result, which may lead to expul- sion from the University or to the
    withdrawal of my title.],
)

By submitting this thesis, I confirm through my conclusive action that I am
submitting the Declaration of Authorship, that I have read and understood it,
and that it is true.

\
\
21.05.2024

\
\
Minna Emilia Hagen Heim