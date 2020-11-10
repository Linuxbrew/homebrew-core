class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https://github.com/r-darwish/topgrade"
  url "https://github.com/r-darwish/topgrade/archive/v5.9.1.tar.gz"
  sha256 "fea2053a667546fe4f6fa722e3cac2f229c6abdae78f220a4dda25398ba2494d"
  license "GPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "c2c5d73810f31e2953d42efcc364a922d81396e6b18e5894b5df75b9502815e6" => :catalina
    sha256 "1e8755419e934d76ed7ddc179986a87f22980163afd65abe1ea88891d89a5119" => :mojave
    sha256 "f213534b8ee0d27eb358b2cb106efbc450641907a6788d849508b5b11a0a5749" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on xcode: :build if MacOS::CLT.version >= "11.4" # libxml2 module bug

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Configuraton path details: https://github.com/r-darwish/topgrade/blob/HEAD/README.md#configuration-path
    # Sample config file: https://github.com/r-darwish/topgrade/blob/HEAD/config.example.toml
    (testpath/"Library/Preferences/topgrade.toml").write <<~EOS
      # Additional git repositories to pull
      #git_repos = [
      #    "~/src/*/",
      #    "~/.config/something"
      #]
    EOS

    assert_match version.to_s, shell_output("#{bin}/topgrade --version")

    output = shell_output("#{bin}/topgrade -n --only brew")
    assert_match "Dry running: #{HOMEBREW_PREFIX}/bin/brew upgrade", output
    assert_not_match /\sSelf update\s/, output
  end
end
