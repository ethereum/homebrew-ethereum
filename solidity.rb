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
  homepage "https://docs.soliditylang.org"
  url "https://github.com/ethereum/solidity/releases/download/v0.8.12/solidity_0.8.12.tar.gz"
  version "0.8.12"
  sha256 "95738a27909a13502385e9fe8f8f3d8a873d2faf5d06ff617bc2fe3edb8c4bf9"

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
