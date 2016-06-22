require 'formula'

class Ethereum < Formula
  version '1.4.7'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 22
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '96ab3f91242a00b20ac2e80e4316518267f419da40a9478a7452d65327d92cd3' => :yosemite
    sha256 '6c523a9a58c007a014391cbfa16a3b41fc200d738250c99d5a1b15466389a7ee' => :el_capitan
  end

  devel do
    bottle do
      revision 221
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'ff831010f0935873bb5679312e3e58da8b4dab0cf7a593298456c3671788ccb4' => :yosemite
      sha256 '7e3c2078acff981410f27f240a3a73c86ccfa97540506d04407325c03f142cdd' => :el_capitan
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
