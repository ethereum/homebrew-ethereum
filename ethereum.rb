require 'formula'

class Ethereum < Formula
  version '1.2.3'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 2
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'a03cce1a86eccb5b7287534250879f4d49742ff01d3502282d633ca7d1fc716b' => :yosemite
    sha256 '33ad93513cb97869d5869dfe9345fa0b9a126ebb687b54c88ebee84f1d10327a' => :el_capitan
  end

  devel do
    bottle do
      revision 4
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '1487c1d716cc9f9953811ef534f144bb5872d39613bbeb8381742b414ca0cc5a' => :yosemite
      sha256 'dbc86937f0e288322cf2dcf0fde2f45e1394f310d4d0b2ac47e7cce8c28b6fd8' => :el_capitan
    end

    version '1.3.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build
  depends_on :hg
  depends_on 'readline'
  depends_on 'gmp'

  def install
    base = "src/github.com/ethereum/go-ethereum"

    ENV["GOPATH"] = "#{buildpath}/#{base}/Godeps/_workspace:#{buildpath}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    ENV["PATH"] = "#{ENV['GOPATH']}/bin:#{ENV['PATH']}"

    # Debug env
    system "go", "env"

    # Move checked out source to base
    mkdir_p base
    Dir["**"].reject{ |f| f['src']}.each do |filename|
      move filename, "#{base}/"
    end

    cmd = "#{base}/cmd/"

    system "go", "build", "-v", "./#{cmd}evm"
    system "go", "build", "-v", "./#{cmd}geth"
    system "go", "build", "-v", "./#{cmd}disasm"
    system "go", "build", "-v", "./#{cmd}rlpdump"
    system "go", "build", "-v", "./#{cmd}ethtest"
    system "go", "build", "-v", "./#{cmd}bootnode"

    bin.install 'evm'
    bin.install 'geth'
    bin.install 'disasm'
    bin.install 'rlpdump'
    bin.install 'ethtest'
    bin.install 'bootnode'
  end

  test do
    system "go", "test", "github.com/ethereum/go-ethereum/..."
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ThrottleInterval</key>
        <integer>300</integer>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/geth</string>
            <string>-datadir=#{prefix}/.ethereum</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
