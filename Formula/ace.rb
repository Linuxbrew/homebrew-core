class Ace < Formula
  desc "ADAPTIVE Communication Environment: OO network programming in C++"
  homepage "https://www.dre.vanderbilt.edu/~schmidt/ACE.html"
  url "https://github.com/DOCGroup/ACE_TAO/releases/download/ACE%2BTAO-6_5_9/ACE-6.5.9.tar.bz2"
  sha256 "7f42943b6c0b6aa76372a609d63d38a732e694457a0fc253c0fa69c488cbeee0"

  bottle do
    cellar :any
    sha256 "65e2c42a989d0968d355ebc5ae6d9c3d476e5033d73c75f2f104346c017bf4af" => :catalina
    sha256 "4c606d3f37192277a553988ec798658af5bfe2ed030822eb45f92ba49e358e84" => :mojave
    sha256 "5b2d37884642b72360d146195abe8ef69d3ed9e4b72bf85d9b68d9e82897693e" => :high_sierra
  end

  def install
    ln_sf "config-macosx.h", "ace/config.h"
    ln_sf "platform_macosx.GNU", "include/makeinclude/platform_macros.GNU"

    # Set up the environment the way ACE expects during build.
    ENV["ACE_ROOT"] = buildpath
    ENV["DYLD_LIBRARY_PATH"] = "#{buildpath}/lib"

    # Done! We go ahead and build.
    system "make", "-C", "ace", "-f", "GNUmakefile.ACE",
                   "INSTALL_PREFIX=#{prefix}",
                   "LDFLAGS=",
                   "DESTDIR=",
                   "INST_DIR=/ace",
                   "debug=0",
                   "shared_libs=1",
                   "static_libs=0",
                   "install"

    system "make", "-C", "examples"
    pkgshare.install "examples"
  end

  test do
    cp_r "#{pkgshare}/examples/Log_Msg/.", testpath
    system "./test_callback"
  end
end
