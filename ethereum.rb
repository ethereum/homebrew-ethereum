require 'formula'

class Ethereum < Formula
  version '1.3.5'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 12
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 '0d5a8107b792921465b5ac774f1ecb2a23c0a09e10114ecd8a736de0b423c26a' => :yosemite
    sha256 '53c9f65c0e4fee1d4d6d65df0eaff725a91c5f7dfb006c1f3cc3250679ec0f58' => :el_capitan
  end

  devel do
    bottle do
      revision 131
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '337ede529a79f6488fe843640de21fcba85bf40a38e111c9315a36ddc3973413' => :yosemite
      sha256 '1265049133e3a49a3b4a3af4f44725a36b5916577a3fd412e75f97d3c7556d79' => :el_capitan
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
