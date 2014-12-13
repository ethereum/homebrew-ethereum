require 'formula'

class Jsonrpc3 < Formula

  version '0.3.2'

  homepage 'https://github.com/cinemast/libjson-rpc-cpp'
  url 'https://github.com/cinemast/libjson-rpc-cpp.git', :revision => 'b441bd3e8d8635e8220926486fe83370dbeb43c2'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'argtable'
  depends_on 'curl'
  depends_on 'jsoncpp'
  depends_on 'mongoose'

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

