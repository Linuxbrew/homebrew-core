class Tokei < Formula
  desc "Program that allows you to count code, quickly"
  homepage "https://github.com/XAMPPRocky/tokei"
  url "https://github.com/XAMPPRocky/tokei/archive/v11.1.1.tar.gz"
  sha256 "aeb1829ac886f0f4b17e9d16048c61638c0f70342d0638247a377c742c35f99a"

  bottle do
    cellar :any_skip_relocation
    sha256 "384db4f880e7c9cd370da97264275a0022f9438af2d92602bd928aca0d6dd56c" => :catalina
    sha256 "d05d2a5ce945915c1cb62c466b0072c9b0ea291305fa4de7cebdf0b3a9f79bc2" => :mojave
    sha256 "dba9e17f4efdd40743b40e05fd1b571f2de15ef34e980b9c76c88ea908962f91" => :high_sierra
    sha256 "d6d1c4d363dcfd1beb00a11c343a87d10142db8afe0c9f05e4300178acfe5fd4" => :x86_64_linux
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", ".",
                               "--features", "all"
  end

  test do
    (testpath/"lib.rs").write <<~EOS
      #[cfg(test)]
      mod tests {
          #[test]
          fn test() {
              println!("It works!");
          }
      }
    EOS
    system bin/"tokei", "lib.rs"
  end
end
