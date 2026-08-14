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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.45.1/telemetryd-0.45.1-aarch64-apple-darwin.tar.gz"
      sha256 "6118be8e564825b34b01ce8ea4ff5620467d52574562974655cd59e504968f34"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.45.1/telemetryd-0.45.1-x86_64-apple-darwin.tar.gz"
      sha256 "18fa8919908ee9452c906396ed05309c96d8d49bb382d43d9528231781fade2b"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.45.1/telemetryd-0.45.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "6f583a2839d4d11519f220df13513c931464699a3a313452abc61a72e1669cac"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.45.1/telemetryd-0.45.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "a3064b0dbca36f2876fd5e2f5663e7772fbf673ea898c89a1fa3bbe59f0c6de2"
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
