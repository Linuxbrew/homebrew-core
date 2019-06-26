class Libgpm < Formula
  desc "General-purpose mouse"
  homepage "https://www.nico.schottelius.org/software/gpm/"
  url "https://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2"
  sha256 "f011b7dc7afb824e0a017b89b7300514e772853ece7fc4ee640310889411a48d"
  head "https://github.com/telmich/gpm.git"
  # tag "linuxbrew"

  bottle do
    cellar :any
    sha256 "7aec47e93bf034b08d3376ce35e75c87e0dd4995917f5f0727b0297189e02af8" => :x86_64_linux # glibc 2.19
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "bison" => :build
  depends_on "texinfo" => :build
  uses_from_macos "ncurses"

  patch :DATA
  patch do
    url "https://github.com/telmich/gpm/pull/14.patch?full_index=1"
    sha256 "0bcee6127c9fcae7f515fc2adda621877cb19f741a8e99c400d044c8f01832c3"
  end

  def install
    ENV.deparallelize

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/gpm", "-v"
  end
end

__END__
diff --git a/acinclude.m4 b/acinclude.m4
index a932e3a..1e828d0 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -22,7 +22,7 @@ AC_DEFUN([ITZ_PATH_SITE_LISP],
 sed -e '/^$/d' | sed -n -e 2p`
 case x${itz_cv_path_site_lisp} in
 x*site-lisp*) ;;
-x*) itz_cv_path_site_lisp='${datadir}/emacs/site-lisp' ;;
+x*) itz_cv_path_site_lisp='${datadir}/emacs/site-lisp/libgpm' ;;
 esac])
 ])
 AC_DEFUN([ITZ_CHECK_TYPE],
