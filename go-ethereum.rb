require 'formula'

class GoEthereum < Formula

  version '0.5.0-rc11'

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
    ENV["GOPATH"] = "#{buildpath}:#{HOMEBREW_PREFIX}/opt/eth-go:#{prefix}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    # Debug env
    system "go", "env"

    # Get dependencies
    system "go", "get", "-d", "./ethereum"
    system "go", "get", "-d", "./ethereal" unless build.include? "headless"

    # Go wants us in src folder
    system "mv", "ethereal", "src/"
    system "mv", "ethereum", "src/"
    system "mv", "utils", "src/"

    # Replace ourselves with ourselves from "go get",
    # otherwise we build from master branch no matter what
    system "rm", "-rf", "src/github.com/ethereum/eth-go"
    system "rm", "-rf", "src/github.com/ethereum/go-ethereum"
    ln_s "#{HOMEBREW_PREFIX}/opt/eth-go", "src/github.com/ethereum/eth-go"
    ln_s "#{buildpath}/src", "src/github.com/ethereum/go-ethereum"

    system "go", "build", "-v", "./src/ethereum"
    system "go", "build", "-v", "./src/ethereal" unless build.include? "headless"

    bin.install 'ethereum'
    bin.install 'ethereal' unless build.include? "headless"

    prefix.install Dir['src']
  end

  test do
    system "ethereum"
    system "ethereal" unless build.include? "headless"
  end

end
__END__
