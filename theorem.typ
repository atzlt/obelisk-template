#import "layout.typ": *

#let thm-counter = counter("theorem")

#let init-theorem(it, base-level: 1) = {
  // 1. Suppress default figure layout for theorems so we only see your custom styling
  show figure.where(kind: "theorem"): it => align(
    left,
    it.body,
  )

  thm-counter.update((1,))

  // 2. Reset the shared theorem counter every time a top-level section (Heading 1) begins
  show heading: it => {
    it
    if it.numbering != none and it.level <= base-level {
      context {
        let h-val = counter(heading).get()
        // Reset the theorem level to 0, maintaining the current heading prefix
        thm-counter.update(h-val + (1,))
      }
    }
  }

  // 3. Custom reference logic for @tag and @tag[!]
  show ref: it => {
    let el = it.element
    if (
      el != none and el.func() == figure and el.kind == "theorem"
    ) {
      let loc = el.location()

      // Handle @tag[!]
      if it.supplement == [!] and el.caption != none {
        return link(loc, el.caption.body)
      } else {
        return link(loc, [#el.supplement #numbering("1.1.1", ..thm-counter.at(loc))])
      }
    }
    return it
  }
  it
}

// Make a theorem environment.
#let make-environment(
  full-name,
  short-name,
  accent-color,
) = {
  return (..args) => {
    let pos = args.pos()
    let title = none
    let body = none

    let num = context {
      let base-level = default-settings.get().heading.thm.base
      thm-counter.step(level: base-level + 1)
      numbering("1.1.1", ..thm-counter.get())
    }

    if pos.len() == 1 {
      body = pos.at(0)
    } else if pos.len() == 2 {
      title = pos.at(0)
      body = pos.at(1)
    } else {
      panic(
        "Theorem environments expect exactly 1 or 2 positional arguments.",
      )
    }

    figure(
      kind: "theorem",
      supplement: full-name, // Injects the full name (e.g., "Theorem") into the reference
      caption: title,
      outlined: false,
    )[
      #context {
        theorem-render(
          short-name,
          title,
          num,
          body,
          color: accent-color,
        )
      }
    ]
  }
}

#let theorem = make-environment(
  "Theorem",
  "THM",
  rgb("#1e3a8a"),
)
#let lemma = make-environment(
  "Lemma",
  "LEM",
  rgb("#065f46"),
)
#let proposition = make-environment(
  "Proposition",
  "PROP",
  rgb("#5b21b6"),
)
#let corollary = make-environment(
  "Corollary",
  "COR",
  rgb("#0e7490"),
)
#let definition = make-environment(
  "Definition",
  "DEF",
  rgb("#991b1b"),
)
#let example = make-environment(
  "Example",
  "EX",
  rgb("#475569"),
)
#let remark = make-environment(
  "Remark",
  "REM",
  rgb("#854d0e"),
)

#let proof(..args) = context {
  let pos = args.pos()
  let title = none
  let body = none

  if pos.len() == 1 {
    body = pos.at(0)
  } else if pos.len() == 2 {
    title = pos.at(0)
    body = pos.at(1)
  } else {
    panic(
      "Proof environment expect exactly 1 or 2 positional arguments.",
    )
  }
  let def = default-settings.get()
  let ascender = def.texts.ascender
  let half-gutter = def.side.half-gutter
  sblock(
    width: 100%,
    offset: half-gutter,
    outset: (
      left: half-gutter,
      right: half-gutter,
      top: ascender,
      bottom: 0pt,
    ),
    stroke: 0.8pt + luma(240),
    breakable: true,
  )[
    _#if title != none { [#title] } else { [Proof] }._ #body #h(1fr) $square$
  ]
}
