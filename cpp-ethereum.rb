#------------------------------------------------------------------------------
# cpp-ethereum.rb
#
# Homebrew formula for cpp-ethereum.  Homebrew (http://brew.sh/) is
# the de-facto standard package manager for OS X, and this Ruby script
# contains the metadata used to map command-line user settings used
# with the 'brew' command onto build options.
#
# Our docummentation for the cpp-ethereum Homebrew setup is at:
#
# http://www.ethdocs.org/en/latest/ethereum-clients/cpp-ethereum/installing-binaries/osx-homebrew.html
#
# (c) 2014-2016 cpp-ethereum contributors.
#------------------------------------------------------------------------------

require 'formula'

class CppEthereum < Formula
  version '1.2.4'

  homepage 'https://github.com/ethereum/webthree-umbrella'
  url 'https://github.com/ethereum/webthree-umbrella.git', :branch => 'develop'

  bottle do
    revision 390
    root_url 'https://build.ethereum.org/cpp-binaries-data/brew_receipts'
    sha1 '937a54aa5a085e9982d9319a439def127c2ecbd0' => :yosemite
    sha1 '5b96363b435314828ed0e255bed3837b29fabffe' => :el_capitan
  end

  devel do
    bottle do
      revision 390
      root_url 'https://build.ethereum.org/cpp-binaries-data/brew_receipts'
      sha1 '937a54aa5a085e9982d9319a439def127c2ecbd0' => :yosemite
      sha1 '5b96363b435314828ed0e255bed3837b29fabffe' => :el_capitan
    end

    if build.include? "successful"
      version '1.2.4'
      url 'https://github.com/ethereum/webthree-umbrella.git', :revision => 'a6662ceef1404f6468112c01deeb68d1446bb5f5'
    else
      version '1.2.4'
      url 'https://github.com/ethereum/webthree-umbrella.git', :branch => 'develop'
    end
  end

  option "with-gui", "Build with GUI (AlethZero)"
  option "without-evmjit", "Build without JIT (and its LLVM dependency)"
  option "with-debug", "Build with debug"
  option "with-vmtrace", "Build with VMTRACE"
  option "with-paranoia", "Build with -DPARANOID=1"
  option "successful", "Last successful build with --devel only"

  depends_on 'boost'
  depends_on 'cmake' => :build
  depends_on 'cryptopp'
  depends_on 'curl'
  depends_on 'gmp'
  depends_on 'leveldb'
  depends_on 'libjson-rpc-cpp'
  depends_on 'homebrew/versions/llvm38' if build.with? 'evmjit'
  depends_on 'miniupnpc'
  depends_on 'qt5' => ["with-d-bus"] if build.with? 'gui'

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

    if build.with? "gui"
      args << "-DFATDB=1" # https://github.com/ethereum/cpp-ethereum/issues/1403
      args << "-DGUI=1"
    else
      args << "-DGUI=0"
    end

    args << "-DVMTRACE=1" if build.with? "vmtrace"
    args << "-DPARANOID=1" if build.with? "paranoia"

    system "cmake", *args
    system "make"
    system "make", "install"

    if build.with? "gui"
      prefix.install 'alethzero/alethzero/AlethZero.app'
      prefix.install 'mix/Mix-ide.app'
    end
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/eth</string>
            <string>-d</string>
            <string>#{prefix}/.ethereum</string>
            <string>-b</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
