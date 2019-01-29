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

  url "https://github.com/ethereum/aleth.git", :tag => "v1.5.2"
  version "1.5.2"

  devel do
    url "https://github.com/ethereum/aleth.git", :branch => "master"
    version "development"
  end

  depends_on "cmake" => :build
  depends_on "leveldb"

  def install
    system "cmake", ".", *std_cmake_args, "-DVMTRACE=ON"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/aleth", "--version"
  end
end
