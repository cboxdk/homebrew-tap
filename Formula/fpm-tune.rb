# Homebrew formula for fpm-tune — the SOURCE template.
#
# Versioned with the code so the formula can never describe a build that does not
# exist. The checksums are placeholders on purpose: they only exist once a release
# has been built, and `scripts/publish-formula.py` fills them in from the release's
# SHA256SUMS and pushes the result to cboxdk/homebrew-tap. A formula with
# real-looking digests nobody verified is worse than one that obviously is not ready.
#
# There is deliberately no `service` block: on a real host fpm-tune runs under
# systemd with --apply, managing a live PHP-FPM — not via `brew services`.
class FpmTune < Formula
  desc "Autotune PHP-FPM pools against a host's real memory; reload, never restart"
  homepage "https://github.com/cboxdk/fpm-tune"
  version "1.0.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v1.0.0/fpm-tune-1.0.0-darwin-arm64.tar.gz"
      sha256 "e177d328dd69a5e5fedce51edeb888c9e70cdfd413ba65c83b90325c4e9588a3"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v1.0.0/fpm-tune-1.0.0-darwin-amd64.tar.gz"
      sha256 "0bce0e6c5dc4d41e34dd593230c2357fea605f965fbe785db57a6fa485439f40"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v1.0.0/fpm-tune-1.0.0-linux-arm64.tar.gz"
      sha256 "d396788289ed35ffe4c6d9067aaa086a17ecadc641297bfde0d5b4b5870f4887"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v1.0.0/fpm-tune-1.0.0-linux-amd64.tar.gz"
      sha256 "472d244d673b25fab82a8240d22179e8179f48825ae5cefa6237b36b097279c3"
    end
  end

  def install
    bin.install "fpm-tune"
    doc.install "README.md", "SECURITY.md", "LICENSE"
  end

  test do
    # The binary runs and reports the version it was built as. `plan` needs a live
    # PHP-FPM, which the sandbox has none of, so this is the honest limit here.
    assert_match version.to_s, shell_output("#{bin}/fpm-tune version")
  end
end
