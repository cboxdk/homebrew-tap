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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.56.0/telemetryd-0.56.0-aarch64-apple-darwin.tar.gz"
      sha256 "7903fbab5aa3cbfc987096ee78704f934afccdea35f1347a18dcc05d2bbcf986"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.56.0/telemetryd-0.56.0-x86_64-apple-darwin.tar.gz"
      sha256 "e4ab0a74cb0a439477edbfb811282d422f76bbd79be529168f8bae6643ddab51"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.56.0/telemetryd-0.56.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "1d49b0c099190185ba3306c0def2c692602a2e4e0a89a57594706a45c0feb013"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.56.0/telemetryd-0.56.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "804c2a8c1d5659691556d499cc0428710ecc65e728e0c9221cf2667faa8bf70b"
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
