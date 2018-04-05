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
# (c) 2014-2017 cpp-ethereum contributors.
#------------------------------------------------------------------------------

class CppEthereum < Formula
  desc "Ethereum C++ client"
  homepage "http://cpp-ethereum.org"
  url "https://github.com/ethereum/cpp-ethereum.git", :branch => "develop"
  version "1.3.0-develop"

  depends_on "cmake" => :build
  depends_on "leveldb"

  def install
    system "cmake", ".", *std_cmake_args, "-DVMTRACE=ON"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eth", "--version"
  end
end
