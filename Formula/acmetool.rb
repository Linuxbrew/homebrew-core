class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme.git",
      :tag      => "v0.0.67",
      :revision => "221ea15246f0bbcf254b350bee272d43a1820285"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f2cf5cfb987a2df2f791c162209039804fd8fd12692da69f52153ec9668e9ca" => :mojave
    sha256 "c4ff2b08c70560072307d64272f105bcd66c05983efbf1e278de9e5012047738" => :high_sierra
    sha256 "7c77a51f12ec154cd5a82f066d547c70f8970a4c5046adf2ab99c600c930a9d5" => :sierra
    sha256 "8f9a190bbda5a5cd209cf7f45bcdfff9c504a7e368458b435c78b1c25c8cb54b" => :el_capitan
  end

  depends_on "go" => :build
  uses_from_macos "libcap"

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/hlandau").mkpath
    ln_sf buildpath, buildpath/"src/github.com/hlandau/acme"

    cd "cmd/acmetool" do
      # https://github.com/hlandau/acme/blob/master/_doc/PACKAGING-PATHS.md
      ldflags = %W[
        -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
        -X github.com/hlandau/acme/hooks.DefaultPath=#{lib}/hooks
        -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
        #{Utils.popen_read("#{buildpath}/src/github.com/hlandau/buildinfo/gen")}
      ]
      system "go", "get", "-d"
      system "go", "build", "-o", bin/"acmetool", "-ldflags", ldflags.join(" ")
    end

    (man8/"acmetool.8").write Utils.popen_read(bin/"acmetool", "--help-man")

    doc.install Dir["_doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  test do
    assert_match "build unknown", shell_output("#{bin}/acmetool --version", 2)
  end
end
