require 'formula'

class Jsonrpc4 < Formula

  version '0.4.1'

  homepage 'https://github.com/cinemast/libjson-rpc-cpp'
  url 'https://github.com/cinemast/libjson-rpc-cpp.git', :revision => 'db59698404ef86af85e60fb9f26d7f63af8c0054'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'argtable'
  depends_on 'curl'
  depends_on 'jsoncpp'
  depends_on 'mongoose'
  depends_on 'libmicrohttpd'

  # option "allow-origin", "Patch to add Access-Control-Allow-Origin: * in headers"

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  def patches
    p = []

    # p << "https://gist.githubusercontent.com/caktux/b876fb0bf638f02387a8/raw/ea7db7cfcf8223acfdaf0b60626e592f5ed7836a/jsonrpc-allow-origin.patch" if build.include? "allow-origin"

    return p
  end

end
__END__
