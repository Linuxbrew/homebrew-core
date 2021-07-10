class PythonDbus < Formula
  desc "Python bindings for libdbus"
  homepage "https://dbus.freedesktop.org/doc/dbus-python/"
  url "https://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.14.tar.gz"
  sha256 "b10206ba3dd641e4e46411ab91471c88e0eec1749860e4285193ee68df84ac31"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "248dae77030f91f860eaf269bf7d1705a682a7717d84b4dc1a035e1be5d219e8" # linuxbrew-core
  end

  depends_on "pkg-config" => :build
  depends_on "dbus"
  depends_on "dbus-glib"
  depends_on :linux
  depends_on "python@3.9"

  def install
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import dbus"
  end
end
