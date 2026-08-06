# vim-reduce-atoms

<!-- WISWA-GENERATED-README:START -->

[![GitHub tag (with filter)](https://img.shields.io/github/v/tag/Tatsh/vim-reduce-atoms)](https://github.com/Tatsh/vim-reduce-atoms/tags)
[![License](https://img.shields.io/github/license/Tatsh/vim-reduce-atoms)](https://github.com/Tatsh/vim-reduce-atoms/blob/master/LICENSE.txt)
[![GitHub commits since latest release (by SemVer including pre-releases)](https://img.shields.io/github/commits-since/Tatsh/vim-reduce-atoms/v0.0.0/master)](https://github.com/Tatsh/vim-reduce-atoms/compare/v0.0.0...master)
[![Dependabot](https://img.shields.io/badge/Dependabot-enabled-blue?logo=dependabot)](https://github.com/dependabot)
[![Stargazers](https://img.shields.io/github/stars/Tatsh/vim-reduce-atoms?logo=github&style=flat)](https://github.com/Tatsh/vim-reduce-atoms/stargazers)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Tatsh/vim-reduce-atoms/master.svg)](https://results.pre-commit.ci/latest/github/Tatsh/vim-reduce-atoms/master)
[![Prettier](https://img.shields.io/badge/Prettier-black?logo=prettier)](https://prettier.io/)

[![@Tatsh](https://img.shields.io/badge/dynamic/json?url=https%3A%2F%2Fpublic.api.bsky.app%2Fxrpc%2Fapp.bsky.actor.getProfile%2F%3Factor=did%3Aplc%3Auq42idtvuccnmtl57nsucz72&query=%24.followersCount&label=Follow+%40Tatsh&logo=bluesky&style=social)](https://bsky.app/profile/Tatsh.bsky.social)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-Tatsh-black?logo=buymeacoffee)](https://buymeacoffee.com/Tatsh)
[![Libera.Chat](https://img.shields.io/badge/Libera.Chat-Tatsh-black?logo=liberadotchat)](irc://irc.libera.chat/Tatsh)
[![Mastodon Follow](https://img.shields.io/mastodon/follow/109370961877277568?domain=hostux.social&style=social)](https://hostux.social/@Tatsh)
[![Patreon](https://img.shields.io/badge/Patreon-Tatsh2-F96854?logo=patreon)](https://www.patreon.com/Tatsh2)

<!-- WISWA-GENERATED-README:STOP -->

Reduce Portage atoms in the current buffer to bare `category/package`, keeping the rest of each line
(USE flags) exactly as written.

```plain
>=dev-python/jaraco-functools-4.6.0 python_targets_python3_13
```

becomes

```plain
dev-python/jaraco-functools python_targets_python3_13
```

Handy for cleaning up `/etc/portage/package.use`, `package.accept_keywords` and friends after
pasting output from `emerge`, `eix` or a bug report.

## Requirements

`qatom` from `app-portage/portage-utils`, which does all the actual atom parsing (operators,
versions, revisions, slots, sub-slots, `::repo`, `[use,deps]` and wildcards).

## Usage

| Command             | Effect                                                                |
| ------------------- | --------------------------------------------------------------------- |
| `:ReduceAtoms`      | Reduce every line in the buffer (no range or visual selection needed) |
| `:ReduceAtoms!`     | Same, but keep the `:<slot>` restriction                              |
| `:.ReduceAtoms`     | Current line only                                                     |
| `:5,10ReduceAtoms`  | Lines 5 through 10                                                    |
| `:'<,'>ReduceAtoms` | Visual selection                                                      |

The command name is `:ReduceAtoms` and not `:reduce-atoms` because Vim user commands must start with
an uppercase letter and contain only alphanumerics (`:help E183`).

Handled automatically:

- Blank lines and `#` comments are left alone.
- Leading indentation and the original spacing between the atom and its USE flags are preserved byte
  for byte.
- Lines `qatom` cannot resolve to a qualified atom are skipped, not mangled; the count is reported.
- Running it twice changes nothing the second time.
- All atoms go to `qatom` in one process (batched at 1000 per invocation to stay under `ARG_MAX`),
  so a large `package.use` is a single fork.

## Install

```sh
install -Dm640 plugin/reduce_atoms.vim ~/.vim/plugin/reduce_atoms.vim
install -Dm640 autoload/reduceatoms.vim ~/.vim/autoload/reduceatoms.vim
```

Or point any package manager at this directory, e.g. with Vim 8 packages:

```sh
ln -s "$PWD" ~/.vim/pack/portage/start/vim-reduce-atoms
```
