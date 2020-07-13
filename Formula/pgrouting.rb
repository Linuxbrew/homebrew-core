class Pgrouting < Formula
  desc "Provides geospatial routing for PostGIS/PostgreSQL database"
  homepage "https://pgrouting.org/"
  url "https://github.com/pgRouting/pgrouting/releases/download/v3.0.1/pgrouting-3.0.1.tar.gz"
  sha256 "c68b680e533c7f1272a5970b47120c1ee0c380c87dc7765220b9b08376ca24ff"
  head "https://github.com/pgRouting/pgrouting.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "27162013c5ee71817df7b0dfd2719fa0d4feffa12562459f40be60ef6e9dc489" => :catalina
    sha256 "07641049a211aa7b93fd12743b88e33fe2d1cd79c38bff5c66d56a5cd95ce90a" => :mojave
    sha256 "8d108e351d1f25eff11f6436fee86065f20d9d5caefa31a2c2b12d65e4985203" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "cgal"
  depends_on "gmp"
  depends_on "postgis"
  depends_on "postgresql"

  def install
    mkdir "stage"
    mkdir "build" do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make"
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    lib.install Dir["stage/**/lib/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    return if ENV["CI"]

    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2
      system "#{pg_bin}/createdb", "-p", pg_port
      system "#{pg_bin}/psql", "-p", pg_port, "--command", "CREATE DATABASE test;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION postgis;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION pgrouting;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
