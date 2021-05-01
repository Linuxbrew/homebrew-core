class KubeLinter < Formula
  desc "Static analysis tool for Kubernetes YAML files and Helm charts"
  homepage "https://github.com/stackrox/kube-linter"
  url "https://github.com/stackrox/kube-linter.git",
      tag:      "0.2.1",
      revision: "c53952b8e3bde2d3edfc677ccc05a89298a414d8"
  license "Apache-2.0"
  head "https://github.com/stackrox/kube-linter.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "16da43c3380ea4c9c2b3b4737b2626482e70eb9774a09698d77568eb90d36f49"
    sha256 cellar: :any_skip_relocation, catalina:     "70987ae30c9645bca808e1ee8b1354e28465ad88ea5f29ca9d1d7f599fed8087"
    sha256 cellar: :any_skip_relocation, mojave:       "233d4be1aaa79eb85bd90b32826a5b902fc2cface39b568616d70aabb5fb2463"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fd01e4c6f7cb01c70964b4f9483e405e4b45e06fa4dc8729b5ae1ed487151780"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install ".gobin/kube-linter"
  end

  test do
    (testpath/"pod.yaml").write <<~EOS
      apiVersion: v1
      kind: Pod
      metadata:
        name: homebrew-demo
      spec:
        securityContext:
          runAsUser: 1000
          runAsGroup: 3000
          fsGroup: 2000
        containers:
        - name: homebrew-test
          image: busybox
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
            requests:
              memory: "64Mi"
              cpu: "250m"
          securityContext:
            readOnlyRootFilesystem: true
    EOS

    # Lint pod.yaml for default errors
    assert_match "No lint errors found!", shell_output("#{bin}/kube-linter lint pod.yaml 2>&1").chomp
  end
end
