require 'formula'

class Serpent < Formula

  version '1.3.8'

  homepage 'https://github.com/ethereum/serpent'
  url 'https://github.com/ethereum/serpent.git', :branch => 'master'

  # depends_on 'pkg-config'

  def patches
    DATA
  end

  def install
    system "make", "serpentc"
    system "make"

    bin.install ["serpent"]
    lib.install ["libserpent.a"]
    prefix.install ["pyserpent.so"]

    mkdir "libserpent"
    mv Dir["*.h"], "libserpent"
    include.install "libserpent"

    pyserpent = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/pyserpent.so"
    rm pyserpent if File.symlink?(pyserpent)
    ln_s prefix/"pyserpent.so", pyserpent
  end
end
__END__
