# vtk: Build a bottle for Linux
class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  revision 7
  head "https://github.com/Kitware/VTK.git"

  stable do
    url "https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz"
    sha256 "34c3dc775261be5e45a8049155f7228b6bd668106c72a3c435d95730d17d57bb"

    # Fix compile issues on Mojave and later
    patch do
      url "https://gitlab.kitware.com/vtk/vtk/commit/ca3b5a50d945b6e65f0e764b3138cad17bd7eb8d.diff"
      sha256 "b9f7a3ebf3c29f3cad4327eb15844ac0ee849755b148b60fef006314de8e822e"
    end
  end

  bottle do
    sha256 "ac746258546ac527205977f927dadd4d1e731b6bad5fff198158b9453f2791ca" => :catalina
    sha256 "8a9478215a8f23d34a47815ec96d268227e4f102f1b37cb223e23687e3af1f17" => :mojave
    sha256 "870a14f3b1973b2c3e5523e1377eb8f151893f242e5d2d2ae01b2782537468e6" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fontconfig"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "netcdf"
  depends_on "pyqt"
  depends_on "python"
  depends_on "qt"

  unless OS.mac?
    depends_on "expat"
    depends_on "libxml2"
    depends_on "szip"
    depends_on "zlib"
    depends_on "tcl-tk"
    depends_on "linuxbrew/xorg/mesa"
    depends_on "linuxbrew/xorg/xorg"
  end

  def install
    pyver = Language::Python.major_minor_version "python3"
    if OS.mac?
      dylib = "libpython#{pyver}.dylib"
      py_prefix = Formula["python3"].opt_frameworks/"Python.framework/Versions/#{pyver}"
    else
      dylib = "libpython3.so"
      py_prefix = Formula["python3"].opt_prefix
    end
    args = std_cmake_args + %W[
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TESTING=OFF
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
      -DModule_vtkInfovisBoost=ON
      -DModule_vtkInfovisBoostGraphAlgorithms=ON
      -DModule_vtkRenderingFreeTypeFontConfig=ON
      -DVTK_REQUIRED_OBJCXX_FLAGS=''
      -DVTK_USE_SYSTEM_EXPAT=ON
      -DVTK_USE_SYSTEM_HDF5=ON
      -DVTK_USE_SYSTEM_JPEG=ON
      -DVTK_USE_SYSTEM_LIBXML2=ON
      -DVTK_USE_SYSTEM_NETCDF=ON
      -DVTK_USE_SYSTEM_PNG=ON
      -DVTK_USE_SYSTEM_TIFF=ON
      -DVTK_USE_SYSTEM_ZLIB=ON
      -DVTK_WRAP_PYTHON=ON
      -DVTK_PYTHON_VERSION=3
      -DPYTHON_EXECUTABLE=#{Formula["python"].opt_bin}/python3
      -DPYTHON_INCLUDE_DIR=#{py_prefix}/include/python#{pyver}m
      -DPYTHON_LIBRARY=#{py_prefix}/lib/#{dylib}
      -DVTK_INSTALL_PYTHON_MODULE_DIR=#{lib}/python#{pyver}/site-packages
      -DVTK_QT_VERSION:STRING=5
      -DVTK_Group_Qt=ON
      -DVTK_WRAP_PYTHON_SIP=ON
      -DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'
    ]
    args << "-DVTK_USE_COCOA=" + (OS.mac? ? "ON" : "OFF")

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Avoid hard-coding HDF5's Cellar path
    inreplace Dir["#{lib}/cmake/**/vtkhdf5.cmake"].first,
              Formula["hdf5"].prefix.realpath,
              Formula["hdf5"].opt_prefix
  end

  test do
    vtk_include = Dir[opt_include/"vtk-*"].first
    major, minor = vtk_include.match(/.*-(.*)$/)[1].split(".")

    (testpath/"version.cpp").write <<~EOS
      #include <vtkVersion.h>
      #include <assert.h>
      int main(int, char *[]) {
        assert (vtkVersion::GetVTKMajorVersion()==#{major});
        assert (vtkVersion::GetVTKMinorVersion()==#{minor});
        return EXIT_SUCCESS;
      }
    EOS

    system ENV.cxx, "-std=c++11", "version.cpp", "-I#{vtk_include}"
    system "./a.out"
    system "#{bin}/vtkpython", "-c", "exit()"
  end
end
