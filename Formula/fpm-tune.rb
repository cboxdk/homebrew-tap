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
  version "0.1.0-beta.19"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.19/fpm-tune-0.1.0-beta.19-darwin-arm64.tar.gz"
      sha256 "ed97cf7384b7179eff36d810ba3eaa1654be80a357356d5fb921902b338cde6b"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.19/fpm-tune-0.1.0-beta.19-darwin-amd64.tar.gz"
      sha256 "6417e8ae8c833f695ea0f26697fb4fdf8060d519fac9d2b0856b17717ff21abd"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.19/fpm-tune-0.1.0-beta.19-linux-arm64.tar.gz"
      sha256 "4d138ccb7253ad48a99dd3e7ec59a62fd64ac2c637231719808e4c4d5d36af25"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.19/fpm-tune-0.1.0-beta.19-linux-amd64.tar.gz"
      sha256 "83fcec170e9c52a76b5a45843b6987489ada16c39513628b9b442f1b901c5d18"
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
