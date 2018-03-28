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
  url "https://github.com/ethereum/solidity/releases/download/v0.4.21/solidity_0.4.21.tar.gz"
  version "0.4.21"
  sha256 "ffbf167a668b884670dd54cd1520d460f39ab4c857f91e25f90d25c19a0807b0"

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
