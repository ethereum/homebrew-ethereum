require 'formula'

class Ethereum < Formula
  version '1.3.6'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 13
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '45ed53f55fcabe8fa6d215b456dd53c6f0d45a35ac27192efef4ba2c9a448700' => :yosemite
    sha256 'ffd38d656501b54fcc04251fd5f021d6707175ec66aaec9d6eebaa9be5225c72' => :el_capitan
  end

  devel do
    bottle do
      revision 179
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '9e2f56a9ef4b1bbbcf8513977c15592c8601d3713b7b9522d316125c18d12409' => :yosemite
      sha256 '089a21cb91ad2067dea8efe355b25c2e139dfeba231bbb7b66fea1cd7af7046b' => :el_capitan
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
