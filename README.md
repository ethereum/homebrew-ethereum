homebrew-ethereum
=================

Homebrew Tap for Ethereum

##Installation

```
brew tap caktux/ethereum
brew install ethereum
brew linkapps
```

Then `open /Applications/AlethZero.app` or run `eth -i` (interactive mode)

Get the latest with:
```
brew install ethereum --HEAD
```

Current branches:
* `--HEAD` is on [call](https://github.com/ethereum/cpp-ethereum/commits/call)
* `--devel` is on [develop](https://github.com/ethereum/cpp-ethereum/commits/develop)
* normal install uses a fixed commit

Update and upgrade:
```
brew update && brew upgrade
```

After minor updates, reinstall with:
```
brew update && brew reinstall ethereum
```

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

See `brew info ethereum` for all options.

Option           | desc.
-----------------|---------
`--headless`     | Headless
`--with-ncurses` | ncurses patch (merged in HEAD)
`--with-export`  | Dump to CSV, applies ncurses before
`--with-faucet`  | Faucet patch

##Troubleshooting

* Use `--verbose` to get more info while installing.
* Make sure to update XCode (latest is 5.1) and the command line tools.
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
