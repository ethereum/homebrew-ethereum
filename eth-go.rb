require 'formula'

class EthGo < Formula

  # official_version-protocol_version
  version '0.6.8-34'

  homepage 'https://github.com/ethereum/eth-go'
  head 'https://github.com/ethereum/eth-go.git', :branch => 'develop'
  url 'https://github.com/ethereum/eth-go.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'pkg-config' => :build
  depends_on 'mercurial'
  depends_on 'gmp'
  depends_on 'readline'
  depends_on 'serpent-go'

  keg_only "No executable"

  def patches
    DATA
  end

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    ENV["QT5VERSION"] = `pkg-config --modversion Qt5Core`
    ENV["CGO_CPPFLAGS"] = "-I#{HOMEBREW_PREFIX}/opt/qt5/include/QtCore"
    ENV["GOPATH"] = "#{buildpath}:#{prefix}:#{HOMEBREW_PREFIX}/opt/serpent-go"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"

    mkdir_p "src/github.com/ethereum"
    ln_s buildpath, "src/github.com/ethereum/eth-go"

    mkdir_p "src/github.com/obscuren"
    ln_s "#{HOMEBREW_PREFIX}/opt/serpent-go", "src/github.com/obscuren/serpent-go"

    system "go", "get", "-d", "."

    system "go", "build", "-v", "."

    prefix.install Dir['*']
  end
end
__END__
