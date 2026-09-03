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
  version "0.1.0-beta.20"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.20/fpm-tune-0.1.0-beta.20-darwin-arm64.tar.gz"
      sha256 "84354ddfd22fbc2a9c39428efd0d58262671468c99fc2889a656ae40d41cd701"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.20/fpm-tune-0.1.0-beta.20-darwin-amd64.tar.gz"
      sha256 "d86b6bb43204628910556cfba88f163fa454c06f4aabb934678d632af3741afe"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.20/fpm-tune-0.1.0-beta.20-linux-arm64.tar.gz"
      sha256 "69e8afa3f0308c45e555bb5f61a801a714dd759c800873d0b0ca1b1ba0d04ac5"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.20/fpm-tune-0.1.0-beta.20-linux-amd64.tar.gz"
      sha256 "47144c70dc84e6460c657005493f9447f0dfbca91486732145f9c79450847444"
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
