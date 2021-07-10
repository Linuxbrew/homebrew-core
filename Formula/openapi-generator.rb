class OpenapiGenerator < Formula
  desc "Generate clients, server & docs from an OpenAPI spec (v2, v3)"
  homepage "https://openapi-generator.tech/"
  url "https://search.maven.org/remotecontent?filepath=org/openapitools/openapi-generator-cli/5.2.0/openapi-generator-cli-5.2.0.jar"
  sha256 "99960608847b5cebce3673450ccf3aa9233b8ae838f27a0d80170776293cd6f9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "66919ad4fbdba7a72fde1bbdd55fc64a047fd2710e161f02fe5ce4ce67b107cf" # linuxbrew-core
  end

  head do
    url "https://github.com/OpenAPITools/openapi-generator.git"

    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "package", "-Dmaven.javadoc.skip=true"
      libexec.install "modules/openapi-generator-cli/target/openapi-generator-cli.jar"
    else
      libexec.install "openapi-generator-cli-#{version}.jar" => "openapi-generator-cli.jar"
    end

    (bin/"openapi-generator").write <<~EOS
      #!/bin/bash
      exec "#{Formula["openjdk"].opt_bin}/java" $JAVA_OPTS -jar "#{libexec}/openapi-generator-cli.jar" "$@"
    EOS
  end

  test do
    (testpath/"minimal.yaml").write <<~EOS
      ---
      swagger: '2.0'
      info:
        version: 0.0.0
        title: Simple API
      host: localhost
      basePath: /v2
      schemes:
        - http
      paths:
        /:
          get:
            operationId: test_operation
            responses:
              200:
                description: OK
    EOS
    system bin/"openapi-generator", "generate", "-i", "minimal.yaml", "-g", "openapi", "-o", "./"
  end
end
