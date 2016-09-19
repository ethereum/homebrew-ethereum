require 'formula'

class Ethereum < Formula
  version '1.4.12'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 25
    root_url 'https://builds.ethereum.org/builds/bottles'
    sha256 '0196f2f717e353e1a9d76add03f2af05bb840abd8bc0a097f596db86b20aa7b4' => :yosemite
    sha256 '7056d2679661b83f6209d61c55aa30b98046120b92d6eee5d5bbb81aca15d934' => :el_capitan
  end

  devel do
    bottle do
      revision 239
      root_url 'https://builds.ethereum.org/builds/bottles-dev'
      sha256 'fee2228f931dfcc3ecfef49fa64d13ae258558ecf9cffa94bad9dce65fa9fa1d' => :yosemite
      sha256 '841ef222439404b526c7aa6585c10ea3885e5109f55359364ae135a227f917f7' => :el_capitan
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
