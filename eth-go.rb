require 'formula'

class EthGo < Formula

  version '0.5.22'

  homepage 'https://github.com/ethereum/eth-go'
  head 'https://github.com/ethereum/eth-go.git', :branch => 'develop'
  url 'https://github.com/ethereum/eth-go.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'mercurial'
  depends_on 'gmp'
  depends_on 'readline'

  keg_only "No executable"

  def patches
    DATA
  end

  def install
    ENV["GOPATH"] = "#{buildpath}:#{prefix}:#{HOMEBREW_PREFIX}/opt/serpent-go"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"
    system "go", "get", "-d", "."

    system "rm", "-rf", "src/github.com/ethereum/eth-go"
    ln_s buildpath, "src/github.com/ethereum/eth-go"

    system "go", "build", "-v", "."

    prefix.install Dir['*']
  end
end
__END__
