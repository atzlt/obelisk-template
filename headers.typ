#import "default.typ": default-settings
#import "layout.typ": blank-page, place-node

#let first-level-heading(
  font,
  margin,
  texts,
  two-sided,
  symbol,
  heading,
) = context {
  let step = texts.step
  if two-sided {
    blank-page(to: "odd", weak: true)
  } else {
    blank-page(weak: true)
  }
  let boxed = box(
    stroke: 0.75pt + luma(180),
    fill: white,
    width: 7cm,
    height: 7cm,
    align(
      center + horizon,
      text(
        font: font,
        size: 120pt,
        fill: white,
        top-edge: "bounds",
        bottom-edge: "bounds",
        stroke: 1.5pt + luma(180),
        [#symbol],
      ),
    ),
  )
  if two-sided {
    place(
      top + right,
      dx: margin.e + 10pt,
      dy: -margin.t - step - 10pt,
      boxed,
    )
  } else {
    place(
      top + left,
      dx: -margin.e - 10pt,
      dy: -margin.t - step - 10pt,
      boxed,
    )
  }

  v(step * 12)
  set par(leading: step * 3, justify: false)
  set block(
    above: step * 3,
    below: step * 2,
    breakable: false,
  )
  text(
    size: texts.size * 3.5,
    font: font,
    align(right, heading),
  )
  v(step * 3)
}

#let contents-icon = "<?xml version=\"1.0\" encoding=\"utf-8\"?><svg width=\"800px\" height=\"800px\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\"><path d=\"M4 6H20M4 12H14M4 18H9\" stroke=\"#eaeaea\" stroke-width=\"2\" stroke-linecap=\"square\"/></svg>"

#let show-headers(it) = context {
  let (
    paper,
    margin,
    fonts,
    texts,
    headers,
  ) = default-settings.get()

  show heading: it => {
    set text(font: fonts.sans)
    it
  }

  show heading.where(level: 1): it => context {
    let step = texts.step
    let two-sided = paper.two-sided
    let h1 = counter(heading).at(here()).at(0)
    let heading = [#text(weight: "light")[Section #h1]\ #text(
        weight: "extrabold",
        it,
      )]
    first-level-heading(fonts.sans, margin, texts, two-sided, h1, heading)
  }

  show heading.where(level: 2): it => {
    let step = texts.step
    set text(size: texts.size * headers.h2.size)
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    set par(leading: step * 2, justify: false)
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    block(breakable: false)[#place-node(
        $#headers.h2.sym$,
        dy: headers.h2.dy,
      ) #h(2pt)#box(it)]
  }

  show heading.where(level: 3): it => {
    let step = texts.step
    set text(texts.size * headers.h3.size)
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    set par(leading: step * 2, justify: false)
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    block(breakable: false)[#place-node(
        $#headers.h3.sym$,
        dy: headers.h3.dy,
      ) #it]
  }

  show outline: it => {
    show heading: _ => first-level-heading(
      fonts.sans,
      margin,
      texts,
      paper.two-sided,
      image(bytes(contents-icon), format: "svg", width: 60%),
      [Table of Contents],
    )
    it
  }
  set outline.entry(fill: line(length: 100%, stroke: 0.25pt + luma(180)))
  show outline.entry: it => {
    let res = link(
      it.element.location(),
      if it.level == 1 {
        [Section #numbering("1", ..counter(heading).at(it.element.location())) #it.element.body]
      } else {
        [#numbering("1.1.1", ..counter(heading).at(it.element.location())) #it.element.body]
      },
    )

    if it.fill != none {
      res += [ ] + box(width: 1fr, it.fill) + [ ]
    } else {
      res += h(1fr)
    }

    res += link(it.element.location(), it.page())
    block(
      if it.level == 1 {
        v(texts.step) + strong(res)
      } else {
        h(1.5em * (it.level - 2)) + res
      },
    )
  }

  it
}
