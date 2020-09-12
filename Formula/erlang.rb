class Erlang < Formula
  desc "Programming language for highly scalable real-time systems"
  homepage "https://www.erlang.org/"
  # Download tarball from GitHub; it is served faster than the official tarball.
  url "https://github.com/erlang/otp/archive/OTP-23.0.4.tar.gz"
  sha256 "29e92db80229ec7903f93e5b152c7ca721cc44b58519199ea60b8e0d583faf93"
  license "Apache-2.0"
  head "https://github.com/erlang/otp.git"

  livecheck do
    url :head
    regex(/OTP[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "fe248b7fd250143976a924ee31c8fe72fd4723b8fdf6868065755a715b96a4ca" => :catalina
    sha256 "e0efc8a7cc585bce7d06e5f744342888b3b143b20ec205ab67005d9b511518a5" => :mojave
    sha256 "a625ae5430ffa7cefb267c418c5db1076a33308f146013d4ca8c92cb8a3d72b0" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "fop" => :build
  depends_on "libtool" => :build
  depends_on "openssl@1.1"
  depends_on "wxmac" # for GUI apps like observer

  uses_from_macos "m4" => :build

  resource "html" do
    url "https://www.erlang.org/download/otp_doc_html_23.0.tar.gz"
    mirror "https://fossies.org/linux/misc/otp_doc_html_23.0.tar.gz"
    sha256 "4da19f0de96d1c516d91c621a5ddf20837303cc25695b944e263e3ea46dd31da"
  end

  def install
    # Unset these so that building wx, kernel, compiler and
    # other modules doesn't fail with an unintelligable error.
    %w[LIBS FLAGS AFLAGS ZFLAGS].each { |k| ENV.delete("ERL_#{k}") }

    # Do this if building from a checkout to generate configure
    system "./otp_build", "autoconf" if File.exist? "otp_build"

    args = %W[
      --disable-debug
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-dynamic-ssl-lib
      --enable-hipe
      --enable-sctp
      --enable-shared-zlib
      --enable-smp-support
      --enable-threads
      --enable-wx
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --without-javac
    ]

    if OS.mac?
      args << "--enable-darwin-64bit"
      args << "--enable-kernel-poll" if MacOS.version > :el_capitan
      args << "--with-dynamic-trace=dtrace" if MacOS::CLT.installed?
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Build the doc chunks (manpages are also built by default)
    system "make", "docs", "DOC_TARGETS=chunks"
    system "make", "install-docs"

    doc.install resource("html")
  end

  def caveats
    <<~EOS
      Man pages can be found in:
        #{opt_lib}/erlang/man

      Access them with `erl -man`, or add this directory to MANPATH.
    EOS
  end

  test do
    system "#{bin}/erl", "-noshell", "-eval", "crypto:start().", "-s", "init", "stop"
    (testpath/"factorial").write <<~EOS
      #!#{bin}/escript
      %% -*- erlang -*-
      %%! -smp enable -sname factorial -mnesia debug verbose
      main([String]) ->
          try
              N = list_to_integer(String),
              F = fac(N),
              io:format("factorial ~w = ~w\n", [N,F])
          catch
              _:_ ->
                  usage()
          end;
      main(_) ->
          usage().

      usage() ->
          io:format("usage: factorial integer\n").

      fac(0) -> 1;
      fac(N) -> N * fac(N-1).
    EOS
    chmod 0755, "factorial"
    assert_match "usage: factorial integer", shell_output("./factorial")
    assert_match "factorial 42 = 1405006117752879898543142606244511569936384000000000", shell_output("./factorial 42")
  end
end
