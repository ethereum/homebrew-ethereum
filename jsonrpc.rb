require 'formula'

class Jsonrpc < Formula

  version '0.2.1'

  homepage 'https://github.com/cinemast/libjson-rpc-cpp'
  url 'https://github.com/cinemast/libjson-rpc-cpp.git', :revision => 'eaca2481e2889d5a5b748383fb02b1d395969cd4'

  depends_on 'cmake' => :build
  depends_on 'curl'

  option "allow-origin", "Patch to add Access-Control-Allow-Origin: * in headers"

  def install
    system "cmake", *std_cmake_args
    system "make"
    system "make", "install"
  end

  def patches
    p = []

    p << "https://gist.githubusercontent.com/caktux/b876fb0bf638f02387a8/raw/0b4ae5ab9ede6f4d88b5a5143437de00d92aa052/jsonrpc-allow-origin.patch" if build.include? "allow-origin"

    return p
  end

end
__END__
