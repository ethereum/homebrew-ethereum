require 'formula'

class Serpent < Formula

  version '0.5.1'

  homepage 'https://github.com/ethereum/serpent'
  url 'https://github.com/ethereum/serpent.git', :branch => 'master'

  # depends_on 'pkg-config'

  def patches
    inreplace "Makefile" do |s|
      s.gsub! " -Wl,--export-dynamic", ""
    end

    DATA
  end

  def install
    system "make", "serpentc"
    system "make"

    bin.install ["serpent"]
    lib.install ["libserpent.a"]
    prefix.install ["pyserpent.so"]

    pyserpent = "#{HOMEBREW_PREFIX}/lib/python2.7/site-packages/pyserpent.so"
    rm pyserpent if File.exist?(pyserpent)
    ln_s prefix/"pyserpent.so", pyserpent
  end
end
__END__
