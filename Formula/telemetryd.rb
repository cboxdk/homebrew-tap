# Homebrew formula for telemetryd.
#
# Lives here so it is versioned with the code it installs, which is what stops the
# formula describing a version that was never built.
#
# `scripts/publish-formula.py` fills in the checksums from a published release and
# pushes the result to cboxdk/homebrew-tap. The placeholders below are deliberate: a
# formula with real-looking checksums that nobody verified is worse than one that
# obviously is not ready.
class Telemetryd < Formula
  desc "Single-binary observability backend: OTLP in, Loki/Tempo/Prometheus APIs out"
  homepage "https://github.com/cboxdk/telemetryd"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.1/telemetryd-0.30.1-aarch64-apple-darwin.tar.gz"
      sha256 "7a3b1dd091f00937cddcee4c4974d255af6ec72fa4ac84d8011b013e2eaf5804"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.1/telemetryd-0.30.1-x86_64-apple-darwin.tar.gz"
      sha256 "d59cc5d1b54122d34475c85da107f03695bfff7cf2b83d6fbbb728e5fd8a97c7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.1/telemetryd-0.30.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "022483550542a3fca11ee75f6f5edd781ef1069657d7ca16f5dc5cbe2deb8ab8"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.30.1/telemetryd-0.30.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "e108aef603331dafd69bf5d96fa660781eed727a428987082f0462461abdef7b"
    end
  end

  def install
    bin.install "telemetryd"
    doc.install "README.md", "COMPATIBILITY.md", "SECURITY.md"
    (etc/"telemetryd").install "telemetryd.toml.example"
  end

  service do
    run [opt_bin/"telemetryd", "serve"]
    keep_alive true
    working_dir var
    log_path var/"log/telemetryd.log"
    error_log_path var/"log/telemetryd.log"
  end

  test do
    # `version` proves the binary runs and reports its build target; `validate` proves
    # it can resolve a complete configuration from nothing, which is the product's
    # central claim.
    assert_match version.to_s, shell_output("#{bin}/telemetryd version")
    assert_match "Configuration is valid",
      shell_output("#{bin}/telemetryd validate --data-dir #{testpath}/data")
  end
end
