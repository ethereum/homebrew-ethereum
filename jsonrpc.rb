require 'formula'

class Jsonrpc < Formula

  version '0.2.1'

  homepage 'https://github.com/cinemast/libjson-rpc-cpp'
  url 'https://github.com/cinemast/libjson-rpc-cpp.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'curl'

  def install
    system "cd", "build"
    system "cmake", "."
    system "make", "install"
  end

end
