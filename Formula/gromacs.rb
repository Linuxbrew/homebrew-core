class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2020.2.tar.gz"
  sha256 "7465e4cd616359d84489d919ec9e4b1aaf51f0a4296e693c249e83411b7bd2f3"
  revision 1

  bottle do
    sha256 "58dd207377d3cdaad5a162134e113be0bd2efa225c202089d7ef1863cef8f93b" => :catalina
    sha256 "d3f15cda513906fd9a57832d15e8fecd0627b31e984b7f15981cb57d8f3e40b2" => :mojave
    sha256 "3617784ee60e87999f305b2530cd5e83ad89db13049e947c597fa1927ab3eae9" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gcc"
  depends_on "gsl" # for OpenMP
  depends_on "openblas"
  depends_on "linuxbrew/xorg/xorg" unless OS.mac?

  def install
    # Non-executable GMXRC files should be installed in DATADIR
    inreplace "scripts/CMakeLists.txt", "CMAKE_INSTALL_BINDIR",
                                        "CMAKE_INSTALL_DATADIR"

    # Avoid superenv shim reference
    inreplace "src/gromacs/gromacs-toolchain.cmake.cmakein", "@CMAKE_LINKER@",
                                                             "/usr/bin/ld"

    args = std_cmake_args + %W[
      -DCMAKE_C_COMPILER=gcc-#{Formula["gcc"].version_suffix}
      -DCMAKE_CXX_COMPILER=g++-#{Formula["gcc"].version_suffix}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install "#{bin}/gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install "#{bin}/gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats
    <<~EOS
      GMXRC and other scripts installed to:
        #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end
