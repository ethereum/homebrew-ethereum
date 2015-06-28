require 'formula'

class Ethereum < Formula

  # official_version-protocol_version
  version '0.9.32-60'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 163
    root_url 'https://build.ethdev.com/builds/OSX%20Go%20master%20brew/163/bottle'
    sha1 'e7501a89567b05ac3a1c2af71d723545428a493f' => :yosemite
  end

  devel do
    bottle do
      revision 692
      root_url 'https://build.ethdev.com/builds/OSX%20Go%20develop%20brew/692/bottle'
      sha1 'd91e3afbbbc2451c17497de4794d92e4202c4c3c' => :yosemite
    end

    version '0.9.33-60'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build
  depends_on :hg
  depends_on 'readline'
  depends_on 'gmp'

  def install
    base = "src/github.com/ethereum/go-ethereum"

    ENV["GOPATH"] = "#{buildpath}/#{base}/Godeps/_workspace:#{buildpath}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"
    ENV["PATH"] = "#{ENV['GOPATH']}/bin:#{ENV['PATH']}"

    # Debug env
    system "go", "env"

    # Move checked out source to base
    mkdir_p base
    Dir["**"].reject{ |f| f['src']}.each do |filename|
      move filename, "#{base}/"
    end

    cmd = "#{base}/cmd/"

    system "go", "build", "-v", "./#{cmd}evm"
    system "go", "build", "-v", "./#{cmd}geth"
    system "go", "build", "-v", "./#{cmd}disasm"
    system "go", "build", "-v", "./#{cmd}rlpdump"
    system "go", "build", "-v", "./#{cmd}ethtest"
    system "go", "build", "-v", "./#{cmd}bootnode"

    bin.install 'evm'
    bin.install 'geth'
    bin.install 'disasm'
    bin.install 'rlpdump'
    bin.install 'ethtest'
    bin.install 'bootnode'
  end

  test do
    system "go", "test", "github.com/ethereum/go-ethereum/..."
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
