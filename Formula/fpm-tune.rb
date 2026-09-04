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
  version "0.1.0-beta.23"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.23/fpm-tune-0.1.0-beta.23-darwin-arm64.tar.gz"
      sha256 "53b19e5407af9c0da20d36b22f77f72c6ccc32ab21922362e3cab997b0f78b3f"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.23/fpm-tune-0.1.0-beta.23-darwin-amd64.tar.gz"
      sha256 "7568c4c2edec893bd3159ed97d1fa6624eb1e6d7c40239cc24806bd25b74606c"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.23/fpm-tune-0.1.0-beta.23-linux-arm64.tar.gz"
      sha256 "f8478daa58980e648d7effcec9f74789c3e25187c8c48ed9b29d1f4f1ba4d98d"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.23/fpm-tune-0.1.0-beta.23-linux-amd64.tar.gz"
      sha256 "e0f4272e163eb0cad9bc0a8912606d5e5b747d77d90542bc2380f40ed6c38b34"
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
