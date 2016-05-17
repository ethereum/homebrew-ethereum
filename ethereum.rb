require 'formula'

class Ethereum < Formula
  version '1.4.4'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 18
    root_url 'https://build.ethdev.com/builds/bottles'
    sha256 'e6a1d90cca7500ba75bd7902dbe11178eb97ff3998cfac814d8d67091ac1fdc0' => :yosemite
    sha256 '8102a7fa719c670375737e77b2f07c49266f2e563e09652a3c1963acb7f1e33c' => :el_capitan
  end

  devel do
    bottle do
      revision 191
      root_url 'https://build.ethdev.com/builds/bottles-dev'
      sha256 'b0aeb92e2bf377e3713ac44b8b09640b32fd4fca0b21fb9fbf11883333254ddf' => :yosemite
      sha256 '139bc7135f815d7671df62e6607d7f41dce4e31203f02c2a1a5f4e2b6d748928' => :el_capitan
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
