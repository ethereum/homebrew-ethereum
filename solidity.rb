#------------------------------------------------------------------------------
# solidity.rb
#
# Homebrew formula for solidity.  Homebrew (http://brew.sh/) is
# the de-facto standard package manager for OS X, and this Ruby script
# contains the metadata used to map command-line user settings used
# with the 'brew' command onto build options.
#
# Our documentation for the solidity Homebrew setup is at:
#
# http://solidity.readthedocs.io/en/latest/installing-solidity.html
#
# (c) 2014-2017 solidity contributors.
#------------------------------------------------------------------------------

class Solidity < Formula
  desc "The Solidity Contract-Oriented Programming Language"
  homepage "http://solidity.readthedocs.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.6.9/solidity_0.6.9.tar.gz"
  version "0.6.9"
  sha256 "e167f41a6e9ebab5c4677109b6e638e4c24a6f26a26ce8b0103e93f8b555bedc"

  depends_on "cmake" => :build
  depends_on "boost" => "c++11"
  # Note: due to a homebrew limitation, ccache will always be detected and cannot be turned off.
  depends_on "ccache" => :build
  depends_on "z3"

  def install
    system "cmake", ".", *std_cmake_args, "-DTESTS=OFF"
    system "make", "install"
  end

  test do
    system "#{bin}/solc", "--version"
  end
end
