# Contributing to Linuxbrew

[Linuxbrew](https://github.com/Linuxbrew/homebrew-core) is a fork of [Homebrew](https://github.com/Homebrew/homebrew-core). Homebrew/homebrew-core is merged into Linuxbrew/homebrew-core roughly once per week. If you have access to a macOS system and are able to test your changes there: to contribute a new formula or a new version of an existing formula, please submit your pull request to Homebrew rather than to Linuxbrew. If not, please submit your pull requests to Linuxbrew. Patches to fix issues that you have reproduced on both Linuxbrew and Homebrew on macOS should be sent to Homebrew. Please send your pull request to Linuxbrew if you are in doubt.

Patches to fix issues particular to Linux should not affect the behaviour of the formula on macOS. Use `if OS.mac?` and `if OS.linux?` as necessary to preserve the existing behaviour on macOS.

First time contributing to Linuxbrew? Read our [Code of Conduct](https://github.com/Linuxbrew/brew/blob/master/CODEOFCONDUCT.md#code-of-conduct).

### Report a bug

* run `brew update` (twice)
* run and read `brew doctor`
* read [the Troubleshooting Checklist](http://docs.brew.sh/Troubleshooting.html)
* open an issue on the formula's repository

### Submit a version upgrade for the `foo` formula

* check if the same upgrade has been already submitted by [searching the open pull requests for `foo`](https://github.com/Linuxbrew/homebrew-core/pulls?utf8=✓&q=is%3Apr+is%3Aopen+foo).
* `brew bump-formula-pr --strict foo` with `--url=...` and `--sha256=...` or `--tag=...` and `--revision=...` arguments.

### Add a new formula for `foo` version `2.3.4` from `$URL`

* read [the Formula Cookbook](http://docs.brew.sh/Formula-Cookbook.html) or: `brew create $URL` and make edits
* `brew install --build-from-source foo`
* `brew audit --new-formula foo`
* `git commit` with message formatted `foo 2.3.4 (new formula)`
* open a pull request and fix any failing tests

### Contribute a fix to the `foo` formula

* `brew edit foo` and make edits
* leave the [`bottle`](http://www.rubydoc.info/github/Homebrew/brew/master/Formula#bottle-class_method) as-is
* `brew uninstall --force foo`, `brew install --build-from-source foo`, `brew test foo`, and `brew audit --strict foo`
* `git commit` with message formatted `foo: fix <insert details>`
* open a pull request and fix any failing tests

Thanks!
