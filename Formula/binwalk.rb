class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "https://github.com/ReFirmLabs/binwalk"
  url "https://github.com/ReFirmLabs/binwalk/archive/v2.2.0.tar.gz"
  sha256 "f5495f0e4c5575023d593f7c087c367675df6aeb7f4d9a2966e49763924daa27"
  head "https://github.com/ReFirmLabs/binwalk.git"

  bottle do
    cellar :any
    sha256 "e95a1061cccebe8b26ade0344cfec88d987f0344c0ef3ef0dae1ca9d7e2304ec" => :catalina
    sha256 "aade25dafcf47d5a9b4e8c51f8e5aba3fe3c9e09cd2a592aec68a7e685741ee0" => :mojave
    sha256 "ddf7030e8ff4e1f5a2aed178b1ccff13f3e6e5428bd23ab63679fbaeeb89ac80" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "numpy"
  depends_on "p7zip"
  depends_on "python"
  depends_on "scipy"
  depends_on "ssdeep"
  depends_on "xz"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python#{xy}/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
