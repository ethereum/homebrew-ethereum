homebrew-ethereum
=================

Homebrew Tap for Ethereum

##Installation

```
brew tap caktux/ethereum
brew install ethereum
brew linkapps
```

Then `open /Applications/AlethZero.app` or run `eth` (with `-i` for interactive mode)

Get the latest with:
```
brew install ethereum --HEAD
```

These brews can be installed via the raw GitHub URLs, or by cloning this
repository locally with `brew tap caktux/ethereum`.

##Options

See `brew info ethereum` for all options.

Option           | desc.
-----------------|---------
`--headless`     | Headless
`--with-ncurses` | Try the ncurses patch
`--with-faucet`  | Try the faucet patch


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
