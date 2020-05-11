class Itk < Formula
  desc "Insight Toolkit is a toolkit for performing registration and segmentation"
  homepage "https://itk.org"
  url "https://github.com/InsightSoftwareConsortium/ITK/releases/download/v5.0.1/InsightToolkit-5.0.1.tar.gz"
  sha256 "613b125cbf58481e8d1e36bdeacf7e21aba4b129b4e524b112f70c4d4e6d15a6"
  revision 1
  head "https://github.com/InsightSoftwareConsortium/ITK.git"

  bottle do
    sha256 "2baca856421c5089926dc09a573743e101fabd11cae5ac611e26d0609bb5f6a6" => :catalina
    sha256 "85695ce0ee0cbf98a77acb458ae3d6f0bc90c86a3126a90abe9ecbdc0b72e8eb" => :mojave
    sha256 "d8122820121a4ab59c76276eb8acfda4483c80fb767857d0ec7d77120ec1ef7b" => :high_sierra
    sha256 "0ed413f476bbdf720c0bf5dd6b1bb93b52ae1e37f4b9f9879bc0a95a2605c3fb" => :x86_64_linux
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdcm"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "vtk"
  unless OS.mac?
    depends_on "alsa-lib"
    depends_on "glibc"
    depends_on "unixodbc"
  end

  def install
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DITK_USE_64BITS_IDS=ON
      -DITK_USE_STRICT_CONCEPT_CHECKING=ON
      -DITK_USE_SYSTEM_ZLIB=ON
      -DITK_USE_SYSTEM_EXPAT=ON
      -DModule_SCIFIO=ON
      -DITKV3_COMPATIBILITY:BOOL=OFF
      -DITK_USE_SYSTEM_FFTW=ON
      -DITK_USE_FFTWF=ON
      -DITK_USE_FFTWD=ON
      -DITK_USE_SYSTEM_HDF5=ON
      -DITK_USE_SYSTEM_JPEG=ON
      -DITK_USE_SYSTEM_PNG=ON
      -DITK_USE_SYSTEM_TIFF=ON
      -DITK_USE_SYSTEM_GDCM=ON
      -DITK_LEGACY_REMOVE=ON
      -DModule_ITKLevelSetsv4Visualization=ON
      -DModule_ITKReview=ON
      -DModule_ITKVtkGlue=ON
    ]

    # Requires OpenCL on Linux which is not available in Homebrew
    args << if OS.mac?
      "-DITK_USE_GPU=ON"
    else
      "-DITK_USE_GPU=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cxx").write <<-EOS
      #include "itkImage.h"
      int main(int argc, char* argv[])
      {
        typedef itk::Image<unsigned short, 3> ImageType;
        ImageType::Pointer image = ImageType::New();
        image->Update();
        return EXIT_SUCCESS;
      }
    EOS

    v = version.to_s.split(".")[0..1].join(".")
    suffix = OS.mac? ? "#{v}.1.dylib" : "#{v}.so.1"
    # Build step
    system ENV.cxx, "-std=c++11", "-isystem", "#{include}/ITK-#{v}", "-o", "test.cxx.o", "-c", "test.cxx"
    # Linking step
    system ENV.cxx, "-std=c++11", "test.cxx.o", "-o", "test",
                    "#{lib}/libITKCommon-#{suffix}",
                    "#{lib}/libITKVNLInstantiation-#{suffix}",
                    "#{lib}/libitkvnl_algo-#{suffix}",
                    "#{lib}/libitkvnl-#{suffix}"
    system "./test"
  end
end
