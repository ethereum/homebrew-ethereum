require 'formula'

class Mutan < Formula

  version '0.4'

  homepage 'https://github.com/obscuren/mutan'
  url 'https://github.com/obscuren/mutan.git', :branch => 'master'

  depends_on 'go' => :build

  def patches
    DATA
  end

  def install
    ENV["GOPATH"] = "#{buildpath}:#{prefix}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"
    system "go", "get", "-d", "."

    system "mv", "mutan", "src"

    system "rm", "-rf", "src/github.com/obscuren/mutan"
    ln_s buildpath, "src/github.com/obscuren/mutan"

    system "go", "build", "-v", "./src/mutan"

    bin.install "mutan"
    prefix.install Dir['*']
  end
end
__END__
