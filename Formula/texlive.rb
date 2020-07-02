class Texlive < Formula
  desc "TeX Live is a free software distribution for the TeX typesetting system"
  homepage "https://www.tug.org/texlive/"
  url "https://www.texlive.info/tlnet-archive/2020/06/30/tlnet/install-tl-unx.tar.gz"
  version "20200630"
  sha256 "6514c395626b8a33812797d54aad97dace82ff4d1002b5b4bf39edf9a43c43f2"
  head "http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"

  depends_on "wget" => :build
  depends_on "fontconfig"
  depends_on :linux
  depends_on "linuxbrew/xorg/libice"
  depends_on "linuxbrew/xorg/libsm"
  depends_on "linuxbrew/xorg/libx11"
  depends_on "linuxbrew/xorg/libxaw"
  depends_on "linuxbrew/xorg/libxext"
  depends_on "linuxbrew/xorg/libxmu"
  depends_on "linuxbrew/xorg/libxpm"
  depends_on "linuxbrew/xorg/libxt"
  depends_on "perl"

  def install
    ohai "Downloading and installing TeX Live. This will take a few minutes."
    ENV["TEXLIVE_INSTALL_PREFIX"] = libexec
    File.write("texlive.profile", <<-END
      selected_scheme scheme-small
      TEXDIR #{prefix}/texlive
      TEXMFCONFIG $TEXMFSYSCONFIG
      TEXMFHOME $TEXMFLOCAL
      TEXMFLOCAL $TEXDIR/texmf-local
      TEXMFSYSCONFIG $TEXDIR/texmf-config
      TEXMFSYSVAR $TEXDIR/texmf-var
      TEXMFVAR $TEXMFSYSVAR
      instopt_adjustpath 0
      instopt_adjustrepo 1
      instopt_letter 0
      instopt_portable 1
      instopt_write18_restricted 1
      tlpdbopt_autobackup 1
      tlpdbopt_backupdir tlpkg/backups
      tlpdbopt_create_formats 1
      tlpdbopt_desktop_integration 1
      tlpdbopt_file_assocs 1
      tlpdbopt_generate_updmap 0
      tlpdbopt_install_docfiles 1
      tlpdbopt_install_srcfiles 1
      tlpdbopt_post_code 1
      tlpdbopt_sys_bin $TEXDIR/bin
      tlpdbopt_sys_info $TEXDIR/share/info
      tlpdbopt_sys_man $TEXDIR/share/man
      tlpdbopt_w32_multi_user 1
    END
    )
    system "./install-tl", "-scheme", "small", "-portable", "-profile", "./texlive.profile"
    man1.install Dir[prefix/"texlive/texmf-dist/doc/man/man1/*"]
    man5.install Dir[prefix/"texlive/texmf-dist/doc/man/man5/*"]
    rm Dir[prefix/"texlive/bin/*/man"]
    Pathname.glob(prefix/"texlive/bin/*/*") { |f| chmod 0555, f.realpath }
    bin.install_symlink Dir[prefix/"texlive/bin/*/*"]
  end

  def caveats
    <<-EOS
      The small (~500 MB) distribution (scheme-small) is installed by default.
      You may install a larger (medium or full) scheme using one of:

          tlmgr install scheme-medium # 1.5 GB
          tlmgr install scheme-full # 6 GB

      For additional information use command:

          tlmgr info schemes
    EOS
  end

  test do
    assert_match "Usage", shell_output("#{bin}/tex --help")
    assert_match "revision", shell_output("#{bin}/tlmgr --version")
  end
end
