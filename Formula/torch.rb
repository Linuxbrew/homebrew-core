class Torch < Formula
  desc "Scientific computing framework"
  homepage "http://torch.ch/"
  url "https://github.com/torch/distro.git", :shallow => false, :branch => "master"
  version "1-alpha"

  depends_on "cmake" => :build
  depends_on "make" => :build
  depends_on "homebrew/science/openblas"

  def install
    ENV["PREFIX"] = "#{prefix}"
    system "./install.sh"
  end
end
