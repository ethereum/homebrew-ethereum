require 'formula'

class CppEthereum < Formula
  # official_version-protocol_version-database_version
  version '1.0rc2'

  homepage 'https://github.com/ethereum/webthree-umbrella'
  url 'https://github.com/ethereum/webthree-umbrella.git', :branch => 'develop'

  bottle do
    revision 214
    root_url 'https://build.ethdev.com/cpp-binaries-data/brew_receipts'
    sha1 '03860dabca40711ae4d1506c5da661e8da758aef' => :yosemite
  end

  devel do
    bottle do
      revision 214
      root_url 'https://build.ethdev.com/cpp-binaries-data/brew_receipts'
      sha1 '03860dabca40711ae4d1506c5da661e8da758aef' => :yosemite
    end

    if build.include? "successful"
      version '1.0rc2'
      url 'https://github.com/ethereum/webthree-umbrella.git', :revision => '58d2a77e2ded71bc560ef88442f5686619806ecf'
    else
      version '1.0rc2'
      url 'https://github.com/ethereum/webthree-umbrella.git', :branch => 'develop'
    end
  end

  option "with-gui", "Build with GUI (AlethZero)"
  option "with-evmjit", "Build with LLVM and enable EVMJIT"
  option "without-v8-console", "Build without V8 JavaScript console"
  option "without-gpu-mining", "Build without OpenCL GPU mining (experimental)"
  option "with-debug", "Build with debug"
  option "with-vmtrace", "Build with VMTRACE"
  option "with-paranoia", "Build with -DPARANOID=1"
  option "successful", "Last successful build with --devel only"

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'qt5' => ["with-d-bus"] if build.with? 'gui'
  depends_on 'readline'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'curl'
  depends_on 'libjson-rpc-cpp'
  depends_on 'homebrew/versions/v8-315'

  def install
    args = *std_cmake_args

    opoo <<-EOS.undent
      EVMJIT needs the latest version of LLVM (3.7 or above), currently
      only available with --HEAD. If an older version was already installed
      or it did not install automatically, make sure to install it with
      `brew install llvm --HEAD --with-clang`
    EOS

    if build.with? "debug" or build.with? "vmtrace" or build.with? "paranoia"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=Release"
    end

    # Setting BUNDLE prevents overwriting any option...
    # args << "-DBUNDLE=release" if build.without? "vmtrace" and build.without? "paranoia"

    if build.with? "evmjit"
      args << "-DLLVM_DIR=/usr/local/opt/llvm/share/llvm/cmake"
      args << "-DEVMJIT=1"
      ENV["CXX"] = "/usr/local/opt/llvm/bin/clang++ -stdlib=libc++"
      ENV["CXXFLAGS"] = "#{ENV.cxxflags} -nostdinc++ -I/usr/local/opt/llvm/include/llvm"
      ENV["LDFLAGS"] = "#{ENV.ldflags} -L/usr/local/opt/llvm/lib"
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
    args << "-DJSCONSOLE=0" if build.without? "v8-console"
    args << "-DVMTRACE=1" if build.with? "vmtrace"
    args << "-DPARANOID=1" if build.with? "paranoia"

    system "cmake", *args
    system "make"
    system "make", "install"

    if build.with? "gui"
      prefix.install 'alethzero/alethzero/AlethZero.app'
      prefix.install 'alethzero/alethone/AlethOne.app'
      prefix.install 'mix/Mix.app'
    end
  end

  def caveats
    <<-EOS.undent
      EVMJIT needs the latest version of LLVM (3.7 or above), currently
      only available with --HEAD. If an older version was already installed
      or it did not install automatically, make sure to install it with
      `brew install llvm --HEAD --with-clang`
    EOS
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
