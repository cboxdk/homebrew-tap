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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.2/telemetryd-0.50.2-aarch64-apple-darwin.tar.gz"
      sha256 "4cef1a6e3b7ae2cebce03be9b67517efcb27b93b9a66c99ba4c80d6f2e91384a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.2/telemetryd-0.50.2-x86_64-apple-darwin.tar.gz"
      sha256 "80c27dc1244d0a54f4ec33cef942b05b11b83aaadab3b219a2aa257526748e25"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.2/telemetryd-0.50.2-aarch64-unknown-linux-musl.tar.gz"
      sha256 "8f476c6ef9b561b697dbd3c1a7c378677435d1a33c06b1ae9cf2d7b0a11a719a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.50.2/telemetryd-0.50.2-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b6e36a85c83e922af37bab9eb8de975d96254de0824edbaf7f31026845a1474b"
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
