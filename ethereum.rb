require 'formula'

class Ethereum < Formula
		
	homepage 'https://github.com/ethereum/cpp-ethereum'
	head 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
	url 'https://github.com/ethereum/cpp-ethereum.git', :revision => '566eae4cab4cddc61b778a0033a4da958c1ad6ee'
	# url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'develop'
	# url 'https://github.com/ethereum/cpp-ethereum.git', :branch => 'release-poc-3'
	version '0.3.11'

	depends_on 'cmake' => :build
	depends_on 'boost' => "--c++11"
	# depends_on 'pkg-config' => :build
	depends_on 'qt5'
	depends_on 'cryptopp'
	depends_on 'miniupnpc'
	depends_on 'leveldb'
	depends_on 'gmp'
	depends_on 'ncurses' if build.include? 'with-ncurses'

	option 'build-release', "Develop or Release"
	option 'with-ncurses', "Try the ncurses patch"
	option 'with-faucet', "Try the faucet patch"

	def patches
		# inreplace 'eth/CMakeLists.txt' do |s|
		#   s.gsub! "replace", "with"
		#   # s.remove_make_var! %w[CFLAGS LDFLAGS CC LD]
		#   # s.change_make_var! "CC", ENV.cc
		# end

		urls = [
		  ["with-ncurses", "https://gist.githubusercontent.com/caktux/9377648/raw/508ffe5a8b22e472cc6575bc2a852af5c9a7f747/ethereum-cli-ncurses.patch"],
		  ["with-faucet", "https://gist.githubusercontent.com/caktux/9335964/raw/77033978f5fab8c7cab87135b29d1fdf095351db/faucet-develop.patch"],
		]

		p = []
		urls.each do |u|
		  p << u[1] if build.include? u[0]
		end

		return p

		# Uncomment below to use a patch added after __END__
		# DATA
	end

	def install
			# system "cmake"

			args = [
				# "--prefix=#{prefix}",
				# "PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/opt/curl/lib/pkgconfig:#{HOMEBREW_PREFIX}/opt/ethereum/lib/pkgconfig"
				# "--enable-some-flag"
			]

			# args << "--build-release" if build.include? '--build-release'

			if build.include? "--build-release"
				args << "-DCMAKE_BUILD_TYPE=Release"
			elsif build.include? "--with-faucet"
				args << "-DCMAKE_BUILD_TYPE=Faucet"
			elsif build.include? "--with-ncurses"
				args << "-DCMAKE_BUILD_TYPE=ncurses"
			else
				args << "-DCMAKE_BUILD_TYPE=Develop"
			end

			system "cmake", *args
			system "make", "install"
			# system "make install"

			bin.install 'eth/eth'
			prefix.install 'alethzero/AlethZero.app'
			lib.install Dir['libethereum/*.dylib']
			lib.install Dir['secp256k1/*.dylib']
			# prefix.install Dir['*']
	end

	test do
			system "eth"
	end

end

__END__
