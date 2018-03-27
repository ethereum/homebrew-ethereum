class Ethereum < Formula
  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :tag => 'v1.8.4'

  devel do
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'
  end

  # Require El Capitan at least
  depends_on :macos => :el_capitan

  # Is there a better way to ensure that frameworks (IOKit, CoreServices, etc) are installed?
  depends_on :xcode => :build

  option "with-swarm", "Install swarm"

  # TODO: could use `conflicts_with "swarm", :because => ".."` if there would be a package for it?

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install "build/bin/abigen"
    bin.install "build/bin/evm"
    bin.install "build/bin/geth"
    bin.install "build/bin/rlpdump"
    bin.install "build/bin/puppeth"
    if build.with? "swarm"
      bin.install "build/bin/swarm"
    end
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/geth", "--version"
  end
end
