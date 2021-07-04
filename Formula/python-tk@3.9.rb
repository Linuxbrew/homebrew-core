class PythonTkAT39 < Formula
  desc "Python interface to Tcl/Tk"
  homepage "https://www.python.org/"
  # Keep in sync with python@3.9.
  url "https://www.python.org/ftp/python/3.9.6/Python-3.9.6.tar.xz"
  sha256 "397920af33efc5b97f2e0b57e91923512ef89fc5b3c1d21dbfc8c4828ce0108a"
  license "Python-2.0"

  livecheck do
    url "https://www.python.org/ftp/python/"
    regex(%r{href=.*?v?(3\.9(?:\.\d+)*)/?["' >]}i)
  end


end
