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
  version "0.1.0-beta.15"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.15/fpm-tune-0.1.0-beta.15-darwin-arm64.tar.gz"
      sha256 "52eb647f9c976d23651685326221f98a533f2a2a11493c1ee39324678bb1f31a"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.15/fpm-tune-0.1.0-beta.15-darwin-amd64.tar.gz"
      sha256 "ab4e3c7260dcee1a80e5bd840a4c0846f1e45f71faab984dca0e346164b4156b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.15/fpm-tune-0.1.0-beta.15-linux-arm64.tar.gz"
      sha256 "97c4d8aa4094545536320d44b2550181bfd69fc8e989e081d4dde82277cf66ac"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.15/fpm-tune-0.1.0-beta.15-linux-amd64.tar.gz"
      sha256 "2a6a44a8ab89368c72097288f8a5980962eb008446654275e25720447a7867e6"
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
