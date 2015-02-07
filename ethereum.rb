require 'formula'

class Ethereum < Formula
  # official_version-protocol_version-database_version
  version '0.7.14-49-5'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'poc-7+'
  url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'

  bottle do
    revision 148
    root_url 'http://build.ethdev.com/builds/OSX%20C%2B%2B%20master%20brew/148/bottle'
    sha1 'b8a7588537742e7abe4c86fb8811724d96770be0' => :yosemite
  end

  devel do
    bottle do
      revision 268
      root_url 'http://build.ethdev.com/builds/OSX%20C%2B%2B%20develop%20brew/268/bottle'
      sha1 '98b95b9067ef2d374504b12939d2b87927249b8a' => :yosemite
    end

    if build.include? "successful"
      version '0.8.1-53-5'
      url 'https://github.com/ethereum/cpp-ethereum.git', :revision => '75c304190ba612b59014958ad0dedbcaeb29ce7a'
    else
    version '0.8.1-53-5'
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
    end
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => "c++11"
  depends_on 'boost-python' => "c++11"
  depends_on 'llvm35' => "disable-shared" if build.include? "with-evmjit"
  # depends_on 'pkg-config' => :build
  depends_on 'qt5' unless build.include? 'headless'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'curl'
  depends_on 'jsonrpc' unless build.include? 'without-jsonrpc' # or build.devel?
  # depends_on 'jsonrpc4' if !build.include? 'without-jsonrpc' and build.devel?
  # ^ Commented for future json-rpc-cpp upgrade

  option 'headless', "Headless"
  option "with-evmjit", "Build with LLVM-3.5 and enable EVMJIT"
  option 'without-jsonrpc', "Build without JSON-RPC dependency"
  option "without-paranoia", "Build with -DPARANOIA=0"
  option 'with-debug', "Build with debug"
  option 'with-vmtrace', "Build with VMTRACE"
  option 'successful', "Last successful build with --devel only"

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
      args << "-DLLVM_DIR=/usr/local/lib/llvm-3.5/share/llvm/cmake"
      args << "-DEVMJIT=1"
      ENV["CXX"] = "clang++-3.5 -stdlib=libc++"
      ENV["CXXFLAGS"] = "#{ENV.cxxflags} -nostdinc++ -I/usr/local/opt/llvm35/lib/llvm-3.5/include/c++/v1"
      ENV["LDFLAGS"] = "#{ENV.ldflags} -L/usr/local/opt/llvm35/lib/llvm-3.5/lib"
    else
      ENV["CXX"] = "/usr/bin/clang++"
    end

    if build.include? "with-debug" or build.include? "HEAD" or build.devel?
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=Release"
    end

    args << "-DHEADLESS=1" if build.include? "headless"
    args << "-DVMTRACE=1" if build.include? "with-vmtrace"
    args << "-DPARANOIA=0" if build.include? "without-paranoia"

    system "cmake", *args
    system "make"
    system "make", "install"

    bin.install 'test/testeth'
    (prefix/"test").install Dir['test/*.json']

    if !build.include? "headless"
      prefix.install 'alethzero/AlethZero.app'
      prefix.install 'mix/Mix.app' if build.devel?
      prefix.install 'third/Third.app' if build.devel?
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
            <string>-m</string>
            <string>off</string>
            <string>-c</string>
            <string>buildslave</string>
            <string>poc-7.ethdev.com</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
__END__
