class Karchive < Formula
  desc "Reading, creating, and manipulating file archives"
  homepage "https://api.kde.org/frameworks/karchive/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/karchive-5.79.0.tar.xz"
  sha256 "0cd2bf46cc476b8b56138b3a892688ab70d0ddaa9739350a7421dc77a6210e07"
  license all_of: [
    "BSD-2-Clause",
    "LGPL-2.0-only",
    "LGPL-2.0-or-later",
    any_of: ["LGPL-2.0-only", "LGPL-3.0-only"],
  ]
  revision 1
  head "https://invent.kde.org/frameworks/karchive.git"

  bottle do
    sha256                               arm64_big_sur: "c24a1bde95066fb8b294f2d829c22df06d941b6e774ec9a9f9f01dd6d683db2f"
    sha256                               big_sur:       "6eb76b616530f12a8e740bdc5564261db0dc31b372aca5c0b8294957a6652b1c"
    sha256                               catalina:      "dbe1767ef8c18c47a97212511db52b54a27880b2cf67237adac2584263779f25"
    sha256                               mojave:        "fc4000204bd9b46611254f20bd7b5b42d3adb3bf2faecca928126b1f9c530773"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7360683d04c119f3babe19b3aa3a0ec759b2a960a26766ac215fcf623222269d"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "doxygen" => :build
  depends_on "extra-cmake-modules" => [:build, :test]
  depends_on "graphviz" => :build

  depends_on "qt@5"
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    ENV.delete "CPATH"
    args = std_cmake_args
    args << "-DQt5Core_DIR=#{Formula["qt@5"].opt_prefix/"lib/cmake/Qt5Core"}"

    %w[bzip2gzip
       helloworld
       tarlocalfiles
       unzipper].each do |test_name|
      mkdir test_name.to_s do
        system "cmake", (pkgshare/"examples/#{test_name}"), *args
        system "make"
      end
    end
  end
end
