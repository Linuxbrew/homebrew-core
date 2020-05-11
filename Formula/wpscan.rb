class Wpscan < Formula
  desc "Black box WordPress vulnerability scanner"
  homepage "https://wpscan.org"
  url "https://github.com/wpscanteam/wpscan/archive/v3.8.1.tar.gz"
  sha256 "d2ba1e66a7c3421dfb756096cd048eacd78e4dcb5504e25153091dba2af047ee"
  head "https://github.com/wpscanteam/wpscan.git"

  bottle do
    cellar :any
    sha256 "6b52086c8d8dd9ad36a244bfbbaf1bc1018a193290e2fa05d16fdd353384bb3e" => :catalina
    sha256 "39acc20f1a3e32e4894a37d61ebcdcc15231b555dc63a4933fa713328a049d66" => :mojave
    sha256 "06ecabf210ad28c3f652b990e58c9772f487eccc0637b27a0d065a95448f52f3" => :high_sierra
    sha256 "6530e37a288da3b46cb5fceff9ecc882ca855a4d2e4902cb7ad527cda1535876" => :x86_64_linux
  end

  depends_on "pkg-config" => :build
  depends_on "ruby"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "xz" # for liblzma
  uses_from_macos "zlib"

  if MacOS.version < :catalina
    depends_on "libffi"
  else
    uses_from_macos "libffi"
  end

  # Fixes the --no-update commandline option
  # https://github.com/wpscanteam/wpscan/pull/1455
  patch do
    url "https://github.com/mistydemeo/wpscan/commit/eed763944642416cb5245b4e0cd281cb161122b4.patch?full_index=1"
    sha256 "0f532dfac5526e75b241e06c17127cd9b608f1450d685a696a2a122e5db545eb"
  end

  def install
    inreplace "lib/wpscan.rb", /DB_DIR.*=.*$/, "DB_DIR = Pathname.new('#{var}/wpscan/db')"
    libexec.install Dir["*"]
    ENV["GEM_HOME"] = libexec
    ENV["BUNDLE_PATH"] = libexec
    ENV["BUNDLE_GEMFILE"] = libexec/"Gemfile"
    system "gem", "install", "bundler"
    bundle = Dir["#{libexec}/**/bundle"].last
    system bundle, "install", "--jobs=#{ENV.make_jobs}"
    wpscan = Dir["#{libexec}/ruby/**/bin/wpscan"].last

    ruby_series = Formula["ruby"].version.to_s.split(".")[0..1].join(".")
    (bin/"wpscan").write <<~EOS
      #!/bin/bash
      GEM_HOME="#{libexec}/ruby/#{ruby_series}.0" BUNDLE_GEMFILE="#{libexec}/Gemfile" \\
        exec "#{bundle}" exec "#{Formula["ruby"].opt_bin}/ruby" \\
        "#{wpscan}" "$@"
    EOS
  end

  def post_install
    # Update database
    system bin/"wpscan", "--update"
  end

  test do
    assert_match "URL: https://wordpress.org/",
                 pipe_output("#{bin}/wpscan --no-update --url https://wordpress.org/")
  end
end
