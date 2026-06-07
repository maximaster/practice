// Reads canonical `key=value` pairs from the repo's .env.example.
//
// Tola pins Typst's project root to www/, and Typst refuses to read files
// outside the root. The repo root lives one level up, so we expose the needed
// files through www/root/ — a real directory of individual file symlinks that
// mirror the repo layout (folders are NOT symlinked, only files). Typst follows
// a symlink located inside the root without re-checking the target, so
// `read("../root/.env.example")` reaches the real .env.example.
//
// Why: values such as memory limits live once (in .env.example, where docker
// compose also reads them) and the guide renders them via data-loading — the
// docs can't drift from the config.
//
// Usage:
//   #import "../utils/env.typ": ENV
//   #ENV.at("RECALL_PHP_MEMORY_LIMIT")   // -> "96M"

#let parse-dotenv(raw) = {
  let out = (:)
  for line in raw.split("\n") {
    let t = line.trim()
    if t == "" or t.starts-with("#") { continue }
    let i = t.position("=")
    if i == none { continue }
    out.insert(t.slice(0, i).trim(), t.slice(i + 1).trim())
  }
  out
}

#let ENV = parse-dotenv(read("../root/.env.example"))
