class FormatUdf < Formula
  desc "Bash script to format a block device to UDF"
  homepage "https://github.com/JElchison/format-udf"
  url "https://github.com/JElchison/format-udf/archive/1.8.0.tar.gz"
  sha256 "52854097db9044d729fbd7cff012f4b554df01c15225ee17ec159c71da174c8d"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "777bfcdbf07b70e2378c1ee2300729b7293acf88862fb450e38f7b4dc3ca1b85"
  end

  def install
    bin.install "format-udf.sh" => "format-udf"
  end

  test do
    system "#{bin}/format-udf", "-h"
  end
end
