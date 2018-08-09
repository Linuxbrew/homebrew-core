class Tippecanoe < Formula
  desc "Build vector tilesets from collections of GeoJSON features"
  homepage "https://github.com/mapbox/tippecanoe"
  url "https://github.com/mapbox/tippecanoe/archive/1.31.0.tar.gz"
  sha256 "7ce03220ccc00b7d2455f76447919c85a3aea2f98e08530714662d1567a62741"

  bottle do
    cellar :any_skip_relocation
    depends_on "sqlite"
    depends_on "zlib"
  end

  unless OS.mac?
    depends_on "sqlite"
    depends_on "zlib"
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.json").write <<~EOS
      {"type":"Feature","properties":{},"geometry":{"type":"Point","coordinates":[0,0]}}
    EOS
    safe_system "#{bin}/tippecanoe", "-o", "test.mbtiles", "test.json"
    assert_predicate testpath/"test.mbtiles", :exist?, "tippecanoe generated no output!"
  end
end
