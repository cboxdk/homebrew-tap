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
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.48.1/telemetryd-0.48.1-aarch64-apple-darwin.tar.gz"
      sha256 "8a803a3b1027d0f0b044d153b51984692c6eee9870bfa5811ca310bb5878ea2c"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.48.1/telemetryd-0.48.1-x86_64-apple-darwin.tar.gz"
      sha256 "c9c3d61f8e07e2181d09a857c6891203e6be68fab2185d67a91539ad2a80ee23"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.48.1/telemetryd-0.48.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "9c58e2614f77fc355ee739c4d04b229082833cae38a5890c9dedb730711d2ff2"
    end
    on_intel do
      url "https://github.com/cboxdk/telemetryd/releases/download/v0.48.1/telemetryd-0.48.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "b8431a4dc9f66c72637db0feb6bd768046411b511fa62fa2f78e859a270ce305"
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
