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
  version "0.1.0-beta.10"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.10/fpm-tune-0.1.0-beta.10-darwin-arm64.tar.gz"
      sha256 "7f0c14f4d680aba961ad7129c0d5aa3d043907f6310db75a81bd6d8de8ca1b53"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.10/fpm-tune-0.1.0-beta.10-darwin-amd64.tar.gz"
      sha256 "38cb059aba75d57831757a09058739828ca57484c06559bf410c48183d26675b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.10/fpm-tune-0.1.0-beta.10-linux-arm64.tar.gz"
      sha256 "263337711275b9caf31493fcfa9aed1e2b0ff2e9ab46bba199dbb0a6aebda491"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.10/fpm-tune-0.1.0-beta.10-linux-amd64.tar.gz"
      sha256 "9cace7e5d6a41553029a5148f7ac3c368388f7090ba260e0945e39567dc3a229"
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
