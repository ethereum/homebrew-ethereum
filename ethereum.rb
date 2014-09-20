require 'formula'

class Ethereum < Formula

  # official_version-protocol_version-database_version
  version '0.5.18-23'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop-poc-5'
  url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'

  devel do
    if build.include? "successful"
      version '0.6.8d-33-1'
      url 'https://github.com/ethereum/cpp-ethereum.git', :revision => 'a5196ed685e5ddadc6f8c0cda887c1e21885814e'
    else
    version '0.6.8d-33-1'
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
    end
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => ["c++11", "with-python"]
  # depends_on 'pkg-config' => :build
  depends_on 'qt5' unless build.include? 'headless'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'curl'
  depends_on 'jsonrpc' unless build.include? 'without-jsonrpc'

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
      prefix.install 'third/Third.app' if build.devel?
    end
  end

  test do
    system "eth"
  end

end
__END__
