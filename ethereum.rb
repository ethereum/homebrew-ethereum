require 'formula'

class Ethereum < Formula
  version '1.4.4'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 17
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'e6a1d90cca7500ba75bd7902dbe11178eb97ff3998cfac814d8d67091ac1fdc0' => :yosemite
    sha256 '1e48f54a1de2da1c183ccc349401e17eb227c7692107a8582a932cdbcde6aec6' => :el_capitan
  end

  devel do
    bottle do
      revision 189
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '0808f9a419cf4d306e53e6a42f7f409af34275feaf53ae408260c86a7002c6b2' => :yosemite
      sha256 '9624953ce24e2b253472f338c70ea794d712f49bba8fe714937350e736761e71' => :el_capitan
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
