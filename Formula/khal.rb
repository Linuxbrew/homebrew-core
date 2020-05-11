class Khal < Formula
  include Language::Python::Virtualenv

  desc "CLI calendar application"
  homepage "https://lostpackets.de/khal/"
  url "https://github.com/pimutils/khal.git",
      :tag      => "v0.10.1",
      :revision => "a6d7d62388d33459e85dfb5cf57a31c46f120769"
  revision OS.mac? ? 1 : 2
  head "https://github.com/pimutils/khal.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d310786c31a7cdb4529ec2a28b094de5f458961ecd3b4edaa16049474910fa5" => :catalina
    sha256 "8c5773a8e532deee750356a65b1714a02ae5c974b4159263e873f0f70efda0ba" => :mojave
    sha256 "954d7aee32da8561dc770023c0bec4ac914eed5fb31d4fcbf22208cba426bf85" => :high_sierra
    sha256 "d35936b286f8bdcc324d6d14735650c3e2785abbdf95d9e3ea8a05b8f9c409d1" => :x86_64_linux
  end

  depends_on "python@3.8"

  def install
    venv = virtualenv_create(libexec, "python3")
    system libexec/"bin/pip", "install", "-v", "--no-binary", ":all:",
                              "--ignore-installed", buildpath
    system libexec/"bin/pip", "uninstall", "-y", name
    venv.pip_install_and_link buildpath
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    ENV["LANG"] = "en_US.UTF-8"
    (testpath/".calendar/test/01ef8547.ics").write <<~EOS
      BEGIN:VCALENDAR
      VERSION:2.0
      BEGIN:VEVENT
      DTSTART;VALUE=DATE:20130726
      SUMMARY:testevent
      DTEND;VALUE=DATE:20130727
      LAST-MODIFIED:20130725T142824Z
      DTSTAMP:20130725T142824Z
      CREATED:20130725T142824Z
      UID:01ef8547
      END:VEVENT
      END:VCALENDAR
    EOS
    (testpath/".config/khal/config").write <<~EOS
      [calendars]
      [[test]]
      path = #{testpath}/.calendar/test/
      color = light gray
      [sqlite]
      path = #{testpath}/.calendar/khal.db
      [locale]
      firstweekday = 0
      [default]
      default_calendar = test
    EOS
    system "#{bin}/khal", "--no-color", "search", "testevent"
  end
end
