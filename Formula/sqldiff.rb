class Sqldiff < Formula
  desc "Displays the differences between SQLite databases"
  homepage "https://www.sqlite.org/sqldiff.html"
  url "https://www.sqlite.org/2020/sqlite-src-3340000.zip"
  version "3.34.0"
  sha256 "a5c2000ece56d2de13c474658b9cdba6b7f2608a4d711e245518ea02a2a2333e"
  license "blessing"

  livecheck do
    url "https://sqlite.org/news.html"
    regex(%r{v?(\d+(?:\.\d+)+)</h3>}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bc9c5f75179eebb911074c3ee03c3b569bcf78fd2b86638426cf80fcc0545ccb" => :big_sur
    sha256 "90f82a12f8b463d6ae92da105788e8a855968250f6ae2ea971e3945d3b3a5cc7" => :catalina
    sha256 "8461ed8c4664c0c026fac15277fa6d2e18586f6be60e0ea71fd6eaaffa27e8d1" => :mojave
    sha256 "1354f7deebc371dc37d59d4b5690a818ffb8b0043139abba9915fd1b16027a77" => :x86_64_linux
  end

  uses_from_macos "tcl-tk" => :build
  uses_from_macos "sqlite" => :test

  def install
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make", "sqldiff"
    bin.install "sqldiff"
  end

  test do
    dbpath = testpath/"test.sqlite"
    sqlpath = testpath/"test.sql"
    sqlite = OS.mac? ? "/usr/bin/sqlite3" : Formula["sqlite"].bin/"sqlite3"
    sqlpath.write "create table test (name text);"
    system "#{sqlite} #{dbpath} < #{sqlpath}"
    assert_equal "test: 0 changes, 0 inserts, 0 deletes, 0 unchanged",
                 shell_output("#{bin}/sqldiff --summary #{dbpath} #{dbpath}").strip
  end
end
