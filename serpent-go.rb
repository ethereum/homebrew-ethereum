require 'formula'

class SerpentGo < Formula

  version '0.5.14'

  homepage 'https://github.com/obscuren/serpent-go'
  url 'https://github.com/obscuren/serpent-go.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'mercurial'
  depends_on 'gmp'
  depends_on 'leveldb'
  depends_on 'readline'
  depends_on 'pkg-config'
  depends_on 'serpent'

  keg_only "No executable"

  def patches
    DATA
  end

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"

    ENV["GOPATH"] = "#{buildpath}:#{prefix}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"
    system "go", "get", "-d", "github.com/obscuren/serpent-go"
    system "cd src/github.com/obscuren/serpent-go && git submodule init && git submodule update"

    prefix.install Dir['*']
  end
end
__END__
