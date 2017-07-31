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
# (c) 2014-2017 solidity contributors.
#------------------------------------------------------------------------------

require 'formula'

class Solidity < Formula

  desc "The Solidity Contract-Oriented Programming Language"
  homepage "http://solidity.readthedocs.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.4.13/solidity_0.4.13.tar.gz"
  version "0.4.13"
  sha256 "09a987a973ab8f614a836039c022125531475392bee510c4ca394deaea35f82a"

  "./solidity-0.4.13.sierra.bottle.1.tar.gz"
  bottle do
    cellar :any
    rebuild 1
    sha256 "8ae37c487a159886ad3f4fa411990a71d2649e6079ad59eba1ef3d716c83b476" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "ccache" => :build
  depends_on "boost"
  depends_on "cryptopp"
  depends_on "gmp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/solc", "--version"
  end
end
