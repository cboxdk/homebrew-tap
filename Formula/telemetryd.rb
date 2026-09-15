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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.53.0/telemetryd-0.53.0-aarch64-apple-darwin.tar.gz"
      sha256 "e8c57954a86fb4d62a2bc4157658f3fcc570e0be62135e8973c43ed68df43106"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.53.0/telemetryd-0.53.0-x86_64-apple-darwin.tar.gz"
      sha256 "d5f16cf2a239bed77ca7733041c1e423483e06f60a3f24fdf9d6b2ec21a9e2c9"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.53.0/telemetryd-0.53.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "cd73e30a1878d07aa06561e54a32acd056c470ac99666b99cf52c2cd7b1dc4f0"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.53.0/telemetryd-0.53.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "6dfb2748b0aacde7d98de392ac0ca1fc4f0854d4bc10aeba12c71225b436af20"
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
