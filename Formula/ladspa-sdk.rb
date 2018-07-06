class LadspaSdk < Formula
  desc "Linux Audio Developer's Simple Plugin"
  homepage "https://ladspa.org"
  url "https://www.ladspa.org/download/ladspa_sdk_1.13.tgz"
  sha256 "b5ed3f4f253a0f6c1b7a1f4b8cf62376ca9f51d999650dd822650c43852d306b"

  def install
    ENV.append "LDLIBS", "-ldb -lm"
    chdir "src" do
      system "make", "-f", "makefile"

      bin.install Dir["bin/*"]
      include.install ["src/ladspa.h"]
      (share + "ladspa").install Dir["plugins/*"]
    end
  end
end
