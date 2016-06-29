require 'formula'

class Ethereum < Formula
  version '1.4.8'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 23
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '53e81be07fd86d6d22640599f47e0f764daf68bfb7ab9e8fa4932a5395745400' => :yosemite
    sha256 'd0fa28db5fc397ccd0fb83983e5d57bec2247737c3055e2887eee7076c7b37c4' => :el_capitan
  end

  devel do
    bottle do
      revision 225
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '92fb41a3011a78b01c486863185dab847e3013e02cef806a34227d2298a02cc4' => :yosemite
      sha256 'ad9e29ef65c35a5beed37998b509391601abc6aa6e11778baebb2d678dc64728' => :el_capitan
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
