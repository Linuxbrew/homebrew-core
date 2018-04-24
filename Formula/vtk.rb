# vtk: Build a bottle for Linuxbrew
class Vtk < Formula
  desc "Toolkit for 3D computer graphics, image processing, and visualization"
  homepage "https://www.vtk.org/"
  url "https://www.vtk.org/files/release/8.1/VTK-8.1.0.tar.gz"
  sha256 "6e269f07b64fb13774f5925161fb4e1f379f4e6a0131c8408c555f6b58ef3cb7"
  revision 2
  head "https://github.com/Kitware/VTK.git"

  bottle do
    sha256 "1e34e131a8519dabf2b632967d84c417b67ef39cfe256af18f6b64b12c4bc5e4" => :high_sierra
    sha256 "19901a046af52ec69be3287a8a010d3793298b62e729924efae44ffa81199d02" => :sierra
    sha256 "f0c52d002d318238e9602de43a2e5b91b79841bca6bf10454e502fa0131f5226" => :el_capitan
  end

  option "without-python@2", "Build without python2 support"

  deprecated_option "without-python" => "without-python@2"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "fontconfig"
  depends_on "hdf5"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "netcdf"
  depends_on "python@2" => :recommended
  depends_on "python" => :optional
  depends_on "qt" => :optional
  depends_on "pyqt" if build.with? "qt"

  unless OS.mac?
    depends_on "expat"
    depends_on "libxml2"
    depends_on "szip"
    depends_on "zlib"
    depends_on "tcl-tk"
    depends_on "linuxbrew/xorg/mesa"
    depends_on "linuxbrew/xorg/xorg"
  end

  needs :cxx11

  def install
    dylib = OS.mac? ? "dylib" : "so"

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
      -DVTK_WRAP_TCL=ON
    ]
    args << "-DVTK_USE_COCOA=" + (OS.mac? ? "ON" : "OFF")

    unless MacOS::CLT.installed?
      # We are facing an Xcode-only installation, and we have to keep
      # vtk from using its internal Tk headers (that differ from OSX's).
      args << "-DTK_INCLUDE_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers"
      args << "-DTK_INTERNAL_PATH:PATH=#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Headers/tk-private"
    end

    mkdir "build" do
      if build.with?("python") && build.with?("python@2")
        # VTK Does not support building both python 2 and 3 versions
        odie "VTK: Does not support building both python 2 and 3 wrappers"
      elsif build.with?("python") || build.with?("python@2")
        python_executable = `which python3`.strip if build.with? "python"
        python_executable = `which python2.7`.strip if build.with? "python@2"

        python_prefix = `#{python_executable} -c 'import sys;print(sys.prefix)'`.chomp
        python_include = `#{python_executable} -c 'from distutils import sysconfig;print(sysconfig.get_python_inc(True))'`.chomp
        python_version = "python" + `#{python_executable} -c 'import sys;print(sys.version[:3])'`.chomp
        py_site_packages = "#{lib}/#{python_version}/site-packages"

        args << "-DVTK_WRAP_PYTHON=ON"
        args << "-DPYTHON_EXECUTABLE='#{python_executable}'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_include}'"
        # CMake picks up the system's python dylib, even if we have a brewed one.
        if File.exist? "#{python_prefix}/Python"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.a"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.a'"
        elsif File.exist? "#{python_prefix}/lib/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/lib#{python_version}.#{dylib}'"
        elsif File.exist? "#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.#{dylib}"
          args << "-DPYTHON_LIBRARY='#{python_prefix}/lib/x86_64-linux-gnu/lib#{python_version}.so'"
        else
          odie "No libpythonX.Y.{dylib|so|a} file found!"
        end
        # Set the prefix for the python bindings to the Cellar
        args << "-DVTK_INSTALL_PYTHON_MODULE_DIR='#{py_site_packages}/'"
      end

      if build.with? "qt"
        args << "-DVTK_QT_VERSION:STRING=5" << "-DVTK_Group_Qt=ON"
        args << "-DVTK_WRAP_PYTHON_SIP=ON"
        args << "-DSIP_PYQT_DIR='#{Formula["pyqt5"].opt_share}/sip'"
      end

      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    Even without the --with-qt option, you can display native VTK render windows
    from python. Alternatively, you can integrate the RenderWindowInteractor
    in PyQt5, Tk or Wx at runtime. Read more:
      import vtk.qt5; help(vtk.qt5) or import vtk.wx; help(vtk.wx)
    EOS
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
