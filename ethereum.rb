require 'formula'

class Ethereum < Formula
  version '1.3.2'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 8
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'b960d89bc5561fcf44dca68430cdab96bca6e1787c09b923e1ed52226a171540' => :yosemite
    sha256 '042c838a60f38e23d3efaf09db65b802f7099c0ffd213b82ad9fe58ccb1e49bb' => :el_capitan
  end

  devel do
    bottle do
      revision 51
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'e257bbdd6ce66e0132203d27c36e0df698cee55155721c3647f813143b20d44e' => :yosemite
      sha256 '9b698dbd853a7146c99273d900f8f0fe99d46f7e3b412c52e817500f72b48cd4' => :el_capitan
    end

    version '1.4.0'
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
