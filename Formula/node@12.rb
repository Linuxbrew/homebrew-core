class NodeAT12 < Formula
  desc "Platform built on V8 to build network applications"
  homepage "https://nodejs.org/"
  url "https://nodejs.org/dist/v12.16.3/node-v12.16.3.tar.xz"
  sha256 "f0559b0829c7f2ac10bf5b3e157e498227e95e26cdb6af814969c49f367359a3"

  bottle do
    cellar :any
    sha256 "e978c9077bf8ca7bb38cf0542859026a8444520d4ce19fd3f10acb93cd631368" => :catalina
    sha256 "a76180ed93325866e5383b05a32125b021c3698d92b828539e00f4df71adae6b" => :mojave
    sha256 "7117a3d812f285cebad6a9c3a125d8f56d057e6970c8c937dc19a51cec9d8bfe" => :high_sierra
    sha256 "6c9f76d9b51c495c7abbec3a750fe6ba722a7b2811fce6c0441a77a73d88ea5f" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "python@3.8" => :build
  depends_on "icu4c"

  def install
    # make sure subprocesses spawned by make are using our Python 3
    ENV["PYTHON"] = Formula["python@3.8"].opt_bin/"python3"

    system "python3", "configure.py", "--prefix=#{prefix}", "--with-intl=system-icu"
    system "make", "install"
  end

  def post_install
    (lib/"node_modules/npm/npmrc").atomic_write("prefix = #{HOMEBREW_PREFIX}\n")
  end

  test do
    path = testpath/"test.js"
    path.write "console.log('hello');"

    output = shell_output("#{bin}/node #{path}").strip
    assert_equal "hello", output
    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"en-EN\").format(1234.56))'").strip
    assert_equal "1,234.56", output

    output = shell_output("#{bin}/node -e 'console.log(new Intl.NumberFormat(\"de-DE\").format(1234.56))'").strip
    assert_equal "1.234,56", output

    # make sure npm can find node
    ENV.prepend_path "PATH", opt_bin
    ENV.delete "NVM_NODEJS_ORG_MIRROR"
    assert_equal which("node"), opt_bin/"node"
    assert_predicate bin/"npm", :exist?, "npm must exist"
    assert_predicate bin/"npm", :executable?, "npm must be executable"
    npm_args = ["-ddd", "--cache=#{HOMEBREW_CACHE}/npm_cache", "--build-from-source"]
    system "#{bin}/npm", *npm_args, "install", ("--unsafe-perm" if Process.uid.zero?), "npm@latest"
    unless head?
      system "#{bin}/npm", *npm_args, "install", ("--unsafe-perm" if Process.uid.zero?), "bufferutil"
    end
    assert_predicate bin/"npx", :exist?, "npx must exist"
    assert_predicate bin/"npx", :executable?, "npx must be executable"
    assert_match "< hello >", shell_output("#{bin}/npx cowsay hello")
  end
end
