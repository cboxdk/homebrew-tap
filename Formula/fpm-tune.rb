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
  version "0.1.0-beta.8"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.8/fpm-tune-0.1.0-beta.8-darwin-arm64.tar.gz"
      sha256 "1f1a58c49a9521187acbd6c154c34a8a8a9337d0e5faeb995ac16f87d64d76fe"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.8/fpm-tune-0.1.0-beta.8-darwin-amd64.tar.gz"
      sha256 "a1053990ea2c05ea50dcb8d0f3272b5c02115f6f24bf2482fea61e1697ed286a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.8/fpm-tune-0.1.0-beta.8-linux-arm64.tar.gz"
      sha256 "88a3bd2239fa6735d644f7d6487f1b4fe0ba4db80a582b946aeb102c5298f95a"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.8/fpm-tune-0.1.0-beta.8-linux-amd64.tar.gz"
      sha256 "b057b481f489aed6e1ce903b79cdf90022375f0622dc63721d9cee5ca48de457"
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
