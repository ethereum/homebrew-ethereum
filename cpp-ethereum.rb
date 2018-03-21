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

  option "without-evmjit", "Build without JIT (and its LLVM dependency)"
  option "with-debug", "Build with debug"
  option "with-vmtrace", "Build with VMTRACE"
  option "successful", "Last successful build with --devel only"

  depends_on "cmake" => :build
  depends_on "leveldb"

  def install
    args = *std_cmake_args

    if build.with? "debug" or build.with? "vmtrace" or build.with? "paranoia"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=Release"
    end

    if build.without? "evmjit"
      args << "-DEVMJIT=0"
    else
      args << "-DEVMJIT=1"
    end

    args << "-DVMTRACE=1" if build.with? "vmtrace"

    system "cmake", *args
    system "make"
    system "make", "install"

  end
end
