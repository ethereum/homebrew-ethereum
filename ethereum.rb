require 'formula'

class Ethereum < Formula

  # official_version-protocol_version-brew_version
  version '0.4.3-v11-brew-38'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'master'
  url 'https://github.com/ethereum/cpp-ethereum.git', :revision => '47572e8041da9360d7f7627196223afbfea9efe9'
  devel do
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => "--c++11"
  # depends_on 'pkg-config' => :build
  depends_on 'qt5' unless build.include? 'headless'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'ncurses'
  depends_on 'curl'
  depends_on 'jsonrpc' if build.include? 'with-jsonrpc'

  option 'headless', "Headless"
  option 'with-jsonrpc', "With JSON-RPC" if build.devel?
  option 'with-export', "Dump to CSV" unless build.devel?
  option 'with-faucet', "Faucet patch"

  def patches
    # Prevent default binary installation so we can link using brew
    inreplace 'libethereum/CMakeLists.txt' do |s|
      s.gsub! "install( TARGETS", "# install( TARGETS"
    end
    inreplace 'eth/CMakeLists.txt' do |s|
      s.gsub! "install( TARGETS", "# install( TARGETS"
    end
    if build.devel?
      inreplace 'libethcore/CMakeLists.txt' do |s|
        s.gsub! "install( TARGETS", "# install( TARGETS"
      end
      inreplace 'libethsupport/CMakeLists.txt' do |s|
        s.gsub! "install( TARGETS", "# install( TARGETS"
      end
      inreplace 'libevm/CMakeLists.txt' do |s|
        s.gsub! "install( TARGETS", "# install( TARGETS"
      end
      inreplace 'liblll/CMakeLists.txt' do |s|
        s.gsub! "install( TARGETS", "# install( TARGETS"
      end
      inreplace 'libqethereum/CMakeLists.txt' do |s|
        s.gsub! "fixup_bundle", "# fixup_bundle"
        s.gsub! "install( TARGETS", "# install( TARGETS"
      end
      inreplace 'neth/CMakeLists.txt' do |s|
        s.gsub! "install( TARGETS", "# install( TARGETS"
      end
    end

    # Patches
    urls = [
      ["with-export", "https://gist.githubusercontent.com/caktux/9615529/raw/de0c99d48dac683e5d1b8d3621db6499cd69b2ba/export-after-ncurses.patch"],
      ["with-faucet", "https://gist.githubusercontent.com/caktux/9335964/raw/216a5a7c7bd9df1525b3b48f319651804d2fb626/faucet-develop.patch"],
    ]

    # Faucet for neth in develop
    urls[1][1] = "https://gist.githubusercontent.com/caktux/11020803/raw/beb7b1b85a12675c46eb4ad965f97e8064a7c2be/faucet-neth.patch" if build.devel?

    p = []

    # Revert ncurses split and apply other fixes, see pull request for details
    # https://github.com/ethereum/cpp-ethereum/pull/157
    p << "https://github.com/caktux/cpp-ethereum/commit/85e642e9c6791215db54f6ba6a2e728a38ace389.patch" unless build.devel?
    # trim_all and cnote
    p << "https://github.com/caktux/cpp-ethereum/commit/ea34084720781dfbf49b5feba4db579c5d75a493.patch" unless build.devel?
    # parse data and fix inspect
    p << "https://github.com/caktux/cpp-ethereum/commit/b94dcbf57847ee63d1400c4884ad76e535617019.patch" unless build.devel?

    urls.each do |u|
      p << u[1] if build.include? u[0]
    end

    return p

    # Uncomment below and comment above to use a patch added after __END__
    # or add your patch to p[]
    # DATA
  end

  def install
    args = []

    if build.include? "with-faucet"
      args << "-DCMAKE_BUILD_TYPE=faucet"
    elsif build.devel?
      args << "-DCMAKE_BUILD_TYPE=Develop"
    elsif build.include? "HEAD"
      args << "-DCMAKE_BUILD_TYPE=Debug"
    else
      args << "-DCMAKE_BUILD_TYPE=brew"
    end

    if build.include? "headless"
      args << "-DHEADLESS=1"
    end

    system "cmake", *args
    system "make", "install"

    bin.install 'eth/eth'
    bin.install 'neth/neth' if build.devel?
    bin.install 'lllc/lllc' if build.devel?
    if !build.include? "headless"
      prefix.install 'alethzero/AlethZero.app'
      prefix.install 'walleth/Walleth.app'
    end
    lib.install Dir['libethcore/*.dylib'] if build.devel?
    lib.install Dir['libethsupport/*.dylib'] if build.devel?
    lib.install Dir['libevm/*.dylib'] if build.devel?
    lib.install Dir['liblll/*.dylib'] if build.devel?
    lib.install Dir['libethereum/*.dylib']
    lib.install Dir['libqethereum/*.dylib'] if build.devel?
    lib.install Dir['secp256k1/*.dylib']
    # prefix.install Dir['*']
  end

  test do
    system "eth"
  end

end
__END__
