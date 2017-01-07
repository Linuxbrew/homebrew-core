class PythonDbus < Formula
  desc "Python bindings for libdbus"
  homepage "https://dbus.freedesktop.org/doc/dbus-python/"
  url "https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.14.tar.gz"
  sha256 "b10206ba3dd641e4e46411ab91471c88e0eec1749860e4285193ee68df84ac31"
  # tag "linux"

  bottle do
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on "python"

  def install
    ENV["PYTHON"] = Formula["python"].opt_bin/"python3"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system Formula["python"].opt_bin/"python3", "-c", "import dbus"
  end
end
