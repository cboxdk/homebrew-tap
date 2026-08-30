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
  version "0.1.0-beta.5"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.5/fpm-tune-0.1.0-beta.5-darwin-arm64.tar.gz"
      sha256 "4b1a677d88ce6c30148cebfc66761eed1e6ce8275f007253bbb70d3ac06edcfe"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.5/fpm-tune-0.1.0-beta.5-darwin-amd64.tar.gz"
      sha256 "34ffd04baca9d9d87c83b2a77dc3bb1693d1c7714a0e4ec5f51ced40781fcfbc"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.5/fpm-tune-0.1.0-beta.5-linux-arm64.tar.gz"
      sha256 "79f3bff5f45529f67174a8273dccfd9b581319256b8d16a26dac7d5f7509930a"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.5/fpm-tune-0.1.0-beta.5-linux-amd64.tar.gz"
      sha256 "0997d839985593b4695402a8114c7d19787fcd9bbcbec828eb0ea0a89bcd5f37"
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
