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
  version "0.1.0-beta.17"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.17/fpm-tune-0.1.0-beta.17-darwin-arm64.tar.gz"
      sha256 "0e27cbe057f35e80438d2799750d7daf71bdbfe886463bb5c235e0b35d32c462"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.17/fpm-tune-0.1.0-beta.17-darwin-amd64.tar.gz"
      sha256 "a04fb284f9c66caf2745f69d708e3e37c0d58ad2a5f433eb01a3f796ab40a36a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.17/fpm-tune-0.1.0-beta.17-linux-arm64.tar.gz"
      sha256 "b28137a9fc4c15630d74d258c81a10f5fcf9fb7a0b57ae2bba2286e6dd71184b"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.17/fpm-tune-0.1.0-beta.17-linux-amd64.tar.gz"
      sha256 "2093b4edf1a8eb499cfcd7208eba66ad983a9eacd58f1a1a3743ea58bbcd7bb1"
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
