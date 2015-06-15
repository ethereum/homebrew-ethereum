require 'formula'

class Ethereum < Formula

  # official_version-protocol_version
  version '0.9.28-60'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'

  bottle do
    revision 159
    root_url 'https://build.ethdev.com/builds/OSX%20Go%20master%20brew/159/bottle'
    sha1 '892242227722936cb958c39521d42dcd919da522' => :yosemite
  end

  devel do
    bottle do
      revision 663
      root_url 'https://build.ethdev.com/builds/OSX%20Go%20develop%20brew/663/bottle'
      sha1 'dea956c8c63bd0398f568a0add5f2c10e29cacff' => :yosemite
    end

    version '0.9.29-60'
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build
  depends_on :hg
  depends_on 'pkg-config' => :build
  depends_on 'qt5' if build.with? 'gui'
  depends_on 'readline'
  depends_on 'gmp'

  option 'with-gui', "Build with GUI (Mist)"

  def install
    base = "src/github.com/ethereum/go-ethereum"

    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    ENV["QT5VERSION"] = `pkg-config --modversion Qt5Core`
    ENV["CGO_CPPFLAGS"] = "-I#{HOMEBREW_PREFIX}/opt/qt5/include/QtCore"
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
    system "go", "build", "-v", "./#{cmd}console" if build.devel?
    system "go", "build", "-v", "./#{cmd}rlpdump"
    system "go", "build", "-v", "./#{cmd}ethtest"
    system "go", "build", "-v", "./#{cmd}bootnode"
    system "go", "build", "-v", "./#{cmd}mist" if build.with? "gui"

    bin.install 'evm'
    bin.install 'geth'
    bin.install 'disasm'
    bin.install 'console'
    bin.install 'rlpdump'
    bin.install 'ethtest'
    bin.install 'bootnode'
    bin.install 'mist' if build.with? "gui"

    move "#{cmd}mist/assets", prefix/"Resources"
  end

  test do
    system "geth"
    system "mist" if build.with? "gui"
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
