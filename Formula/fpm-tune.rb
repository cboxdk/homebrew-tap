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
  version "0.1.0-beta.7"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.7/fpm-tune-0.1.0-beta.7-darwin-arm64.tar.gz"
      sha256 "742985f642f1dc3b97dc91bdc9042f8c1b6b256bce7ddc7c3d70201a00e9b9b0"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.7/fpm-tune-0.1.0-beta.7-darwin-amd64.tar.gz"
      sha256 "8761a8c2f49f3c76585740babaaec6feb8582b140bd051b66582d95e9e97d124"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.7/fpm-tune-0.1.0-beta.7-linux-arm64.tar.gz"
      sha256 "97c1971c130a509497bd7e59fcc95853bd834d87326ebd4503decebd84f00839"
    end
    on_intel do
      url "https://github.com/cboxdk/fpm-tune/releases/download/v0.1.0-beta.7/fpm-tune-0.1.0-beta.7-linux-amd64.tar.gz"
      sha256 "5bb10bd80383559e62ffb61e230503488094be96e0b144e42f7401a6cf425444"
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
