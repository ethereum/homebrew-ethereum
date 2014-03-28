require 'formula'

class Ethereum < Formula

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'call'
  url 'https://github.com/ethereum/cpp-ethereum.git', :revision => 'be1923212bea42f3f5450e98f1c6798b8ea8a6aa'
  # url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'release-poc-3'
  version '0.4.0-v9-brew-22' # official_version-protocol_version-brew_version
  devel do
    url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
  end

  depends_on 'cmake' => :build
  depends_on 'boost' => "--c++11"
  # depends_on 'pkg-config' => :build
  depends_on 'qt5' unless build.without? 'gui'
  depends_on 'cryptopp'
  depends_on 'miniupnpc'
  depends_on 'leveldb'
  depends_on 'gmp'
  depends_on 'ncurses' => :optional

  option 'headless', "Headless, install command line interface only, no GUI app"
  option 'without-gui', "synonym for headless"
  option 'with-ncurses', "ncurses patch (merged in HEAD)"
  option 'with-export', "Dump to CSV, ncurses patch required"
  option 'with-faucet', "Faucet patch"

  def headless
    build.include? "headless" || build.without?("gui")
  end

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
      ["with-export", "https://gist.githubusercontent.com/caktux/9615529/raw/68a2f44953a1773db09af1cd20d0fd6788298bae/export-after-ncurses.patch"],
      ["with-faucet", "https://gist.githubusercontent.com/caktux/9335964/raw/4591ad61cc43888b0be7a49eec8f987bc30c010b/faucet-develop.patch"],
    ]

    if !build.devel? and build.include? 'with-ncurses'
      urls.shift
      opoo "ncurses already merged, skipping patch"
    end

    p = []
    p[0] = "https://gist.githubusercontent.com/caktux/956c9bb6fb6728ebd810/raw/eed5c6663cfb639ef33f4ce6a75c8cb1786e0f57/un-g_logPost.patch"
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

    args << "-DHEADLESS=1" if headless

    system "cmake", *args
    system "make", "install"

    bin.install 'eth/eth'
    prefix.install 'alethzero/AlethZero.app' unless headless
    lib.install Dir['libethereum/*.dylib']
    lib.install Dir['secp256k1/*.dylib']
    # prefix.install Dir['*']
  end

  test do
    system "eth"
  end

end
__END__
