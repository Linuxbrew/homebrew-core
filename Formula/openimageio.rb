class Openimageio < Formula
  desc "Library for reading, processing and writing images"
  homepage "https://openimageio.org/"
  url "https://github.com/OpenImageIO/oiio/archive/Release-2.2.16.0.tar.gz"
  sha256 "d1a59f32dbba3ba71ad2e62e107034d1c5287bca1b0696474e927d504cd05ef4"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/OpenImageIO/oiio.git"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/(?:Release[._-])?v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "070cab464c961ce988cfb2ecb16efd31ea9fe527124f9d73e110bcf69810d3c6"
    sha256 cellar: :any,                 big_sur:       "db72e144b06fcd01b5e1317786924e16e1518ce5f2ee6a3538c73459a85f3c9e"
    sha256 cellar: :any,                 catalina:      "3b1df7b5ca4dced9ceba91bc7fb19ee39165965f932c7806d6c787d30748599d"
    sha256 cellar: :any,                 mojave:        "e49e7d6e1c0daab20f24d5d742af3a8b959ddc5f658420d3d94ad0fb62fa7556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8740be77164baf62f2b8fd08fee42d2cd7a98370f0028cdf70e806c0502fddcc" # linuxbrew-core
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "boost-python3"
  depends_on "ffmpeg"
  depends_on "freetype"
  depends_on "giflib"
  depends_on "imath"
  depends_on "jpeg"
  depends_on "libheif"
  depends_on "libpng"
  depends_on "libraw"
  depends_on "libtiff"
  depends_on "opencolorio"
  depends_on "openexr"
  depends_on "pybind11"
  depends_on "python@3.9"
  depends_on "webp"

  def install
    args = std_cmake_args + %w[
      -DCCACHE_FOUND=
      -DEMBEDPLUGINS=ON
      -DUSE_FIELD3D=OFF
      -DUSE_JPEGTURBO=OFF
      -DUSE_NUKE=OFF
      -DUSE_OPENCV=OFF
      -DUSE_OPENGL=OFF
      -DUSE_OPENJPEG=OFF
      -DUSE_PTEX=OFF
      -DUSE_QT=OFF
    ]

    # CMake picks up the system's python shared library, even if we have a brewed one.
    py3ver = Language::Python.major_minor_version Formula["python@3.9"].opt_bin/"python3"
    py3prefix = Formula["python@3.9"].opt_frameworks/"Python.framework/Versions/#{py3ver}"
    on_linux do
      py3prefix = Formula["python@3.9"].opt_prefix
    end

    ENV["PYTHONPATH"] = lib/"python#{py3ver}/site-packages"

    args << "-DPYTHON_EXECUTABLE=#{py3prefix}/bin/python3"
    args << "-DPYTHON_LIBRARY=#{py3prefix}/lib/#{shared_library("libpython#{py3ver}")}"
    args << "-DPYTHON_INCLUDE_DIR=#{py3prefix}/include/python#{py3ver}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    test_image = test_fixtures("test.jpg")
    assert_match "#{test_image} :    1 x    1, 3 channel, uint8 jpeg",
                 shell_output("#{bin}/oiiotool --info #{test_image} 2>&1")

    output = <<~EOS
      from __future__ import print_function
      import OpenImageIO
      print(OpenImageIO.VERSION_STRING)
    EOS
    assert_match version.major_minor_patch.to_s, pipe_output(Formula["python@3.9"].opt_bin/"python3", output, 0)
  end
end
