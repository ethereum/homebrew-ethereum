require 'formula'

class Ethereum < Formula

  # official_version-protocol_version-database_version
  version '0.7.14-49-5'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'poc-7+'
  url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'

  bottle do
    revision 141
    root_url 'http://build.ethdev.com/builds/OSX%20C%2B%2B%20master%20brew/141/bottle'
    sha1 '10cc40894c838b1bc067c3e5add132cb8039c1f3' => :yosemite
  end

  devel do
    bottle do
      revision 160
      root_url 'http://build.ethdev.com/builds/OSX%20C%2B%2B%20develop%20brew/160/bottle'
      sha1 '3b55dd843087f881b864dab1c217937da883a8bf' => :yosemite
    end

    if build.include? "successful"
      version '0.8.0-51-5'
      url 'https://github.com/ethereum/cpp-ethereum.git', :revision => 'f7e7182c158b2f23d1c21279abfd5729603154fa'
    else
    version '0.8.0-51-5'
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
    end
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => "c++11"
  depends_on 'boost-python' => "c++11"
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
    args << "-DLANGUAGES=0"

    if build.include? "with-debug"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    elsif build.devel?
      args << "-DCMAKE_BUILD_TYPE=Develop"
    elsif build.include? "HEAD"
      args << "-DCMAKE_BUILD_TYPE=Release"
    else
      args << "-DCMAKE_BUILD_TYPE=brew"
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
