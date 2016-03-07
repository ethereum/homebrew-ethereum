require 'formula'

class Ethereum < Formula
  version '1.3.5'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 11
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'cea14737a89b7b21dc62e76728c62e181557b03e9962746b62d8aa3985a1c8fd' => :yosemite
    sha256 'f9f9a2fad1b1cb0b010d81958542158f11804a3a763eef0239cafb2d8ad48abd' => :el_capitan
  end

  devel do
    bottle do
      revision 108
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '24629898f5e1da2cd06d1d62e701740327be50f7e152e1263c05165580967967' => :yosemite
      sha256 '06d8242c20a1f6ea9a66339ca7995994349788a444dd30d1cba429f70dc1bf8c' => :el_capitan
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
