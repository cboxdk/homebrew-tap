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
  version "0.1.0-beta.21"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.21/fpm-tune-0.1.0-beta.21-darwin-arm64.tar.gz"
      sha256 "434cdcb679fa2f4d5d7c21dd42c8d50609077b238fa47ca92026e87e738381a9"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.21/fpm-tune-0.1.0-beta.21-darwin-amd64.tar.gz"
      sha256 "b1ccb06106d635f52d7b5dbcc67eccc82899bc73c1fa9ac6de11b6f1bd0411ad"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.21/fpm-tune-0.1.0-beta.21-linux-arm64.tar.gz"
      sha256 "c91c3434fa1155edba976010ef7b209af7258d9d68bb0fb15ceada881d577520"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.21/fpm-tune-0.1.0-beta.21-linux-amd64.tar.gz"
      sha256 "adf75e6588689d61f68002c54230c3781416402e844c18128cd413b3840d3608"
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
