require 'formula'

class CppEthereum < Formula
  # official_version-protocol_version-database_version
  version '0.9.39-61'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'

  bottle do
    revision 171
    root_url 'https://build.ethdev.com/builds/OSX%20C%2B%2B%20master%20brew/171/bottle'
    sha1 '802a19dfbd787c44ea6195d86c536dd527b89488' => :yosemite
  end

  devel do
    bottle do
      revision 1080
      root_url 'https://build.ethdev.com/builds/OSX%20C%2B%2B%20develop%20brew/1080/bottle'
      sha1 '736b0483cf13659a6b4ca5420da20c25650bfdcc' => :yosemite
    end

    if build.include? "successful"
      version '0.9.40-61'
      url 'https://github.com/ethereum/cpp-ethereum.git', :revision => '454753c7c0f1100a0b300d444f867eb03e8dae62'
    else
    version '0.9.40-61'
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
    end
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => "c++11"
  depends_on 'boost-python' => "c++11"
  depends_on 'qt5' if build.with? 'gui'
  depends_on 'readline'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'curl'
  depends_on 'libjson-rpc-cpp'
  depends_on 'homebrew/versions/v8-315'

  option "with-gui", "Build with GUI (AlethZero)"
  option "with-evmjit", "Build with LLVM and enable EVMJIT"
  option "without-v8-console", "Build without V8 JavaScript console"
  option "without-gpu-mining", "Build without OpenCL GPU mining (experimental)"
  option "with-debug", "Build with debug"
  option "with-vmtrace", "Build with VMTRACE"
  option "with-paranoia", "Build with -DPARANOID=1"
  option "successful", "Last successful build with --devel only"

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

    bin.install 'test/testeth'
    (prefix/"test").install Dir['test/*.json']

    if build.with? "gui"
      prefix.install 'alethzero/AlethZero.app'
      prefix.install 'mix/Mix.app' if build.devel?
      # prefix.install 'third/Third.app' if build.devel?
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

  test do
    system "testeth"
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
