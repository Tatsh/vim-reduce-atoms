<!-- markdownlint-configure-file {"MD024": { "siblings_only": true } } -->

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.1/), and this project
adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [unreleased]

## [0.0.1] - 2026-08-06

### Added

- First version.
- `:ReduceAtoms` command, which reduces every Portage atom in the current buffer to a bare
  `category/package` and leaves the rest of each line, including USE flags, byte-for-byte
  identical.
- `:ReduceAtoms!` variant, which keeps the `:<slot>` restriction on each atom.
- Range support, so `:.ReduceAtoms`, `:5,10ReduceAtoms`, and `:'<,'>ReduceAtoms` all work. Without
  an explicit range, the whole buffer is processed.

[unreleased]: https://github.com/Tatsh/vim-reduce-atoms/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/Tatsh/vim-reduce-atoms/releases/tag/v0.0.1
