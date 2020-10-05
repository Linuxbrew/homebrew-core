class Trunk < Formula
  desc "Build, bundle & ship your Rust WASM application to the web"
  homepage "https://github.com/thedodd/trunk"
  url "https://github.com/thedodd/trunk/archive/v0.6.0.tar.gz"
  sha256 "5492729a6dd027c46d91bacca9b3b87beb3b534c7c6f0f2529f9675600a9e273"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/thedodd/trunk.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e30a89f19b89e892613e044bc11b7297c4a4e319cacb5f9738dc26a0f4f6c9a7" => :catalina
    sha256 "4d60c3565e55e1b72914f32a9a7fd546da25e852ba9fe1fadbcecd9c1b58c313" => :mojave
    sha256 "1951420ea7503d12523b1497deea5655737c7b1b95ca0b70696fec6457b715df" => :high_sierra
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "ConfigOpts {\n", shell_output("#{bin}/trunk config show")
  end
end
