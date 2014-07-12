require 'formula'

class Serpent < Formula

  version '1.4.14'

  homepage 'https://github.com/ethereum/langs'
  url 'https://github.com/ethereum/langs.git', :branch => 'develop'

  depends_on 'cmake' => :build
  depends_on 'boost' => ["c++11", "with-python"]

  def patches
    DATA
  end

  def install
    system "cmake", *std_cmake_args, "-DLANGUAGES=1"
    system "make", "install"

    pyserpent = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/pyserpent.so"
    rm pyserpent if File.symlink?(pyserpent)
    ln_s lib/"libpyserpent.dylib", pyserpent
  end
end
__END__
