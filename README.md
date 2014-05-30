homebrew-ethereum
=================

Homebrew Tap for Ethereum

## Installation

```
brew tap caktux/ethereum
```

### C++ client
```
brew install ethereum
brew linkapps
```

### Go client
```
brew install go-ethereum
```

## Running

### C++ client
`open /Applications/AlethZero.app`, `eth` (CLI), or `neth` (ncurses interface)

### Go client
`ethereal` (GUI) or `ethereum` (CLI)


## Development
Get the latest version with:
```
brew install ethereum --devel
```

Current branches (C++):
* `--HEAD` is on latest release branch
* `--devel` is on [develop](https://github.com/ethereum/cpp-ethereum/commits/develop)
* normal install uses a fixed commit on latest release branch

Go:
* `--HEAD` is on develop branch
* normal install is on master branch


## Upgrading

```
brew update && brew upgrade
```

## Minor updates

### C++ client
```
brew update && brew reinstall ethereum
```

### Go client
```
brew update && brew reinstall eth-go go-ethereum
```

## Versions
List available versions with:
```
brew versions ethereum
```

If you have other versions installed, you can switch with:
```
brew switch ethereum <version>
```
Or follow this [StackOverflow answer](http://stackoverflow.com/a/9832084/2639784)

These brews can be installed via the raw GitHub URLs, or by cloning this
repository locally with `brew tap caktux/ethereum`.

##Options

See `brew info ethereum` or `brew info go-ethereum` for all options. `--with-...` features are experimental patches.

Option           | desc.
-----------------|---------
`--headless`     | Headless
`--with-export`  | Dump to CSV, applies ncurses before
`--with-faucet`  | Faucet patch

##Troubleshooting

* Use `--verbose` to get more info while installing.
* Make sure to update XCode and the command line tools.
* Run `brew update` and `brew upgrade`
* Fix what the `brew doctor` says.
* Reinstall dependencies: `brew reinstall boost --c++11`
* Make changes to `/usr/local/Library/Taps/caktux-ethereum/ethereum.rb`
* Reinstall with `brew reinstall ethereum.rb` (send a pull request!)
* Take a walk

##Patching

First `cd /Library/Caches/Homebrew/ethereum--git/` and make your changes. Then `git diff > shiny.patch`, copy/paste the content of your patch under `__END__` of `ethereum.rb` and replace the `def patches` block with:

```
def patches
  DATA
end
```

If you want to submit your change, save your patch in a gist, add your `option 'shiny-option', 'Shiny description'` and the URL to your gist in the patches block and submit a pull request. Make sure to send a pull request to Ethereum also!
