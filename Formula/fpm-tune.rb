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
  version "0.1.0-beta.14"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.14/fpm-tune-0.1.0-beta.14-darwin-arm64.tar.gz"
      sha256 "3f5b6018acdb761e369449db10f123953a0b64effa45e07d0e8d9b5e6699b500"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.14/fpm-tune-0.1.0-beta.14-darwin-amd64.tar.gz"
      sha256 "a46cc4e8aa69f63f03b31f003f47f91d642ef5398491549192b6a0d45cf54a17"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.14/fpm-tune-0.1.0-beta.14-linux-arm64.tar.gz"
      sha256 "3defffabe04da438452acdc1b39be49b276644b7d3da65c706261556eddfbeb2"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.14/fpm-tune-0.1.0-beta.14-linux-amd64.tar.gz"
      sha256 "b71811af813fb89d2935b0790907c252a5cb698f4a6913b77e59934c41287ba0"
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
