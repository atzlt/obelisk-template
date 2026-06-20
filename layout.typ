// Paper measures
#let width = 21cm
#let height = width * calc.sqrt(2)

// Paper margins
#let t-margin = width / 9
#let e-margin = width / 4
#let f-margin = width / 6
#let s-margin = width / 9

// Text body measures
#let t-width = width - s-margin - e-margin
#let t-height = height - t-margin - f-margin

// Gutter and margin sidenotes
#let half-gutter = 0.3cm
#let e-margin-margin = s-margin / 3

// Text measures
#let text-size = 12pt
#let text-height = 9pt // Approximately the ascender height

// Baseline grid
#let step = 16pt
#let step-num = calc.floor(t-height / step)
#let f-margin = height - t-margin - step-num * step // recalculate bottom margin to align with baseline grid

#let box-top-outset = text-height + half-gutter
#let margin-w = e-margin - half-gutter - e-margin-margin

// Fonts
#let body-font = "TeX Gyre Pagella"
#let math-font = "TeX Gyre Pagella Math"
#let sans-font = "Switzer"
#let mono-font = "IBM Plex Mono"

#let bblock(it, ..args) = context {
  set text(top-edge: "bounds", bottom-edge: "bounds")
  let height = measure({
    set text(top-edge: "bounds", bottom-edge: "bounds")
    it
  }).height
  let desired-height = calc.round(height / step)
  block(v(step * 2 / 3), spacing: 0pt, sticky: true)
  block(
    height: desired-height * step,
    align(horizon, it),
    // stroke: 1pt,
    above: 0pt,
    below: step,
    sticky: true,
    ..args,
  )
  block(v(step / 3), spacing: 0pt, sticky: true)
}

#let place-side(it, dx: 0pt, dy: 0pt, ..args) = context {
  let page-num = counter(page).get().first()
  let move = if calc.even(page-num) {
    -e-margin + dx
  } else {
    t-width - e-margin-margin + half-gutter + dx
  }
  let flush = if calc.even(page-num) {
    right
  } else {
    left
  }
  set par(justify: false)
  let boxed = box(
    width: e-margin - half-gutter,
    inset: (
      left: half-gutter + e-margin-margin,
      right: half-gutter,
    ),
    outset: (
      top: half-gutter + text-height,
      bottom: half-gutter,
    ),
    ..args,
    align(flush, it),
  )
  place(dx: move, dy: dy, boxed)
}

#let place-node(sym, dy: 0pt) = context {
  let page-num = counter(page).get().first()
  let width = measure(sym).width
  let dx = if calc.even(page-num) {
    half-gutter + width / 2
  } else {
    -half-gutter - width / 2
  }
  place-side(sym, dx: dx, dy: dy)
}

#let small(it, scale: 2 / 3, size: 0.75em) = {
  let step = step * scale
  set par(leading: step)
  text(size, it)
}

#let theorem-render(
  env,
  name,
  numstr,
  it,
  color: rgb("#A63A2B"),
) = context {
  let page-num = counter(page).get().first()
  let side = block(width: margin-w, text(
    fill: color,
    font: sans-font,
    [*#env #numstr*\ #if name != none { name }],
  ))
  let s-height = measure(side).height
  let bottom-out = step - text-height
  let body-stroke = if calc.even(page-num) {
    (
      left: color + 3pt,
    )
  } else {
    (
      right: color + 3pt,
    )
  }
  let body = block(
    [#place-side(side) #it],
    width: t-width,
    breakable: false,
  )
  let b-height = measure(body).height
  block(
    body,
    height: calc.max(b-height, s-height),
    stroke: body-stroke,
    outset: (
      left: half-gutter,
      right: half-gutter,
      top: text-height + bottom-out,
      bottom: bottom-out,
    ),
  )
}

#let sidenote(it) = context {
  let page-num = counter(page).get().first()
  let posx = here().position().x
  sym.wj
  let dx = if calc.even(page-num) {
    -posx + e-margin
  } else {
    -posx + s-margin
  }
  box(place-side(small(it), dx: dx))
  h(0pt, weak: true)
}

#let blank-page(..args) = {
  set page(
    background: {
      v(2fr)
      align(center, text(
        font: mono-font,
        fill: luma(150),
      )[\/\/ This page is intentionally left blank.])
      v(3fr)
    },
    footer: none,
    header: none,
  )
  pagebreak(..args)
}
