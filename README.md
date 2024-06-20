## Old Rubies, meet new macOS and Ubuntu

Trying to run an old, unsupported Ruby? You're in the right place.

This is a collection of ruby-build definitions for local dev on macOS and Ubuntu. Not for production use. macOS (and Homebrew) or Ubuntu are required.

### mise

```bash
git clone https://github.com/basecamp/ruby-dev

RUBY_BUILD_DEFINITIONS="~/path/to/ruby-dev" mise use ruby@1.8.7-p374
```

### rbenv

```bash
git clone https://github.com/basecamp/ruby-dev

RUBY_BUILD_DEFINITIONS="./ruby-dev" rbenv install 1.8.7-p374
```

or
```bash
git clone https://github.com/basecamp/ruby-dev
cd ruby-dev
rbenv install ./1.8.7-p374
```

or
```bash
curl -O https://raw.githubusercontent.com/basecamp/ruby-dev/main/1.8.7-p374
rbenv install ./1.8.7-p374
```

(Note the leading `./` - this is a path to a specific build definition for ruby-build, not a version specific for it to look for among its built-in definitions.)
