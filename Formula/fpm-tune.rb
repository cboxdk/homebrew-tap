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
  version "0.1.0-beta.16"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.16/fpm-tune-0.1.0-beta.16-darwin-arm64.tar.gz"
      sha256 "c003fdfa5f4eaafa739021e2a102126ebc1263a3f5dd1aa0d13bee860d434200"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.16/fpm-tune-0.1.0-beta.16-darwin-amd64.tar.gz"
      sha256 "e93020caa142ec32e26a0d7a18734ad6b53cca762687f136e3b9cc012753d13a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.16/fpm-tune-0.1.0-beta.16-linux-arm64.tar.gz"
      sha256 "007179ba6f18e9407ba93b6686bc137854affc7a2f46d018664dfc525beed5e0"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.16/fpm-tune-0.1.0-beta.16-linux-amd64.tar.gz"
      sha256 "316a2e3e9c729d25a2deac431767756f9445e77560e7b87ac76b497ea9af6e49"
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
