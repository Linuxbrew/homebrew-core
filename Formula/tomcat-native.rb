class TomcatNative < Formula
  desc "Lets Tomcat use some native resources for performance"
  homepage "https://tomcat.apache.org/native-doc/"
  url "https://www.apache.org/dyn/closer.lua?path=tomcat/tomcat-connectors/native/1.2.30/source/tomcat-native-1.2.30-src.tar.gz"
  mirror "https://archive.apache.org/dist/tomcat/tomcat-connectors/native/1.2.30/source/tomcat-native-1.2.30-src.tar.gz"
  sha256 "92dbf7450907f2f55ef495b22f9fc10584f7bf6dd69c7926c2a1b440e9fed335"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "c1871b1b96ce328260184458fa598eb6664a4afdef2e92f8de6dc2574f2f077e"
    sha256 cellar: :any,                 big_sur:       "8c740bb2aed61249b111b7d40e0c09988c5c5b717ae3af5724f3fbcc616c3dee"
    sha256 cellar: :any,                 catalina:      "8f840854bbab495964cd8e49f47f38db7f8aae94ede0c80cdfa64bf45cbd3610"
    sha256 cellar: :any,                 mojave:        "f4912c4d778256a7104b20ff7d767fb12c2c78db7d321e1e8e7e7f301473d903"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d1633723fee4473208607daf2ff926c3f857ab61f0bcd9a30634ff06dcb03fb" # linuxbrew-core
  end

  depends_on "libtool" => :build
  depends_on "apr"
  depends_on "openjdk"
  depends_on "openssl@1.1"

  def install
    cd "native" do
      system "./configure", "--prefix=#{prefix}",
                            "--with-apr=#{Formula["apr"].opt_prefix}",
                            "--with-java-home=#{Formula["openjdk"].opt_prefix}",
                            "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}"

      # fixes occasional compiling issue: glibtool: compile: specify a tag with `--tag'
      args = ["LIBTOOL=glibtool --tag=CC"]
      # fixes a broken link in mountain lion's apr-1-config (it should be /XcodeDefault.xctoolchain/):
      # usr/local/opt/libtool/bin/glibtool: line 1125:
      # /Applications/Xcode.app/Contents/Developer/Toolchains/OSX10.8.xctoolchain/usr/bin/cc:
      # No such file or directory
      args << "CC=#{ENV.cc}"
      system "make", *args
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      In order for tomcat's APR lifecycle listener to find this library, you'll
      need to add it to java.library.path. This can be done by adding this line
      to $CATALINA_HOME/bin/setenv.sh

        CATALINA_OPTS=\"$CATALINA_OPTS -Djava.library.path=#{opt_lib}\"

      If $CATALINA_HOME/bin/setenv.sh doesn't exist, create it and make it executable.
    EOS
  end
end
