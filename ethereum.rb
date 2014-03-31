require 'formula'

class Ethereum < Formula

  # official_version-protocol_version-brew_version
  version '0.4.1-v10-brew-25'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'splitcode'
  url 'https://github.com/ethereum/cpp-ethereum.git', :revision => 'bb836d09895ff44d7fa1fc72e42a18e2eb3aa6a8'
  # url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'release-poc-3'

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

  option 'headless', "Headless"
  option 'with-ncurses', "ncurses patch (merged except with --devel)"
  option 'with-export', "Dump to CSV, ncurses patch required"
  option 'with-faucet', "Faucet patch"

  def patches
    inreplace 'libethereum/CMakeLists.txt' do |s|
      s.gsub! "install( TARGETS", "# install( TARGETS"
      # s.gsub! "replace", "with"
      # s.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
      # s.change_make_var! "CC", ENV.cc
    end
    inreplace 'eth/CMakeLists.txt' do |s|
      s.gsub! "install( TARGETS", "# install( TARGETS"
    end

    urls = [
      ["with-ncurses", "https://gist.githubusercontent.com/caktux/9377648/raw/a8d6bd800a34d48db2111ba683879888b7421f93/ethereum-cli-ncurses.patch"],
      ["with-export", "https://gist.githubusercontent.com/caktux/9615529/raw/de0c99d48dac683e5d1b8d3621db6499cd69b2ba/export-after-ncurses.patch"],
      ["with-faucet", "https://gist.githubusercontent.com/caktux/9335964/raw/a561f6c750c90b24d807048ef8c902afca18daef/faucet-develop.patch"],
    ]

    if !build.devel? and build.include? 'with-ncurses'
      urls.shift
      opoo "ncurses already merged, skipping patch"
    end

    p = []

    # Faucet patch for devel branch
    urls[2][1] = "https://gist.githubusercontent.com/caktux/9335964/raw/77033978f5fab8c7cab87135b29d1fdf095351db/faucet-develop.patch" if build.devel?

    # Apply pull request # 139 to fix send and transact in CLI client
    p << "https://github.com/ethereum/cpp-ethereum/pull/139.patch" if !build.head? and !build.devel?

    # Required ncurses patch on --devel using --with-export
    p << urls[0][1] if build.devel? and build.include? 'with-export' and !build.include? 'with-ncurses'

    urls.each do |u|
      p << u[1] if build.include? u[0]
    end

    return p

    # Uncomment below and comment above to use a patch added after __END__
    # or add your patch to p[]
    # DATA
  end

  def install
    args = [
      # "--prefix=#{prefix}",
      # "PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/opt/curl/lib/pkgconfig:#{HOMEBREW_PREFIX}/opt/ethereum/lib/pkgconfig"
      # "--enable-some-flag"
    ]

    # args << "--build-release" if build.include? '--build-release'

    if build.include? "with-ncurses"
      args << "-DCMAKE_BUILD_TYPE=ncurses"
    elsif build.include? "with-faucet"
      args << "-DCMAKE_BUILD_TYPE=faucet"
    elsif build.include? "HEAD"
      args << "-DCMAKE_BUILD_TYPE=call"
    elsif build.devel?
      args << "-DCMAKE_BUILD_TYPE=develop"
    else
      args << "-DCMAKE_BUILD_TYPE=brew"
    end

    if build.include? "headless"
      args << "-DHEADLESS=1"
    end

    system "cmake", *args
    system "make", "install"

    bin.install 'eth/eth'
    if !build.include? "headless"
      prefix.install 'alethzero/AlethZero.app'
    end
    lib.install Dir['libethereum/*.dylib']
    lib.install Dir['secp256k1/*.dylib']
    # prefix.install Dir['*']
  end

  test do
    system "eth"
  end

end
__END__
