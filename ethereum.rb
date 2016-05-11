require 'formula'

class Ethereum < Formula
  version '1.4.3'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 16
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'f8d42484b2d09885ce9b5a7155385b7d6bfb49604508c851e3d96853ac7d68d1' => :yosemite
    sha256 '7c83599b03dcf3350957ab6f49ae7b9e69c9413ecbd2b37a919cc27c5b95d8f2' => :el_capitan
  end

  devel do
    bottle do
      revision 184
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 '95b370a601861a39ecf513f5d4e2f72f67adba8b14705cb8084f56367bd00613' => :yosemite
      sha256 '223fedf866f7ab6b0423d6daecee5c95bbefe7fdd63ec7219064faeecf39f811' => :el_capitan
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
