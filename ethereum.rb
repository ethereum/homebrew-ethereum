class Ethereum < Formula
  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :tag => 'v1.8.4'

  devel do
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
    bin.install 'build/bin/puppeth'
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/geth", "--version"
  end
end
