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
  version "0.1.0-beta.11"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.11/fpm-tune-0.1.0-beta.11-darwin-arm64.tar.gz"
      sha256 "2efc862aaace54a85370993d2f6d8f1e431ce85a5e1e5ee88fbd6ebbe80ba0e4"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.11/fpm-tune-0.1.0-beta.11-darwin-amd64.tar.gz"
      sha256 "5fb75aafeb8381aa35578dfc239239dbd392da91ca0795e8a461df988a9f11f2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.11/fpm-tune-0.1.0-beta.11-linux-arm64.tar.gz"
      sha256 "f4f56a24f9be97e1aad60c963b038390dc9e7c1bf51e1b2ff103125e0cc73bbb"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.11/fpm-tune-0.1.0-beta.11-linux-amd64.tar.gz"
      sha256 "c5f51706269e9320abade234e80219a5a39a233fb4a86237cd7cec0c64105ccb"
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
