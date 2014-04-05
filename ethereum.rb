require 'formula'

class Ethereum < Formula

  # official_version-protocol_version-brew_version
  version '0.4.2-v11-brew-30'

  homepage 'https://github.com/ethereum/cpp-ethereum'
  head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
  url 'https://github.com/ethereum/cpp-ethereum.git', :revision => 'e7710d94bf7ff1603b554d80d0f66c2ea953a0e5'

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
  option 'with-forms', "ncurses forms"
  option 'with-export', "Dump to CSV"
  option 'with-faucet', "Faucet patch"

  def patches
    # Prevent default binary installation so we can link using brew
    inreplace 'libethereum/CMakeLists.txt' do |s|
      s.gsub! "install( TARGETS", "# install( TARGETS"
    end
    inreplace 'eth/CMakeLists.txt' do |s|
      s.gsub! "install( TARGETS", "# install( TARGETS"
    end

    # Patches
    urls = [
      ["with-forms", "https://gist.githubusercontent.com/caktux/aa6554f911f442f14faa/raw/cc279ea0ec0f46c1298883e26d2cbd8dae7bd460/holy-forms.patch"],
      ["with-export", "https://gist.githubusercontent.com/caktux/9615529/raw/de0c99d48dac683e5d1b8d3621db6499cd69b2ba/export-after-ncurses.patch"],
      ["with-faucet", "https://gist.githubusercontent.com/caktux/9335964/raw/216a5a7c7bd9df1525b3b48f319651804d2fb626/faucet-develop.patch"],
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
    args = [
      # "--prefix=#{prefix}",
      # "PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/opt/curl/lib/pkgconfig:#{HOMEBREW_PREFIX}/opt/ethereum/lib/pkgconfig"
      # "--enable-some-flag"
    ]

    # args << "--build-release" if build.include? '--build-release'

    if build.include? "with-forms"
      args << "-DCMAKE_BUILD_TYPE=forms"
    elsif build.include? "with-faucet"
      args << "-DCMAKE_BUILD_TYPE=faucet"
    elsif build.include? "HEAD"
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
