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
  version "0.1.0-beta.22"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.22/fpm-tune-0.1.0-beta.22-darwin-arm64.tar.gz"
      sha256 "de7bab514159edb8e610d4406e49c036e4025801d1cc418fc4c05b2a786621bf"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.22/fpm-tune-0.1.0-beta.22-darwin-amd64.tar.gz"
      sha256 "611db7d4b188bcaeb687f91d95579eea48ecb689705625e0923fbd8e250e78c3"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.22/fpm-tune-0.1.0-beta.22-linux-arm64.tar.gz"
      sha256 "79afa4680db0dea4297a3d69d2edd5fbb923e26b57c16095c4ab34317ff5e5ee"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.22/fpm-tune-0.1.0-beta.22-linux-amd64.tar.gz"
      sha256 "cc062948642269d1b53da8a31bcfa57dca2ab6977d4a41af509838e3afee374c"
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
