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
  version "0.1.0-beta.9"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.9/fpm-tune-0.1.0-beta.9-darwin-arm64.tar.gz"
      sha256 "a66b18438994f7134008a6bffe8034b113098e93b0df0a9c4b534fd42539b1c8"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.9/fpm-tune-0.1.0-beta.9-darwin-amd64.tar.gz"
      sha256 "b2b53c59f8c40f71a883a21af5069dc823a151ef1c774dea77236ca7fd01729d"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.9/fpm-tune-0.1.0-beta.9-linux-arm64.tar.gz"
      sha256 "8ecd757f26ae60227ab6c5a976fc343639724992aaaf1a75ff5b510dcee3d492"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.9/fpm-tune-0.1.0-beta.9-linux-amd64.tar.gz"
      sha256 "692813ce0a35fd5a250e3815a4c49901752ca13ca5ac43a5090b7edbc9284588"
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
