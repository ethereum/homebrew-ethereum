require 'formula'

class Ethereum < Formula
  version '1.4.6'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 21
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '1dd89c240fca0635dcfffd6ba338d3366a17974e094183a24bb2147879acdf9e' => :yosemite
    sha256 'f4c3cd032ee51158f74d90de73dd335e5c16021eba1c01581c7020a28e2fbd44' => :el_capitan
  end

  devel do
    bottle do
      revision 212
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'eb826ddeb14acb4a2182587b4f312e262b06011887141959719f6beb72f88ee6' => :yosemite
      sha256 'cc7165f8b4aed71eebf6ee27a6536783482bc2efca0b1e24dd6fe0458e96a8af' => :el_capitan
    end

    version '1.5.0'
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
