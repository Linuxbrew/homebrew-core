class Kubie < Formula
  desc "Much more powerful alternative to kubectx and kubens"
  homepage "https://blog.sbstp.ca/introducing-kubie/"
  url "https://github.com/sbstp/kubie/archive/v0.13.4.tar.gz"
  sha256 "e93e50c88d49569892beabad574c4bfa29e5e4c09820281285a39c2abd552649"
  license "Zlib"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08fde7c8daffaa4593a98b00938ec2381718e0145e43a8db5b66ca85f0efe5fb"
    sha256 cellar: :any_skip_relocation, big_sur:       "9b25ed65de9eeeaa7195e70098da2113556f40c1455a50fefc011a61c2213452"
    sha256 cellar: :any_skip_relocation, catalina:      "b5c0a89416edf9ba0a50b2a79c1340d1ab1af74f8a99174e16a744aa754573e5"
    sha256 cellar: :any_skip_relocation, mojave:        "1cce6b540a9699bdb4ba0292877183f5155d6bf231f22d4b6b3c427f7a4b637d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb9e7c078bccb38d3198f68fa5118feba2caa58691e3ef26f76d4b4831e52056"
  end

  depends_on "rust" => :build
  depends_on "kubernetes-cli" => :test

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "./completion/kubie.bash"
  end

  test do
    mkdir_p testpath/".kube"
    (testpath/".kube/kubie-test.yaml").write <<~EOS
      apiVersion: v1
      clusters:
      - cluster:
          server: http://0.0.0.0/
        name: kubie-test-cluster
      contexts:
      - context:
          cluster: kubie-test-cluster
          user: kubie-test-user
          namespace: kubie-test-namespace
        name: kubie-test
      current-context: baz
      kind: Config
      preferences: {}
      users:
      - user:
        name: kubie-test-user
    EOS

    assert_match "kubie #{version}", shell_output("#{bin}/kubie --version")

    assert_match "The connection to the server 0.0.0.0 was refused - did you specify the right host or port?",
      shell_output("#{bin}/kubie exec kubie-test kubie-test-namespace kubectl get pod 2>&1")
  end
end
