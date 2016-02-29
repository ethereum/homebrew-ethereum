require 'formula'

class Ethereum < Formula
  version '1.3.4'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 10
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'c17a9ef86fcb818245561f9e033e6df2bd043ef9b7b3a626183f569a34c671fc' => :yosemite
    sha256 '36c2bc821f9ca1790b1111d4a1cd1262f4c5fe13effe82956512d47120cac71b' => :el_capitan
  end

  devel do
    bottle do
      revision 101
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'ea269f558c917de71cca9563a289f0e270fdd855e18957060b2a69e7cf86b9fb' => :yosemite
      sha256 '4c885873b621db9608a1a5fee7428567a13d66ab4095308a86a1d616a216501b' => :el_capitan
    end

    version '1.4.0'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build

  def install
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    system "go", "env" # Debug env
    system "make", "all"
    bin.install 'build/bin/evm'
    bin.install 'build/bin/geth'
    bin.install 'build/bin/rlpdump'
  end

  test do
    system "make", "test"
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
