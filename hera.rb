class Hera < Formula
  desc "Hera: Ewasm virtual machine conforming to the EVMC API"
  homepage "https://github.com/ewasm/hera"

  stable do
    url "https://github.com/ewasm/hera/archive/v0.2.4.tar.gz"
    sha256 "6d1bb30764c892f1aaada26c08add021a981d1d27638d2c9e198ca831544f9d1"

    resource "cmake/cable" do
      url "https://github.com/ethereum/cable.git", tag: "v0.2.17"
    end

    resource "evmc" do
      url "https://github.com/ethereum/evmc.git", tag: "v6.2.2"
    end
  end

  head "https://github.com/ewasm/hera.git"

  option "with-debugging", "Build with debugging features and messages"
  option "without-shared-libraries", "Build libraries as static"
  option "with-binaryen", "Build with binaryen"
  option "without-wabt", "Build without wabt"
  option "with-wavm", "Build with WAVM"

  depends_on "cmake" => :build
  depends_on "llvm@6"

  def install
    # Check out dependencies when not HEAD.
    resources.each { |r| r.stage(buildpath/r.name) }

    # Use LLVM6 so we can potentially build with WAVM.
    ENV['CXX'] = "#{Formula["llvm@6"].bin}/clang++"

    # We want the Release with Debug symbols build type, which is the default.
    args = std_cmake_args - %W[-DCMAKE_BUILD_TYPE=Release]

    args << "-DBUILD_SHARED_LIBS=OFF" if build.without?("shared-libraries")
    args << "-DHERA_DEBUGGING=ON" if build.with?("debugging")
    args << "-DHERA_BINARYEN=ON" if build.with?("binaryen")
    args << "-DHERA_WABT=OFF" if build.without?("wabt")
    args << "-DHERA_WAVM=ON" if build.with?("wavm")

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <hera/hera.h>

      int main()
      {
        struct evmc_instance *vm = evmc_create_hera();
        evmc_capabilities_flagset capabilities = vm->get_capabilities(vm);

        assert(capabilities & EVMC_CAPABILITY_EWASM);
      }
    C

    flags = ["-L#{lib}", "-lhera", "-I#{include}"]
    system ENV.cc, "-o", "test", "test.c", *(flags + ENV.cflags.to_s.split)
    system "./test"
  end
end
