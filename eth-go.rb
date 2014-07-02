require 'formula'

class EthGo < Formula

  version '0.5.16'

  homepage 'https://github.com/ethereum/eth-go'
  head 'https://github.com/ethereum/eth-go.git', :branch => 'develop'
  url 'https://github.com/ethereum/eth-go.git', :branch => 'master'

  depends_on 'go' => :build
  depends_on 'mercurial'
  depends_on 'gmp'
  depends_on 'readline'
  depends_on 'pkg-config'
  depends_on 'serpent-go'

  keg_only "No executable"

  def patches
    DATA
  end

  def install
    ENV["PKG_CONFIG_PATH"] = "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"

    ENV["GOPATH"] = "#{buildpath}:#{prefix}:#{HOMEBREW_PREFIX}/opt/serpent-go"
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
diff --git a/ethcrypto/mnemonic.go b/ethcrypto/mnemonic.go
index 6134f85..b8edfa5 100644
--- a/ethcrypto/mnemonic.go
+++ b/ethcrypto/mnemonic.go
@@ -3,16 +3,12 @@ package ethcrypto
 import (
 	"fmt"
 	"io/ioutil"
-	"path"
-	"runtime"
 	"strconv"
 	"strings"
 )
 
 func InitWords() []string {
-	_, thisfile, _, _ := runtime.Caller(1)
-	filename := path.Join(path.Dir(thisfile), "mnemonic.words.lst")
-	content, err := ioutil.ReadFile(filename)
+	content, err := ioutil.ReadFile("/usr/local/opt/eth-go/ethcrypto/mnemonic.words.lst")
 	if err != nil {
 		panic(fmt.Errorf("reading mnemonic word list file 'mnemonic.words.lst' failed: ", err))
 	}
