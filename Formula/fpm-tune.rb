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
  version "0.1.0-beta.26"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.26/fpm-tune-0.1.0-beta.26-darwin-arm64.tar.gz"
      sha256 "568ff1630db61644b8e9b181f917964700cc9407d12181537469e51611db902f"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.26/fpm-tune-0.1.0-beta.26-darwin-amd64.tar.gz"
      sha256 "3adc71a9018c20f6cd9712d1f61ffb6a09f2189f59dd91b06a350c44cf70470f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.26/fpm-tune-0.1.0-beta.26-linux-arm64.tar.gz"
      sha256 "7e5ee83b95b29dea955364e0afcccbaf4cb380035a3a57560188a36a6de11daa"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.26/fpm-tune-0.1.0-beta.26-linux-amd64.tar.gz"
      sha256 "55bf8d966e104685fcba2429abdc249f8fe45cd93fc6e885a97bd754e3466ee6"
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
