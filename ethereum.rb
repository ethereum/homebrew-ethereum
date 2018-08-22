#------------------------------------------------------------------------------
# ethereum.rb
#
# Homebrew formula for ethereum.  Homebrew (http://brew.sh/) is
# the de-facto standard package manager for OS X, and this Ruby script
# contains the metadata used to map command-line user settings used
# with the 'brew' command onto build options.
#
# Our documentation for the ethereum Homebrew setup is at:
#
# https://github.com/ethereum/go-ethereum/wiki/Installation-Instructions-for-Mac#installing-with-homebrew
#
# (c) 2014-2018 ethereum contributors.
#------------------------------------------------------------------------------


class Ethereum < Formula
  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :tag => 'v1.8.14'

  devel do
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'
  end

  # Require El Capitan at least
  depends_on :macos => :el_capitan

  # Is there a better way to ensure that frameworks (IOKit, CoreServices, etc) are installed?
  depends_on :xcode => :build

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
    bin.install 'build/bin/puppeth'
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/geth", "--version"
  end
end
