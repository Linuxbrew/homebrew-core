#:  * `strip` [`--all`]
#:    Strip binary executables and libraries to reduce their size.
#:
#:    If `--all` is passed, strip all installed formulae.

require File.expand_path("../strip", __FILE__)

odie "Command not found: strip" unless which "strip"
formulae = if ARGV.include?("--all") || ARGV.include?("--installed")
  Formula.installed
else
  raise FormulaUnspecifiedError if ARGV.named.empty?
  ARGV.resolved_formulae
end.sort
formulae.each { |f| Homebrew.strip_formula f }
