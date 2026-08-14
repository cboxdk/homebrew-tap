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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.43.0/telemetryd-0.43.0-aarch64-apple-darwin.tar.gz"
      sha256 "0ff68b446d8789b3895a0fa549e0c4943614b404164c969fe5a5bfcaf0a659f0"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.43.0/telemetryd-0.43.0-x86_64-apple-darwin.tar.gz"
      sha256 "17debff787d0f831ef28b4cc3dab7964cb73c2a305457aaf1209ba5ead3200b7"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.43.0/telemetryd-0.43.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "da77ba55adb19845d3aad011cd6850e4fae563eb11bddb88029a1f6b135ac73a"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.43.0/telemetryd-0.43.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "eb4f96809d5561fd0d0d5aae9d1b96e3a62ddf156ced440da1f297ebf6908a32"
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
