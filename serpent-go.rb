require 'formula'

class SerpentGo < Formula

  # official_version-protocol_version
  version '0.6.8-34'

  homepage 'https://github.com/obscuren/serpent-go'
  url 'https://github.com/obscuren/serpent-go.git', :branch => 'master'

  depends_on 'go' => :build

  keg_only "No executable"

  def patches
    DATA
  end

  def install
    ENV["GOPATH"] = "#{buildpath}:#{prefix}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"

    prefix.install Dir['*']
  end
end
__END__
