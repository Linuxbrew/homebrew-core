class Roswell < Formula
  desc "Lisp installer and launcher for major environments"
  homepage "https://github.com/roswell/roswell"
  url "https://github.com/roswell/roswell/archive/v18.3.10.89.tar.gz"
  sha256 "3606469a787bd83f5f9bf887c49ebb264339ef18977097f63270356ce50c20b7"
  head "https://github.com/roswell/roswell.git"

  bottle do
    sha256 "c87b74c9daa7220742540d9b68736db5125f0229a4ee8b94b1bf3d8078eace7b" => :high_sierra
    sha256 "ec64d8f24316cb562698df1204364417eadba35cc885effe77d50ea11de9624c" => :sierra
    sha256 "460379c66ee483de0807bb1c5b8beb91ef62ebae56c5aa4a3714bbefaf485604" => :el_capitan
    sha256 "4c2f4821338d1ebde037f8175cd8e3da59aefde0501ce8c7750f3d52f27c87d8" => :x86_64_linux
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "curl" unless OS.mac?

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["ROSWELL_HOME"] = testpath
    system bin/"ros", "init"
    assert_predicate testpath/"config", :exist?
  end
end
