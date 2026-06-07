// Loads source artifacts from the repo so the guide renders real values
// instead of duplicating them. Reads through the www/root/ symlink farm — see
// www/utils/env.typ for why the farm exists (Tola pins Typst's root to www/).
//
// Versions are pinned in the manifests (e.g. slim/slim "4.15.2", php "8.5.*")
// and rendered here trimmed to the precision the prose uses (major / major.minor),
// so a bump in the manifest flows into the guide automatically.
//
// Usage:
//   #import "../utils/repo.typ": php-version, slim-version, logbook-cap

#let _composer = json("../root/app/backend/composer.json")
#let _linecop = yaml("../root/.linecop.yaml")

// Trim a version spec ("8.5.*", "^4", "4.15.2") to the first `parts` segments.
#let trim-version(spec, parts: 2) = {
  let segs = spec.replace(regex("[^0-9.]"), "").split(".").filter(s => s != "")
  segs.slice(0, calc.min(parts, segs.len())).join(".")
}

#let php-version = trim-version(_composer.require.php) // 8.5
#let slim-version = trim-version(_composer.require.at("slim/slim"), parts: 1) // 4

// "≤80 lines" cap comes from the linecop override for LOGBOOK.md.
#let logbook-cap = str(_linecop.overrides.find(o => o.pattern == "LOGBOOK.md").limit)
