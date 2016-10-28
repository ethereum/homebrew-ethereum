#------------------------------------------------------------------------------
# solidity.rb
#
# Homebrew formula for solidity.  Homebrew (http://brew.sh/) is
# the de-facto standard package manager for OS X, and this Ruby script
# contains the metadata used to map command-line user settings used
# with the 'brew' command onto build options.
#
# Our documentation for the lsoidity Homebrew setup is at:
#
# http://solidity.readthedocs.io/en/latest/installing-solidity.html
#
# (c) 2014-2016 solidity contributors.
#------------------------------------------------------------------------------

require 'formula'

class Solidity < Formula

  desc "The Solidity Contract-Oriented Programming Language"
  homepage "http://solidity.readthedocs.org"
  url "https://github.com/ethereum/solidity/archive/v0.4.3.tar.gz"
  version "0.4.3"
  sha256 "4d8437d183acec7b2a2ae46b3f20c372d4cb70ea13b515ea06089eff2391862f"

  depends_on "cmake" => :build
  depends_on "boost" => "c++11"
  depends_on "cryptopp"
  depends_on "gmp"
  depends_on "jsoncpp"

  def install
    system "/bin/echo '2353da71' > commit_hash.txt"
    touch "prerelease.txt"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/solc", "--version"
  end
end
