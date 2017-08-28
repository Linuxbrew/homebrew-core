class Ocamlsdl < Formula
  desc "OCaml interface with the SDL C library"
  homepage "https://ocamlsdl.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ocamlsdl/OCamlSDL/ocamlsdl-0.9.1/ocamlsdl-0.9.1.tar.gz"
  sha256 "abfb295b263dc11e97fffdd88ea1a28b46df8cc2b196777093e4fe7f509e4f8f"
  revision 7

  bottle do
    cellar :any
    sha256 "80146d6d5cd4314eb8837d34981416f3e8165564b4c3cf9c3a714b01e341d260" => :sierra
    sha256 "a3a58336be78c5b1184d90c41b131a56dac49c8b31ede956a5301f9fa8a1f476" => :el_capitan
    sha256 "ab870f40ad5fd7fc3c627d246560998ee856c14da016381ef43ead6431c24f4e" => :yosemite
    sha256 "06ac2ee7f88c6ffed20e70b95f887a2fde63dc205dd9660ba2f0811b749f6108" => :x86_64_linux # glibc 2.19
  end

  depends_on "sdl"
  depends_on "ocaml"
  depends_on "sdl_mixer" => :recommended
  depends_on "sdl_image" => :recommended
  depends_on "sdl_gfx" => :recommended
  depends_on "sdl_ttf" => :recommended

  def install
    system "./configure", "--prefix=#{prefix}",
                          "OCAMLLIB=#{lib}/ocaml"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.ml").write <<-EOS.undent
      let main () =
        Sdl.init [`VIDEO];
        Sdl.quit ()

      let _ = main ()
    EOS
    system "#{Formula["ocaml"].opt_bin}/ocamlopt", "-I", "+sdl", "sdl.cmxa",
           "-cclib", "-lSDLmain", "-cclib", "-lSDL", "-cclib",
           *("-Wl,-framework,Cocoa" if OS.mac?), "-o", "test", "test.ml"
    system "./test"
  end
end
