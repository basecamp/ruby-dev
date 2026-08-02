## Old Rubies, meet new macOS, Ubuntu, and Arch

Trying to run an old, unsupported Ruby? You're in the right place.

This is a collection of ruby-build definitions for local dev on macOS, Ubuntu, and Arch
(including Omarchy). Not for production use.

Available definitions:

| Version | OpenSSL | Bundler |
|---------|---------|---------|
| 1.8.7-p374 | 1.0.2u | 1.17.3 |
| 1.9.3-p551 | 1.0.2u | 1.17.3 |
| 2.3.3 | 1.0.2u | 1.17.3 |
| 2.3.8 | 1.0.2u | 1.17.3 |
| 2.5.9 | 1.1.1w | 1.17.3 and 2.3.27 |
| 2.7.8 | 1.1.1w | 1.17.3 and 2.4.22 |

Modern OpenSSL dropped the APIs these Rubies need, so each definition brings its own. On
macOS the OpenSSL 1.0 builds come from [basecamp/homebrew-dev](https://github.com/basecamp/homebrew-dev);
everywhere else OpenSSL is compiled from source into the Ruby's own prefix, so nothing
lands system-wide and nothing is shared between versions.

### Prerequisites

**macOS:** Xcode command line tools and [Homebrew](https://brew.sh).

**Ubuntu:**

```bash
sudo apt-get install -y autoconf bison build-essential curl git libdb-dev libffi-dev \
  libgdbm-dev libgmp-dev libncurses5-dev libreadline-dev libssl-dev libyaml-dev \
  patch uuid-dev zlib1g-dev
```

**Arch / Omarchy:**

```bash
sudo pacman -S --needed autoconf base-devel bison git gmp libffi libyaml openssl patch readline zlib
```

### mise

```bash
git clone https://github.com/basecamp/ruby-dev

export RUBY_BUILD_DEFINITIONS="$PWD/ruby-dev"
mise install ruby@1.8.7
```

`RUBY_BUILD_DEFINITIONS` must be an absolute path and must be set for every command that
builds a Ruby — mise shells out to ruby-build, which reads it from the environment. See
[the warning below](#a-warning-that-applies-to-all-of-the-above); a bad path fails silently.

Fuzzy versions resolve to the definitions here, so `ruby@1.8.7` gets you `1.8.7-p374` and
`ruby@2.3` gets you `2.3.8`.

To pin a project to one:

```bash
export RUBY_BUILD_DEFINITIONS="/absolute/path/to/ruby-dev"
mise use ruby@1.8.7-p374
```

### rbenv

Same idea — point `RUBY_BUILD_DEFINITIONS` at the checkout:

```bash
git clone https://github.com/basecamp/ruby-dev

RUBY_BUILD_DEFINITIONS="$PWD/ruby-dev" rbenv install 1.8.7-p374
```

Or skip the environment variable and hand ruby-build the definition file directly:

```bash
git clone https://github.com/basecamp/ruby-dev
cd ruby-dev
rbenv install ./1.8.7-p374
```

Or grab a single definition without cloning:

```bash
curl -O https://raw.githubusercontent.com/basecamp/ruby-dev/main/1.8.7-p374
rbenv install ./1.8.7-p374
```

(Note the leading `./` - this is a path to a specific build definition for ruby-build, not a version specific for it to look for among its built-in definitions.)

### ruby-build on its own

You don't need a version manager. ruby-build installs a Ruby into any prefix you name:

```bash
git clone https://github.com/basecamp/ruby-dev
cd ruby-dev

ruby-build ./1.8.7-p374 ~/.rubies/1.8.7-p374
~/.rubies/1.8.7-p374/bin/ruby --version
```

`RUBY_BUILD_DEFINITIONS` works here too, and is the better choice when something else is
invoking ruby-build on your behalf:

```bash
RUBY_BUILD_DEFINITIONS="$PWD" ruby-build 1.8.7-p374 ~/.rubies/1.8.7-p374
```

This is also the form to use with chruby or any other manager that just wants a directory
of Rubies — build into its search path (`~/.rubies` for chruby) and it'll pick them up.

### A warning that applies to all of the above

Whichever tool you use, the definitions are only found if ruby-build can actually see them:

- **`RUBY_BUILD_DEFINITIONS` must be an absolute path.** Build tools run from temporary
  working directories, so a relative path usually resolves to nowhere.
- **A wrong path fails silently.** ruby-build appends its own bundled definition directory
  to the search list and takes the first match, so a typo'd or unexpanded path doesn't
  error — it quietly builds the *upstream* definition instead, which is exactly the one
  that fails on a modern compiler. Confusing compiler errors are the usual symptom.
- **`"~/path/to/ruby-dev"` does not expand.** The tilde is literal inside double quotes.
  Use `"$HOME/path/to/ruby-dev"` or leave it unquoted.

If a build fails in a way that looks nothing like the notes in this repo, check that the
definition was actually picked up before debugging the compiler error.

### Testing

`test/build` builds definitions in throwaway Docker containers, so a clean-machine build
is checked without touching your own toolchain.

```bash
test/build arch 1.8.7-p374     # one version on one platform
test/build ubuntu-noble all    # every version on one platform
test/build all                 # everything
```

Builds run concurrently, so results stream in out of order and a sorted summary with any
failure logs is printed at the end. Tune the load with `JOBS` (containers at a time,
defaults to cores/4) and `MAKE_JOBS` (`make -j` inside each, defaults to 4):

```bash
JOBS=4 MAKE_JOBS=8 test/build all
```
