require 'formula'

class CppEthereum < Formula
  # official_version-protocol_version-database_version
  version '0.8.2-54-'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'poc-8'
  url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'

  bottle do
    revision 161
    root_url 'https://build.ethdev.com/builds/OSX%20C%2B%2B%20master%20brew/161/bottle'
    sha1 '859aa14607dec219b1d9f9094ff4fc377ce57384' => :yosemite
  end

  devel do
    bottle do
      revision 775
      root_url 'https://build.ethdev.com/builds/OSX%20C%2B%2B%20develop%20brew/775/bottle'
      sha1 '09622a260777e6e9039133dd1a1cc2a9a0c7f374' => :yosemite
    end

    if build.include? "successful"
      version '0.9.19-60-9'
      url 'https://github.com/ethereum/cpp-ethereum.git', :revision => 'c7b53adec03153f1559305c0e9399eb124482595'
    else
    version '0.9.19-60-9'
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
    end
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => "c++11"
  depends_on 'boost-python' => "c++11"
  depends_on 'llvm' => ["without-shared", "with-clang"] if build.include? "with-evmjit"
  # depends_on 'pkg-config' => :build
  depends_on 'qt5' if build.include? 'with-gui'
  depends_on 'readline'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'curl'
  depends_on 'libjson-rpc-cpp'
  depends_on 'v8-315' if build.include? 'with-v8-console'

  option "with-gui", "Build with GUI (AlethZero)"
  option "with-gpu-mining", "Build with OpenCL GPU mining (experimental)"
  option "with-evmjit", "Build with LLVM and enable EVMJIT"
  option "with-v8-console", "Build with V8 JavaScript console"
  option "without-paranoia", "Build with -DPARANOIA=0"
  option "with-debug", "Build with debug"
  option "with-vmtrace", "Build with VMTRACE"
  option "successful", "Last successful build with --devel only"

  def patches
    # Patches
    urls = [
      # ["with-option", "https://gist.githubusercontent.com/..."],
    ]

    p = []

    urls.each do |u|
      p << u[1] if build.include? u[0]
    end

    return p

    # Uncomment below and comment above to use a patch added after __END__
    # or add your patch to p[]
    # DATA
  end

  def install
    args = *std_cmake_args

    if build.with? "evmjit"
      args << "-DLLVM_DIR=/usr/local/opt/llvm/share/llvm/cmake"
      args << "-DEVMJIT=1"
      ENV["CXX"] = "/usr/local/opt/llvm/bin/clang++ -stdlib=libc++"
      ENV["CXXFLAGS"] = "#{ENV.cxxflags} -nostdinc++ -I/usr/local/opt/llvm/include/llvm"
      ENV["LDFLAGS"] = "#{ENV.ldflags} -L/usr/local/opt/llvm/lib"
    else
      ENV["CXX"] = "/usr/bin/clang++"
    end

    if build.include? "with-debug"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=Release"
    end

    args << "-DFATDB=1" # https://github.com/ethereum/cpp-ethereum/issues/1403
    args << "-DBUNDLE=default"
    args << "-DGUI=0" unless build.include? "with-gui"
    args << "-DETHASHCL=1" if build.include? "with-gpu-mining"
    args << "-DJSCONSOLE=1" if build.include? "with-v8-console"
    args << "-DVMTRACE=1" if build.include? "with-vmtrace"
    args << "-DPARANOIA=0" if build.include? "without-paranoia"
    args << "-DETHASHCL=1"

    system "cmake", *args
    system "make"
    system "make", "install"

    bin.install 'test/testeth'
    (prefix/"test").install Dir['test/*.json']

    if build.include? "with-gui"
      prefix.install 'alethzero/AlethZero.app'
      prefix.install 'mix/Mix.app' if build.devel?
      # prefix.install 'third/Third.app' if build.devel?
    end
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
__END__
