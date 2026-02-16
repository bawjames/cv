// Settings
#set text(size: 13pt)
#set page(margin: 4em)
#set terms(tight: false, indent: 1em, hanging-indent: 1em)
#set stack(spacing: 1em)
#set par(first-line-indent: (amount: 1em, all: true), hanging-indent: 1em)

// Show rules
#show heading: smallcaps
#show heading.where(level: 1): align.with(center)
#show title: smallcaps
#show strong: smallcaps
#show link: underline
#show link: text.with(fill: maroon.darken(50%))

// Let bindings
#let data = yaml("curriculum-vitae.yml")

#let date = s => toml(bytes("date = " + s)).date.display("[month repr:short] [year]")

#let contacts = [
  / Email: #link("mailto:" + data.contacts.email, data.contacts.email)
  / Phone: #data.contacts.phone
  / Github: #link(data.contacts.github)
  // / LinkedIn: #link()
  / Updated: #datetime.today().display("[day] [month repr:short] [year]")
]

#context {
  stack(
    spacing: 1fr,
    dir: ltr,
    title(data.author) + [=== Curriculum Vitae],
    contacts,
  )
}

#line(length: 100%)

#let employment = data.employment.map(item => {
  let reserved = ("where", "start", "end")

  let end = if "end" in item {
    date(item.at("end"))
  } else [Present]

  heading(level: 2, item.where) + terms(
    tight: true,
    ([Period], date(item.start) + " - " + end),
    ..item.pairs().filter(((k, _)) => k not in reserved),
  )
})

#let projects = data.projects.map(item => {
  heading(level: 2, item.what)
  item.desc
  linebreak()
  link(item.link, [See more])
})

#let interests = data.interests.map(item => {
  heading(level: 2, item.what)
  item.desc
})

#columns(2, gutter: 2em)[
  // Experience
  = Experience

  #box(align(center, smallcaps(
    data.languages.join(h(.5em))
  )))

  #stack(..employment)

  = Projects
  #stack(..projects)

  #colbreak()
  = Interests
  #stack(..interests)
]
