class Repo < Formula
  include Language::Python::Shebang

  desc "Repository tool for Android development"
  homepage "https://source.android.com/source/developing.html"
  url "https://gerrit.googlesource.com/git-repo.git",
      tag:      "v2.16",
      revision: "784e16f3aa941ca3564d823cc686017a161621a1"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "d60183ceadfdc0ea1df63a76f43446ddc88f1968a8b5aa58f59a4e95bbe090aa" # linuxbrew-core
    sha256 cellar: :any_skip_relocation, all:          "d60183ceadfdc0ea1df63a76f43446ddc88f1968a8b5aa58f59a4e95bbe090aa"
  end

  depends_on "python@3.9"

  def install
    bin.install "repo"
    rewrite_shebang detected_python_shebang, bin/"repo"

    doc.install (buildpath/"docs").children
  end

  test do
    assert_match "usage:", shell_output("#{bin}/repo help 2>&1")
  end
end
