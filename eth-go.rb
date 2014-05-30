require 'formula'

class EthGo < Formula

  version '0.5.0-rc11'

  homepage 'https://github.com/ethereum/eth-go'
  head 'https://github.com/ethereum/eth-go.git', :branch => 'develop'
  url 'https://github.com/ethereum/eth-go.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'mercurial'
  depends_on 'gmp'
  depends_on 'leveldb'
  depends_on 'pkg-config'

  keg_only "No executable"

  def patches
    DATA
  end

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"

    ENV["GOPATH"] = "#{buildpath}:#{prefix}"
    ENV["GOROOT"] = "#{HOMEBREW_PREFIX}/opt/go/libexec"

    system "go", "env"
    system "go", "get", "-d", "."

    system "rm", "-rf", "src/github.com/ethereum/eth-go"
    ln_s buildpath, "src/github.com/ethereum/eth-go"

    system "go", "build", "-v", "."

    prefix.install Dir['*']
  end
end
__END__
diff --git a/ethutil/config.go b/ethutil/config.go
index 916b0d1..ec41b7b 100644
--- a/ethutil/config.go
+++ b/ethutil/config.go
@@ -55,7 +55,7 @@ func ApplicationFolder(base string) string {
			if err != nil {
				fmt.Println(err)
			} else {
-				assetPath := path.Join(os.Getenv("GOPATH"), "src", "github.com", "ethereum", "go-ethereum", "ethereal", "assets")
+				assetPath := "/usr/local/opt/go-ethereum/src/ethereal/assets"
				file.Write([]byte(defaultConf + "\nasset_path = " + assetPath))
			}
		}
