// Email-card component: renders a message the way an email app shows it —
// subject, sender avatar/name/address, recipient, date, then the body.
//
// Usage:
//   #import "../utils/email.typ": email
//   #email(
//     subject: "...",
//     from-name: "...",
//     from-addr: "...",
//     to: "...",
//     date: "...",
//   )[ letter body ]

#import "tola.typ": to-string

#let email(
  subject: none,
  from-name: none,
  from-addr: none,
  to: none,
  date: none,
  // Avatar glyph; defaults to the first letter of the sender name.
  avatar: none,
  body,
) = {
  let initial = if avatar != none {
    avatar
  } else if from-name != none {
    upper(to-string(from-name).clusters().at(0, default: "?"))
  } else {
    "?"
  }

  html.elem("article", attrs: (class: "email"), {
    html.elem("header", attrs: (class: "email-head"), {
      if subject != none {
        html.elem("div", attrs: (class: "email-subject"), subject)
      }
      html.elem("div", attrs: (class: "email-meta"), {
        html.elem("span", attrs: (class: "email-avatar", "aria-hidden": "true"), initial)
        html.elem("div", attrs: (class: "email-ident"), {
          html.elem("div", attrs: (class: "email-from"), {
            if from-name != none {
              html.elem("span", attrs: (class: "email-name"), from-name)
            }
            if from-addr != none {
              html.elem("span", attrs: (class: "email-addr"), from-addr)
            }
          })
          if to != none {
            html.elem("div", attrs: (class: "email-to"), [кому: #to])
          }
        })
        if date != none {
          html.elem("time", attrs: (class: "email-date"), date)
        }
      })
    })
    html.elem("div", attrs: (class: "email-body"), body)
  })
}
