## Old Rubies, meet new macOS

Trying to run an old, unsupported Ruby on an M1 Mac? You're in the right place.

This is a collection of ruby-build definitions for local dev on macOS. Not for production use. Homebrew is required.

Ruby versions:
* 1.8.7-p374


### How to install

Grab the build definition by cloning the repo or `curl`ing a specific file, then `rbenv install` the path to the definition.

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
