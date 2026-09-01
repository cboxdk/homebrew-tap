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
  version "0.1.0-beta.18"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.18/fpm-tune-0.1.0-beta.18-darwin-arm64.tar.gz"
      sha256 "33585165a9c8778cfcf9a697118ea102ec3b9194aa3c927ed9d183e475df75bb"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.18/fpm-tune-0.1.0-beta.18-darwin-amd64.tar.gz"
      sha256 "95ca8a66310105755749789fadba17edaa00ac45eebc06d04209d5f3ca0a0d78"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.18/fpm-tune-0.1.0-beta.18-linux-arm64.tar.gz"
      sha256 "6b2d85e4860b1a6317ecce9eeb017b600bc5ea51d91fbbe43551e52ebf74ddaf"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.18/fpm-tune-0.1.0-beta.18-linux-amd64.tar.gz"
      sha256 "8e6dbc9c083193cf243f1e2a52ce5018ab8d078ae540d311d18af44b95313ab5"
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
