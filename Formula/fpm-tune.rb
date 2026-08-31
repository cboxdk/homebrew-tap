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
  version "0.1.0-beta.13"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.13/fpm-tune-0.1.0-beta.13-darwin-arm64.tar.gz"
      sha256 "1f96c1b4a19b22d8f8abcf03101253ff25620a46b0db4658769d033f355059a2"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.13/fpm-tune-0.1.0-beta.13-darwin-amd64.tar.gz"
      sha256 "1580b31c61984e685532b3d1d4cff1fa614682331342387568da9b8d3356e5e0"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.13/fpm-tune-0.1.0-beta.13-linux-arm64.tar.gz"
      sha256 "035903834c78d95301f10a74625f7bf54cf0abfd238cae68422e6c1786a152b6"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.13/fpm-tune-0.1.0-beta.13-linux-amd64.tar.gz"
      sha256 "6bd94d83f219544b79c7d6c83cd05d7e88c88f1bced5a114842e01825b2eeb71"
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
