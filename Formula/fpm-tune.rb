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
  version "0.1.0-beta.24"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.24/fpm-tune-0.1.0-beta.24-darwin-arm64.tar.gz"
      sha256 "861d4bb6faba530b34de0ea6bea52da8e4b8acd342b6358c9803f7d989bf7218"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.24/fpm-tune-0.1.0-beta.24-darwin-amd64.tar.gz"
      sha256 "5327096cbb62294266f5b0378ebb86d01e21d9206b22b4c0e6aac7f469dba579"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.24/fpm-tune-0.1.0-beta.24-linux-arm64.tar.gz"
      sha256 "3f12e1faf973e8d184f24023d2db009f7fc2b23eea58f99e4c3bb0a7a384fefc"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.24/fpm-tune-0.1.0-beta.24-linux-amd64.tar.gz"
      sha256 "059ba15aaa23c2490250fc829d9acc4774caac92e709417afae1f5461ea2fb69"
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
