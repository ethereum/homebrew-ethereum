require 'formula'

class CppEthereum < Formula
  # official_version-protocol_version-database_version
  version '1.2.3'

  homepage 'https://github.com/ethereum/webthree-umbrella'
  url 'https://github.com/ethereum/webthree-umbrella.git', :branch => 'develop'

  bottle do
    revision 306
    root_url 'https://build.ethereum.org/cpp-binaries-data/brew_receipts'
    sha1 'be4204a96842e2e2f356938c02dabc16c1adf188' => :yosemite
  end

  devel do
    bottle do
      revision 306
      root_url 'https://build.ethereum.org/cpp-binaries-data/brew_receipts'
      sha1 'be4204a96842e2e2f356938c02dabc16c1adf188' => :yosemite
    end

    if build.include? "successful"
      version '1.2.3'
      url 'https://github.com/ethereum/webthree-umbrella.git', :revision => '7e7480fcd5c2cdcde4c6d33a629ffc2564d4d096'
    else
      version '1.2.3'
      url 'https://github.com/ethereum/webthree-umbrella.git', :branch => 'develop'
    end
  end

  option "with-gui", "Build with GUI (AlethZero)"
  option "with-evmjit", "Build with LLVM and enable EVMJIT"
  option "without-gpu-mining", "Build without OpenCL GPU mining (experimental)"
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
  depends_on 'llvm37' if build.with? 'evmjit'
  depends_on 'miniupnpc'
  depends_on 'qt5' => ["with-d-bus"] if build.with? 'gui'

  def install
    args = *std_cmake_args

    if build.with? "debug" or build.with? "vmtrace" or build.with? "paranoia"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=Release"
    end

    if build.with? "evmjit"
      args << "-DEVMJIT=1"
    else
      args << "-DEVMJIT=0"
    end

    if build.with? "gui"
      args << "-DFATDB=1" # https://github.com/ethereum/cpp-ethereum/issues/1403
      args << "-DGUI=1"
    else
      args << "-DGUI=0"
    end

    args << "-DETHASHCL=0" if build.without? "gpu-mining"
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
