#------------------------------------------------------------------------------
# cpp-ethereum.rb
#
# Homebrew formula for cpp-ethereum.  Homebrew (http://brew.sh/) is
# the de-facto standard package manager for OS X, and this Ruby script
# contains the metadata used to map command-line user settings used
# with the 'brew' command onto build options.
#
# Our documentation for the cpp-ethereum Homebrew setup is at:
#
# http://cpp-ethereum.org/installing-binaries/osx-homebrew.html
#
# (c) 2014-2018 cpp-ethereum contributors.
#------------------------------------------------------------------------------

class CppEthereum < Formula
  desc "Ethereum C++ client"
  homepage "http://cpp-ethereum.org"
  version "1.5.3"

  url "https://github.com/ethereum/aleth.git"

  opoo "Aleth (formerly cpp-ethereum) has been removed from Homebrew. Please install binary releases from https://github.com/ethereum/aleth/releases."
end
