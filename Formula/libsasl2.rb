class Libsasl2 < Formula
  desc "Simple Authentication and Security Layer"
  homepage "https://www.cyrusimap.org/sasl/"
  url "ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz"
  sha256 "8fbc5136512b59bb793657f36fadda6359cae3b08f01fd16b3d406f1345b7bc3"
  # tag "linuxbrew"

  bottle do
  end

  # https://packages.debian.org/en/jessie/libsasl2-2
  patch do
    url "https://mirrors.ocf.berkeley.edu/debian/pool/main/c/cyrus-sasl2/cyrus-sasl2_2.1.26.dfsg1-13+deb8u1.debian.tar.xz"
    mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/cyrus-sasl2/cyrus-sasl2_2.1.26.dfsg1-13+deb8u1.debian.tar.xz"
    sha256 "14e00798c41b6fae965211f1af8b47a67d22001146d0019f81af0fc7be9f162f"
    apply %w[
      patches/0001_versioned_symbols.patch
      patches/0002_testsuite.patch
      patches/0003_saslauthd_mdoc.patch
      patches/0005_dbconverter.patch
      patches/0006_library_mutexes.patch
      patches/0009_sasldb_al.patch
      patches/0010_maintainer_mode.patch
      patches/0011_saslauthd_ac_prog_libtool.patch
      patches/0012_xopen_crypt_prototype.patch
      patches/0014_avoid_pic_overwrite.patch
      patches/0017_db4.8.patch
      patches/0025_ld_as_needed.patch
      patches/0026_drop_krb5support_dependency.patch
      patches/0028_autotools_fixes.patch
      patches/0029_ldap_fixes.patch
      patches/0030_dont_use_la_files_for_opening_plugins.patch
      patches/0031_dont_use_-R_when_search_for_sqlite_libraries.patch
      patches/0032_revert_1.103_revision_to_unbreak_GSSAPI.patch
      patches/0033_fix_segfault_in_GSSAPI.patch
      patches/0034_fix_dovecot_authentication.patch
      patches/0035_temporary_multiarch_fixes.patch
      patches/0036_add_reference_to_LDAP_SASLAUTHD_file.patch
      patches/0038_send_imap_logout.patch
      patches/0039_fix_canonuser_ldapdb_garbage_in_out_buffer.patch
      patches/0041_fix_keytab_option_for_MIT_kerberos.patch
      patches/0042_release_server_creds.patch
      patches/0043_types_h.patch
      patches/0044_debug_log_typo_fix.patch
      patches/0045_revert_upstream_soname_bump.patch
      patches/0046_fix_void_return.patch
      patches/properly-create-libsasl2.pc.patch
      patches/bug715040.patch
      patches/early-hangup.patch
      patches/CVE-2013-4122.patch
    ]
  end

  depends_on "openssl"

  def install
    # Deparallelize, else we get weird build errors
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <sasl.h>
      int main(void) {
      }
    EOS

    system ENV.cxx, "-I#{include}", "-L#{lib}", "-I#{Formula["libsasl2"].include}/sasl", "-lsasl2", "-o", "test", "test.cpp"
    system "./test"
  end
end
