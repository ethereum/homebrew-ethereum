require 'formula'

class GoEthereum < Formula

  # official_version-protocol_version
  version '0.7.3-37'

  homepage 'https://github.com/ethereum/go-ethereum'
  url 'https://github.com/ethereum/go-ethereum.git', :branch => 'master'
  devel do
    url 'https://github.com/ethereum/go-ethereum.git', :branch => 'develop'
  end

  depends_on 'go' => :build
  depends_on 'hg' => :build
  depends_on 'pkg-config' => :build
  depends_on 'qt5'

  option "headless", "Headless"

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    ENV["QT5VERSION"] = `pkg-config --modversion Qt5Core`
    ENV["CGO_CPPFLAGS"] = "-I#{HOMEBREW_PREFIX}/opt/qt5/include/QtCore"
    ENV["GOPATH"] = "#{buildpath}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    # Debug env
    system "go", "env"

    # tmp install ripemd160 for develop branch
    system "go", "get", "-v", "-u", "-d", "code.google.com/p/go.crypto/ripemd160" if build.devel?

    # Get dependencies
    system "go", "get", "-v", "-u", "-d", "github.com/ethereum/go-ethereum/ethereum"
    system "go", "get", "-v", "-u", "-d", "github.com/ethereum/go-ethereum/mist" unless build.include? "headless"

    # Link go-ethereum so we build from the proper branch
    system "rm", "-rf", "src/github.com/ethereum/go-ethereum"
    ohai "Linking . to src/github.com/ethereum/go-ethereum"
    ln_s "#{buildpath}", "src/github.com/ethereum/go-ethereum"

    system "go", "build", "-v", "./cmd/ethereum"
    system "go", "build", "-v", "./cmd/mist" unless build.include? "headless"

    bin.install 'ethereum'
    bin.install 'mist' unless build.include? "headless"

    system "mv", "cmd/mist/assets", prefix/"Resources"

    prefix.install Dir['src']
  end

  test do
    system "ethereum"
    system "mist" unless build.include? "headless"
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
            <string>#{opt_bin}/ethereum</string>
            <string>-datadir=#{prefix}/.ethereum</string>
            <string>-id=buildslave</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
      </dict>
    </plist>
    EOS
  end
end
__END__
