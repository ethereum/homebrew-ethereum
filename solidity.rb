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
  url "https://github.com/ethereum/solidity/archive/v0.3.6.tar.gz"
  version "0.3.6"
  sha256 "1947ce012ca540dc75495ebbb09b3b9ad1d48ffc076a51c7b2f18ca9870b5822"

  depends_on "cmake" => :build
  depends_on "boost" => "c++11"
  depends_on "cryptopp"
  depends_on "gmp"
  depends_on "jsoncpp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

end