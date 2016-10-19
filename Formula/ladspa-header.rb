class LadspaHeader < Formula
  desc "Linux Audio Developer's Simple Plugin API"
  homepage "http://www.ladspa.org"
  url "https://gist.githubusercontent.com/maxim-belkin/721fafe404e78e52cf3bf29a259ea9d2/raw/c50f363ec478e23e0bd5b28ea705b5ae52523abb/ladspa.h"
  version "1.1"
  sha256 "0c73624df742727076c65a9fec4c2806d37bcb7245f62e973d070048b6d333af"

  def install
    mkdir_p include.to_s
    mv "ladspa.h", "#{include}/ladspa.h"
  end

  test do
    assert File.exist?("#{include}/ladspa.h")
  end
end
