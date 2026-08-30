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
  version "0.1.0-beta.4"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.4/fpm-tune-0.1.0-beta.4-aarch64-apple-darwin.tar.gz"
      sha256 "36a4c68a07d916127ad439c7ac5ccd8c0a741f7aea038a1d29185c1ec38aaf7f"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.4/fpm-tune-0.1.0-beta.4-x86_64-apple-darwin.tar.gz"
      sha256 "d006233dcd0bc315ef9ca56ea4ab81cbcf76f92d42fc7fe5859527bd9e7ec3b1"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.4/fpm-tune-0.1.0-beta.4-aarch64-unknown-linux-musl.tar.gz"
      sha256 "86e74b9d826ed4ecd9614e919e0b736825f73b799e5dc3bcf9d17f0642b6fb0a"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.4/fpm-tune-0.1.0-beta.4-x86_64-unknown-linux-musl.tar.gz"
      sha256 "655649865a1ddb10f4f3dbc907f6c64d8a96a5a32eeaaa48a9701d8cbc46b5ce"
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
