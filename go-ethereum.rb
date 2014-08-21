require 'formula'

class GoEthereum < Formula

  # official_version-protocol_version
  version '0.6.3-27'

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
    ENV["GOPATH"] = "#{buildpath}:#{prefix}:#{HOMEBREW_PREFIX}/opt/eth-go"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    # Debug env
    system "go", "env"

    # Link eth-go and current buildpath
    # otherwise we get from master branch no matter what
    mkdir_p "src/github.com/ethereum"
    ln_s "#{HOMEBREW_PREFIX}/opt/eth-go", "src/github.com/ethereum/eth-go"
    ln_s buildpath, "src/github.com/ethereum/go-ethereum"

    # Get dependencies
    system "go", "get", "-d", "./ethereum"
    system "go", "get", "-d", "./ethereal" unless build.include? "headless"

    # Move to src folder to leave room for binaries
    system "mv", "ethereal", "src/"
    system "mv", "ethereum", "src/"
    system "mv", "utils", "src/"
    system "mv", "javascript", "src/" if Dir.exists?("javascript")

    # Link go-ethereum so we build from the proper branch
    system "rm", "-rf", "src/github.com/ethereum/go-ethereum"
    ohai "Linking src to src/github.com/ethereum/go-ethereum"
    ln_s "#{buildpath}/src", "src/github.com/ethereum/go-ethereum"

    system "go", "build", "-v", "./src/ethereum"
    system "go", "build", "-v", "./src/ethereal" unless build.include? "headless"

    bin.install 'ethereum'
    bin.install 'ethereal' unless build.include? "headless"

    system "mv", "src/ethereal/assets", prefix/"Resources"

    # Copy mnemonic.words.lst from eth-go to Resources
    words = "#{HOMEBREW_PREFIX}/opt/eth-go/ethcrypto/mnemonic.words.lst"
    system "cp", words, prefix/"Resources" if File.exists?(words)

    prefix.install Dir['src']
  end

  test do
    system "ethereum"
    system "ethereal" unless build.include? "headless"
  end

end
__END__
