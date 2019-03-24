homebrew-ethereum
=================

Homebrew Tap for Ethereum

**Important note: reporting issues with any of these brews should be done at their respective repositories ([Go client](https://github.com/ethereum/go-ethereum) and [Solidity](https://github.com/ethereum/solidity)).**

## Installation

```
brew tap ethereum/ethereum
```

### Go client
```
brew install ethereum
```

### Solidity
```
brew install solidity
```

## Running

### Go client
`geth`

### Solidity
`solc`

## Development
Get the latest development version with the `--devel` flag.


### Go client
```
brew reinstall ethereum --devel
```


### Current branches

Go:
* `--devel` is on develop branch
* normal install is on master branch


## Upgrading

```
brew update && brew upgrade
```

## Minor updates

### Go client
```
brew update && brew reinstall ethereum
```


## Versions
List available versions with:
```
ls -l /usr/local/Cellar/ethereum
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

Note that the `ethereum` keg exists in [`homebrew-core`](https://github.com/Homebrew/homebrew-core/blob/master/Formula/ethereum.rb). It's not always up to date in `homebrew-core` and you might want to prioritise the version from this tap. To do this, you can pin this tap by running the following command:

```shell
brew tap-pin ethereum/ethereum
```

## Patching

First `cd /Library/Caches/Homebrew/ethereum--git/` and make your changes. Then `git diff > shiny.patch`, copy/paste the content of your patch under `__END__` of `ethereum.rb` and replace the `def patches` block with:

```
def patches
  DATA
end
```

If you want to submit your change, save your patch in a gist, add your `option 'shiny-option', 'Shiny description'` and the URL to your gist in the patches block and submit a pull request. Make sure to send a pull request to Ethereum also!
