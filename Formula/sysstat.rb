class Sysstat < Formula
  desc "Performance monitoring tools for Linux"
  homepage "https://github.com/sysstat/sysstat"
  url "https://github.com/sysstat/sysstat/archive/v12.4.0.tar.gz"
  sha256 "1962ed04832d798f5f7e787b9b4caa8b48fe935e854eef5528586b65f3cdd993"
  license "GPL-2.0-or-later"
  head "https://github.com/sysstat/sysstat.git"

  bottle do
    sha256 x86_64_linux: "aa077ffb2d9d042ea734abe7fdd9d9bcde5dd548676f732475ba3570002168ba"
  end

  depends_on :linux

  test do
    assert_match("PID", shell_output("#{bin}/pidstat"))
    assert_match("avg-cpu", shell_output("#{bin}/iostat"))
  end
end
