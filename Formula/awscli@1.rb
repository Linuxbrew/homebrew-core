class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-cli/archive/1.19.90.tar.gz"
  sha256 "041a0c58dc8065284d9400c2e1f4e68440df5e1628436deb7a935b455a9a4a05"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
