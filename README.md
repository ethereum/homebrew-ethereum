homebrew-ethereum
=================

Homebrew Tap for Ethereum

**Important note: reporting issues with any of these brews should be done at their respective repositories ([C++ client](https://github.com/ethereum/cpp-ethereum) and [Solidity](https://github.com/ethereum/solidity)).**

## Installation

```
brew tap ethereum/ethereum
```

### C++ client
```
brew install cpp-ethereum
```

### Solidity
```
brew install solidity
```

## Running

### C++ client
`eth`

### Solidity
`solc`

## Development
Get the latest development version with the `--devel` flag. Use `--build-from-source` if you don't want a pre-built bottle. Alternatively you can use the `--successful` flag (cpp-ethereum only, see [important note below](#important-note-when-using---successful)) or any other [available options](#options).

### C++ client
```
brew reinstall cpp-ethereum --devel
```

For the latest successful build on develop (last successful build from [cpt-obvious](https://build.ethdev.com/waterfall)):
```
brew reinstall cpp-ethereum --devel --successful
```

#### Important note when using --successful

If you get an error looking like this:
```
==> Cloning https://github.com/ethereum/cpp-ethereum.git
Updating /Library/Caches/Homebrew/ethereum--git
fatal: reference is not a tree: <latest commit hash>
Error: Failed to download resource "ethereum"
Failure while executing: git checkout -q -f
```

Either try `brew fetch cpp-ethereum --devel` or simply delete the cache with `rm -rf /Library/Caches/Homebrew/cpp-ethereum--git`


### Current branches

C++:
* `--devel` is on [develop](https://github.com/ethereum/cpp-ethereum/commits/develop)
* normal install is on master branch


## Upgrading

```
brew update && brew upgrade
```

## Minor updates

### C++ client
```
brew update && brew reinstall cpp-ethereum
```


## Versions
List available versions with:
```
ls -l /usr/local/Cellar/ethereum
ls -l /usr/local/Cellar/cpp-ethereum
```

If you have other versions installed, you can switch with:
```
brew switch ethereum <version>
```
Or follow this [StackOverflow answer](http://stackoverflow.com/a/9832084/2639784)

These brews can be installed via the raw GitHub URLs, or by cloning this
repository locally with `brew tap ethereum/ethereum`. You can also install binary
bottles directly with `brew install <bottle_url>`, see [cpt-obvious](https://build.ethdev.com/waterfall)
for previous builds.


## Troubleshooting

* Use `--verbose` to get more info while installing.
* Make sure to update XCode and the command line tools.
* Run `brew update` and `brew upgrade`
* Fix what the `brew doctor` says.
* Reinstall dependencies: `brew reinstall boost --c++11 --with-python`
* Make changes to `/usr/local/Library/Taps/ethereum/homebrew-ethereum/ethereum.rb`
* Reinstall with `brew reinstall ethereum.rb` (send a pull request!)
* Take a walk


## Patching

First `cd /Library/Caches/Homebrew/ethereum--git/` and make your changes. Then `git diff > shiny.patch`, copy/paste the content of your patch under `__END__` of `ethereum.rb` and replace the `def patches` block with:

```
def patches
  DATA
end
```

If you want to submit your change, save your patch in a gist, add your `option 'shiny-option', 'Shiny description'` and the URL to your gist in the patches block and submit a pull request. Make sure to send a pull request to Ethereum also!
