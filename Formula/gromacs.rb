class Gromacs < Formula
  desc "Versatile package for molecular dynamics calculations"
  homepage "http://www.gromacs.org/"
  url "https://ftp.gromacs.org/pub/gromacs/gromacs-2016.3.tar.gz"
  sha256 "7bf00e74a9d38b7cef9356141d20e4ba9387289cbbfd4d11be479ef932d77d27"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    prefix "/home/linuxbrew/.linuxbrew"
    cellar "/home/linuxbrew/.linuxbrew/Cellar"
    sha256 "1cceab50734d5240051aafaa44cd40726a996de3e92ef523c5e347e15d304ad8" => :x86_64_linux # glibc 2.19
  end

  option "with-double", "Enables double precision"

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gsl"
  depends_on :mpi => :optional
  depends_on :x11 => :optional

  def install
    args = std_cmake_args + %w[-DGMX_GSL=ON]
    args << "-DGMX_DOUBLE=ON" if build.include? "enable-double"
    args << "-DGMX_MPI=ON" if build.with? "mpi"
    args << "-DGMX_X11=ON" if build.with? "x11"

    inreplace "scripts/CMakeLists.txt", "BIN_INSTALL_DIR", "DATA_INSTALL_DIR"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      ENV.deparallelize { system "make", "install" }
    end

    bash_completion.install "build/scripts/GMXRC" => "gromacs-completion.bash"
    bash_completion.install "#{bin}/gmx-completion-gmx.bash" => "gmx-completion-gmx.bash"
    bash_completion.install "#{bin}/gmx-completion.bash" => "gmx-completion.bash"
    zsh_completion.install "build/scripts/GMXRC.zsh" => "_gromacs"
  end

  def caveats; <<-EOS.undent
    GMXRC and other scripts installed to:
      #{HOMEBREW_PREFIX}/share/gromacs
    EOS
  end

  test do
    system "#{bin}/gmx", "help"
  end
end
