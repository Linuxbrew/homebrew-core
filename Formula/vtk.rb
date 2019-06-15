class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/8.2/VTK-8.2.0.tar.gz"
  sha256 "34c3dc775261be5e45a8049155f7228b6bd668106c72a3c435d95730d17d57bb"
  head "https://github.com/Kitware/VTK.git"

  bottle do
    sha256 "6048bdb469ac541f9714b278c697427afd9d8ac30b0263b307871c1877c94933" => :mojave
    sha256 "2964017670fb49e932b0aaa7c263d872bcb579facc83f898e4aba4d1069eb512" => :high_sierra
    sha256 "a0388d85d98c235ed9f93e8f89272442c34682c24c262a9bae9a99d1acc6546f" => :sierra
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
    unless OS.mac?
      linux_ldpath = `/sbin/ldconfig -v 2>/dev/null | grep -v ^$'\t'`
      if linux_ldpath.include? "/usr/lib/#{RUBY_PLATFORM}:"
        linux_lib = "/usr/lib/#{RUBY_PLATFORM}"
      elsif linux_ldpath.include? "/usr/lib64:"
        linux_lib = "/usr/lib64"
      else
        linux_lib = "/usr/lib"
      end
    end
    dylib = OS.mac? ? "dylib" : "so"

    python_executable = `which python3`.strip
    python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
    python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
    python_version = python_include.split("/").last
    py_site_packages = `#{python_executable} -c "import site;print(site.getsitepackages()[0])"`.chomp

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
      -DPYTHON_EXECUTABLE='#{python_executable}'
      -DPYTHON_INCLUDE_DIR='#{python_include}'
      -DVTK_INSTALL_PYTHON_MODULE_DIR='#{py_site_packages}/'
      -DVTK_QT_VERSION:STRING=5
      -DVTK_Group_Qt=ON
      -DVTK_WRAP_PYTHON_SIP=ON
      -DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'
    ]
    args << "-DVTK_USE_COCOA=" + (OS.mac? ? "ON" : "OFF")

    # CMake picks up the system's python {dylib|so}, even if we have a brewed one.
    if File.exist? "#{python_prefix}/Python"
      args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
    elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
      args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
    elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
      args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.#{dylib}'"
    elsif !OS.mac? && File.exist?("#{linux_lib}/lib#{python_version}.#{dylib}")
      args << "-DPYTHON_LIBRARY='#{linux_lib}/lib#{python_version}.#{dylib}'"
    else
      odie "No libpythonX.Y.{#{dylib}|a} file found!"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    # Avoid hard-coding Python's Cellar paths
    inreplace Dir["#{lib}/cmake/**/vtkPython.cmake"].first,
      Formula["python"].prefix.realpath,
      Formula["python"].opt_prefix

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
