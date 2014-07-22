require 'formula'

class Ethereum < Formula

  # official_version-protocol_version
  version '0.4.3-11'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'
  url 'https://github.com/ethereum/cpp-ethereum.git', :revision => '46a746a6d1f8f283a8eb433593bbac529b66b050'
  devel do
    version '0.5.16-23'
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => ["c++11", "with-python"]
  # depends_on 'pkg-config' => :build
  depends_on 'qt5' unless build.include? 'headless'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp' unless build.devel?
  depends_on 'curl'
  depends_on 'jsonrpc' unless build.include? 'without-jsonrpc'

  option 'headless', "Headless"
  option 'without-jsonrpc', "Build without JSON-RPC dependency"
  option "without-paranoia", "Build with -DPARANOIA=0"
  option 'with-debug', "Build with debug"
  option 'with-vmtrace', "Build with VMTRACE"

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
    args = *std_cmake_args, "-DLANGUAGES=0"

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

    if !build.include? "headless"
      prefix.install 'alethzero/AlethZero.app'
      prefix.install 'walleth/Walleth.app'
    end
  end

  test do
    system "eth"
  end

end
__END__
