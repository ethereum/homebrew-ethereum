require 'formula'

class GoEthereum < Formula

  version '0.5.0-rc9'

  homepage 'https://github.com/ethereum/go-ethereum'
  head 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'pkg-config' => :build
  depends_on 'qt5'
  depends_on 'eth-go'

  option "headless", "Headless"

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    ENV["QT5VERSION"] = `pkg-config --modversion Qt5Core`
    ENV["CGO_CPPFLAGS"] = "-I#{HOMEBREW_PREFIX}/opt/qt5/include/QtCore"
    ENV["GOPATH"] = "#{HOMEBREW_PREFIX}/opt/eth-go:#{buildpath}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"

    system "go", "get", "-d", "./ethereum"
    system "go", "get", "-d", "./ethereal" unless build.include? "headless"

    # Go wants it in src folder
    system "mkdir src"
    system "mv ethereal src/"
    system "mv ethereum src/"

    system "go", "build", "-v", "./src/ethereum"
    system "go", "build", "-v", "./src/ethereal" unless build.include? "headless"

    bin.install 'ethereum'
    bin.install 'ethereal' unless build.include? "headless"
    prefix.install 'src/ethereal/assets' unless build.include? "headless"

    # prefix.install Dir['*']
  end

  test do
    system "ethereum"
    system "ethereal" unless build.include? "headless"
  end

end
