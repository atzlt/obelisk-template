#import "layout.typ": *
#import "theorem.typ": *

#let init(it) = {
  set page(
    margin: (
      top: t-margin + step,
      outside: e-margin,
      inside: s-margin,
      bottom: f-margin,
    ),
    background: context {
      let page-num = counter(page).get().first()
      let dx = if calc.even(page-num) {
        e-margin - half-gutter
      } else {
        width - e-margin + half-gutter
      }
      place(
        top + left,
        dx: dx,
        dy: 0pt,
        line(
          start: (0%, 0%),
          end: (0%, 100%),
          stroke: 0.75pt + luma(180),
        ),
      )
      // place(
      //   top + left,
      //   dx: e-margin,
      //   dy: t-margin,
      //   grid(
      //     columns: (t-width,),
      //     stroke: (bottom: 0.5pt + gray),
      //     ..(block(width: 100%, height: step),) * 42
      //   ),
      // )
      let dx = if calc.even(page-num) {
        width - s-margin + half-gutter
      } else {
        s-margin - half-gutter - 3pt
      }
      let rot = if calc.even(page-num) {
        90deg
      } else {
        -90deg
      }
      set text(
        font: mono-font,
        features: ("tnum",),
        size: 0.66em,
        fill: luma(210),
      )
      for i in range(step-num) {
        place(
          dx: dx,
          dy: t-margin + step * (i + 1) - text-height / 4,
          rotate(rot, [#(
            "0123456789ABCDEF".at(calc.rem-euclid(i, 16))
          )]),
        )
      }
    },
    footer: context {
      let page-num = counter(page).get().first()
      let t = text(
        font: mono-font,
        fill: luma(180),
      )[[ #text(fill: luma(60))[#page-num] ]]
      let dx = -t-width / 2 - half-gutter
      place(
        bottom + center,
        dx: if calc.even(page-num) {
          dx
        } else {
          -dx
        },
        dy: -half-gutter - step,
        box(
          fill: white,
          outset: (
            top: half-gutter + text-height,
            bottom: half-gutter,
          ),
          t,
        ),
      )
    },
  )

  set text(
    font: body-font,
    size: text-size,
    top-edge: "baseline",
    bottom-edge: "baseline",
  )

  show math.equation: set text(font: math-font)

  set par(
    leading: step,
    spacing: step * 2,
    justify: true,
  )

  show math.equation.where(block: true): it => {
    set block(breakable: true)
    set par(leading: step / 2)
    bblock(it, breakable: true)
  }


  set heading(numbering: (..levels) => {
    let parts = levels.pos()
    if parts.len() > 1 {
      // For Level 2+ headings (e.g., == Subsection)
      parts.map(str).join(".")
    } else {
      none
    }
  })

  show math.equation.where(block: false): it => context {
    let h = measure({
      set text(top-edge: "bounds", bottom-edge: "bounds")
      it
    }).height
    let g = (calc.ceil((h - step * 1.2) / step)) * step
    box(
      it,
      height: g,
      outset: (top: step),
      // stroke: 0.5pt,
    )
  }

  show heading: it => {
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    set par(leading: step * 2, justify: false)
    set text(font: sans-font)
    block(it)
  }

  show heading.where(level: 1): it => context {
    blank-page(to: "odd", weak: true)
    let h1 = counter(heading).at(here()).at(0)
    place(
      top + right,
      dx: e-margin + 10pt,
      dy: -t-margin - step - 10pt,
      box(
        stroke: 0.75pt + luma(180),
        fill: white,
        width: 7cm,
        height: 7cm,
        align(
          center + horizon,
          text(
            font: sans-font,
            size: 120pt,
            fill: white,
            top-edge: "bounds",
            bottom-edge: "bounds",
            stroke: 1.5pt + luma(180),
            [#h1],
          ),
        ),
      ),
    )
    v(step * 12)
    text(
      size: 40pt,
      font: sans-font,
      align(right)[
        #text(weight: "light")[Section #h1]\ #text(
          weight: "extrabold",
          it,
        )
      ],
    )
    v(step * 3)
  }

  show heading.where(level: 2): it => {
    set text(size: 24pt)
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    block(breakable: false)[#place-node(
        $circle.filled$,
        dy: -4pt,
      ) #h(2pt)#box(it)]
  }

  show heading.where(level: 3): it => {
    set text(size: 16pt)
    set block(
      above: step * 3,
      below: step * 2,
      breakable: false,
    )
    block(breakable: false)[#place-node(
        $triangle.filled.small.b$,
        dy: 2pt,
      ) #it]
  }

  show: init-theorem

  it
}
